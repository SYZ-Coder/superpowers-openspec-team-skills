#!/usr/bin/env sh

set -eu

BUNDLE="superpowers-openspec-superpowers"
OPENCODE_HOME="${OPENCODE_HOME:-$HOME/.config/opencode}"
DRY_RUN=0
BACKUP=0
FORCE=0
CHECK_DEPS=0

while [ $# -gt 0 ]; do
  case "$1" in
    --bundle)
      BUNDLE=${2:?missing value for --bundle}
      shift 2
      ;;
    --codex-home)
      echo "Unknown argument: $1" >&2
      echo "Did you mean --opencode-home ?" >&2
      exit 1
      ;;
    --opencode-home)
      OPENCODE_HOME=${2:?missing value for --opencode-home}
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
    --force)
      FORCE=1
      shift
      ;;
    --check-dependencies)
      CHECK_DEPS=1
      shift
      ;;
    -h|--help)
      echo "Usage: sh ./scripts/install-opencode.sh [--bundle <name>] [--opencode-home <path>] [--dry-run] [--backup] [--force] [--check-dependencies]"
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

case "$BUNDLE" in
  openspec-superpowers-workflow) BUNDLE_FOLDER="openspec-superpowers" ;;
  superpowers-openspec-superpowers-workflow) BUNDLE_FOLDER="superpowers-openspec-superpowers" ;;
  superpowers-feature-workflow) BUNDLE_FOLDER="superpowers-feature" ;;
  openspec-feature-workflow) BUNDLE_FOLDER="openspec-feature" ;;
  superpowers-learning-workflow) BUNDLE_FOLDER="superpowers-learning" ;;
  *) BUNDLE_FOLDER="$BUNDLE" ;;
esac

BUNDLE_ROOT="$REPO_ROOT/dist/opencode/bundles/$BUNDLE_FOLDER"
SKILLS_ROOT="$BUNDLE_ROOT/skills"
TARGET_ROOT="$OPENCODE_HOME/skills"
BACKUP_ROOT="$OPENCODE_HOME/backups/skills"

if [ ! -d "$SKILLS_ROOT" ]; then
  echo "Bundle not found: $SKILLS_ROOT" >&2
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

mkdir -p "$TARGET_ROOT"

INSTALL_PLAN=$(find "$SKILLS_ROOT" -mindepth 1 -maxdepth 1 -type d | sort)
if [ -z "$INSTALL_PLAN" ]; then
  echo "No skill directories found in bundle: $SKILLS_ROOT" >&2
  exit 1
fi

PLAN_FILE=$(mktemp)
trap 'rm -f "$PLAN_FILE"' EXIT
printf "%s\n" "$INSTALL_PLAN" >"$PLAN_FILE"

echo "OpenCode bundle: $BUNDLE"
echo "Source bundle: $BUNDLE_ROOT"
echo "Install target: $TARGET_ROOT"
echo ""
echo "Install plan:"

EXISTING_COUNT=0
while IFS= read -r SOURCE_DIR; do
  [ -n "$SOURCE_DIR" ] || continue
  NAME=$(basename "$SOURCE_DIR")
  TARGET_DIR="$TARGET_ROOT/$NAME"
  STATUS="new"
  if [ -e "$TARGET_DIR" ]; then
    STATUS="overwrite"
    EXISTING_COUNT=$((EXISTING_COUNT + 1))
  fi
  echo "- $NAME -> $TARGET_DIR [$STATUS]"
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
  printf "One or more target skill directories already exist. Continue and overwrite them? (y/N) "
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

while IFS= read -r SOURCE_DIR; do
  [ -n "$SOURCE_DIR" ] || continue
  NAME=$(basename "$SOURCE_DIR")
  TARGET_DIR="$TARGET_ROOT/$NAME"
  EXISTS_BEFORE=0

  if [ -e "$TARGET_DIR" ]; then
    EXISTS_BEFORE=1
  fi

  if [ "$EXISTS_BEFORE" -eq 1 ] && [ "$BACKUP" -eq 1 ]; then
    mkdir -p "$BACKUP_ROOT/$TIMESTAMP"
    cp -R "$TARGET_DIR" "$BACKUP_ROOT/$TIMESTAMP/"
  fi

  if [ "$EXISTS_BEFORE" -eq 1 ]; then
    rm -rf "$TARGET_DIR"
  fi

  cp -R "$SOURCE_DIR" "$TARGET_ROOT/"

  if [ "$EXISTS_BEFORE" -eq 1 ]; then
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
echo "Installed OpenCode bundle '$BUNDLE' to $TARGET_ROOT"
echo "Next: restart or refresh OpenCode, then invoke the skill by name."
