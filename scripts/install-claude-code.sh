#!/usr/bin/env sh

set -eu

BUNDLE="superpowers-openspec-superpowers"
PROJECT_ROOT=$(pwd)
DRY_RUN=0
BACKUP=0
MERGE_CLAUDE_MD=0
FORCE=0
CHECK_DEPS=0

while [ $# -gt 0 ]; do
  case "$1" in
    --bundle)
      BUNDLE=${2:?missing value for --bundle}
      shift 2
      ;;
    --project-root)
      PROJECT_ROOT=${2:?missing value for --project-root}
      shift 2
      ;;
    --dry-run)
      DRY_RUN=1
      shift
      ;;
    --backup)
      BACKUP=1
      shift
      ;;
    --merge-claude-md)
      MERGE_CLAUDE_MD=1
      shift
      ;;
    --force)
      FORCE=1
      shift
      ;;
    --check-dependencies)
      CHECK_DEPS=1
      shift
      ;;
    -h|--help)
      echo "Usage: sh ./scripts/install-claude-code.sh [--bundle <name>] [--project-root <path>] [--dry-run] [--backup] [--merge-claude-md] [--force] [--check-dependencies]"
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      exit 1
      ;;
  esac
done

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
REPO_ROOT=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)
. "$SCRIPT_DIR/common/dependency-check.sh"

merge_claude_md_managed_block() {
  bundle_name=$1
  source_path=$2
  target_path=$3
  start_marker="<!-- BEGIN superpowers-openspec-team-skills:$bundle_name -->"
  end_marker="<!-- END superpowers-openspec-team-skills:$bundle_name -->"
  tmp_file=$(mktemp)

  if [ -f "$target_path" ]; then
    awk -v start="$start_marker" -v end="$end_marker" '
      $0 == start { skip = 1; next }
      $0 == end { skip = 0; next }
      !skip { print }
    ' "$target_path" >"$tmp_file"

    while [ -s "$tmp_file" ] && [ -z "$(tail -n 1 "$tmp_file")" ]; do
      awk 'NR == 1 { lines[NR] = $0; count = 1; next } { lines[++count] = $0 } END { for (i = 1; i < count; i++) print lines[i] }' "$tmp_file" >"$tmp_file.trim"
      mv "$tmp_file.trim" "$tmp_file"
    done

    if [ -s "$tmp_file" ]; then
      printf "\n" >>"$tmp_file"
    fi
  fi

  printf "%s\n\n" "$start_marker" >>"$tmp_file"
  cat "$source_path" >>"$tmp_file"
  printf "\n%s\n" "$end_marker" >>"$tmp_file"
  mv "$tmp_file" "$target_path"
}

case "$BUNDLE" in
  openspec-superpowers-workflow) BUNDLE_FOLDER="openspec-superpowers" ;;
  superpowers-openspec-superpowers-workflow) BUNDLE_FOLDER="superpowers-openspec-superpowers" ;;
  superpowers-feature-workflow) BUNDLE_FOLDER="superpowers-feature" ;;
  openspec-feature-workflow) BUNDLE_FOLDER="openspec-feature" ;;
  superpowers-learning-workflow) BUNDLE_FOLDER="superpowers-learning" ;;
  *) BUNDLE_FOLDER="$BUNDLE" ;;
esac

BUNDLE_ROOT="$REPO_ROOT/dist/claude-code/bundles/$BUNDLE_FOLDER"
BACKUP_ROOT="$PROJECT_ROOT/.ai-skill-backups/claude-code"

if [ ! -d "$BUNDLE_ROOT" ]; then
  echo "Bundle not found: $BUNDLE_ROOT" >&2
  exit 1
fi

MANIFEST="$BUNDLE_ROOT/manifest.json"
MISSING_DEPS=0
if [ -f "$MANIFEST" ]; then
  if ! show_dependency_results "$MANIFEST"; then
    MISSING_DEPS=1
  fi
fi

if [ "$CHECK_DEPS" -eq 1 ]; then
  if [ "$MISSING_DEPS" -ne 0 ]; then
    echo "One or more runtime dependencies are missing." >&2
    exit 1
  fi
  echo "Dependency check passed."
  exit 0
fi

INSTALL_PLAN=$(find "$BUNDLE_ROOT" -mindepth 1 -maxdepth 1 ! -name manifest.json ! -name README.md | sort)
if [ -z "$INSTALL_PLAN" ]; then
  echo "No installable files found in bundle: $BUNDLE_ROOT" >&2
  exit 1
fi

PLAN_FILE=$(mktemp)
trap 'rm -f "$PLAN_FILE"' EXIT
printf "%s\n" "$INSTALL_PLAN" >"$PLAN_FILE"

echo "Claude Code bundle: $BUNDLE"
echo "Source bundle: $BUNDLE_ROOT"
echo "Install target: $PROJECT_ROOT"
echo ""
echo "Install plan:"

EXISTING_COUNT=0
while IFS= read -r SOURCE_PATH; do
  [ -n "$SOURCE_PATH" ] || continue
  NAME=$(basename "$SOURCE_PATH")
  TARGET_PATH="$PROJECT_ROOT/$NAME"
  STATUS="new"
  if [ "$MERGE_CLAUDE_MD" -eq 1 ] && [ "$NAME" = "CLAUDE.md" ] && [ -e "$TARGET_PATH" ]; then
    STATUS="merge"
    EXISTING_COUNT=$((EXISTING_COUNT + 1))
  elif [ -e "$TARGET_PATH" ]; then
    STATUS="overwrite"
    EXISTING_COUNT=$((EXISTING_COUNT + 1))
  fi
  echo "- $NAME -> $TARGET_PATH [$STATUS]"
done <"$PLAN_FILE"

if [ "$DRY_RUN" -eq 1 ]; then
  echo ""
  echo "Dry run only. No files were copied."
  exit 0
fi

if [ "$MISSING_DEPS" -ne 0 ]; then
  echo "Warning: bundle files can be installed, but runtime dependencies are still missing."
  echo "The installed workflow may not run until those dependencies are available."
  echo ""
fi

if [ "$EXISTING_COUNT" -gt 0 ] && [ "$FORCE" -ne 1 ]; then
  printf "One or more target files or directories already exist. Continue and apply the planned changes? (y/N) "
  read ANSWER
  case "$ANSWER" in
    y|Y|yes|YES) ;;
    *)
      echo "Install cancelled."
      exit 0
      ;;
  esac
fi

TIMESTAMP=$(date +"%Y%m%d-%H%M%S")
RESULTS=""

while IFS= read -r SOURCE_PATH; do
  [ -n "$SOURCE_PATH" ] || continue
  NAME=$(basename "$SOURCE_PATH")
  TARGET_PATH="$PROJECT_ROOT/$NAME"
  EXISTS_BEFORE=0
  if [ -e "$TARGET_PATH" ]; then
    EXISTS_BEFORE=1
    if [ "$BACKUP" -eq 1 ]; then
      mkdir -p "$BACKUP_ROOT/$TIMESTAMP"
      cp -R "$TARGET_PATH" "$BACKUP_ROOT/$TIMESTAMP/"
    fi
  fi

  if [ "$MERGE_CLAUDE_MD" -eq 1 ] && [ "$NAME" = "CLAUDE.md" ]; then
    merge_claude_md_managed_block "$BUNDLE_FOLDER" "$SOURCE_PATH" "$TARGET_PATH"
  else
    if [ "$EXISTS_BEFORE" -eq 1 ]; then
      rm -rf "$TARGET_PATH"
    fi
    cp -R "$SOURCE_PATH" "$PROJECT_ROOT/"
  fi

  if [ "$MERGE_CLAUDE_MD" -eq 1 ] && [ "$NAME" = "CLAUDE.md" ] && [ "$EXISTS_BEFORE" -eq 1 ]; then
    RESULTS="${RESULTS}- $NAME: merged
"
  elif [ "$EXISTS_BEFORE" -eq 1 ]; then
    RESULTS="${RESULTS}- $NAME: overwritten
"
  else
    RESULTS="${RESULTS}- $NAME: installed
"
  fi
done <"$PLAN_FILE"

echo ""
echo "Install summary:"
printf "%s" "$RESULTS"

if [ "$BACKUP" -eq 1 ] && [ "$EXISTING_COUNT" -gt 0 ]; then
  echo "Backup created under: $BACKUP_ROOT/$TIMESTAMP"
fi

echo ""
echo "Installed Claude Code bundle '$BUNDLE' into $PROJECT_ROOT"
echo "Next: reopen the repository in Claude Code and invoke the generated slash command."
