#!/usr/bin/env sh

set -eu

TOOL="all"
PROJECT_ROOT=$(pwd)
DRY_RUN=0
BACKUP=0
FORCE=0

MARKER_START='<!-- superpowers-memory:start -->'
MARKER_END='<!-- superpowers-memory:end -->'
OPS_FILE=""

cleanup() {
  if [ -n "$OPS_FILE" ] && [ -f "$OPS_FILE" ]; then
    rm -f "$OPS_FILE"
  fi
}

trap cleanup EXIT

while [ $# -gt 0 ]; do
  case "$1" in
    --tool)
      TOOL=${2:?missing value for --tool}
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
    --force)
      FORCE=1
      shift
      ;;
    -h|--help)
      echo "Usage: sh ./scripts/install-superpowers-memory-integration.sh [--tool codex|cursor|claude-code|all] [--project-root <path>] [--dry-run] [--backup] [--force]"
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      exit 1
      ;;
  esac
done

case "$TOOL" in
  codex|cursor|claude-code|all) ;;
  *)
    echo "Unsupported tool: $TOOL" >&2
    exit 1
    ;;
esac

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
REPO_ROOT=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)
TEMPLATE_ROOT="$REPO_ROOT/templates/superpowers-memory/integrations"
BACKUP_ROOT="$PROJECT_ROOT/.ai-skill-backups/superpowers-memory-integration"

backup_if_needed() {
  target_path=$1
  backup_dir=$2
  if [ -e "$target_path" ]; then
    mkdir -p "$backup_dir"
    cp -R "$target_path" "$backup_dir/"
  fi
}

set_managed_block() {
  target_path=$1
  block_path=$2
  backup_dir=$3

  tmp_file=$(mktemp)

  if [ ! -e "$target_path" ] || [ ! -s "$target_path" ]; then
    cp "$block_path" "$tmp_file"
  elif grep -F -q "$MARKER_START" "$target_path"; then
    awk -v start="$MARKER_START" -v end="$MARKER_END" -v blockfile="$block_path" '
      BEGIN {
        while ((getline line < blockfile) > 0) {
          block = block line ORS
        }
        close(blockfile)
        skipping = 0
        replaced = 0
      }
      index($0, start) {
        if (!replaced) {
          printf "%s", block
          replaced = 1
        }
        skipping = 1
        next
      }
      index($0, end) {
        skipping = 0
        next
      }
      !skipping {
        print
      }
      END {
        if (!replaced) {
          if (NR > 0) {
            printf ORS
          }
          printf "%s", block
        }
      }
    ' "$target_path" >"$tmp_file"
  else
    cp "$target_path" "$tmp_file"
    printf "\n\n" >>"$tmp_file"
    cat "$block_path" >>"$tmp_file"
  fi

  if [ "$DRY_RUN" -eq 1 ]; then
    rm -f "$tmp_file"
    return
  fi

  if [ "$BACKUP" -eq 1 ]; then
    backup_if_needed "$target_path" "$backup_dir"
  fi

  mkdir -p "$(dirname "$target_path")"
  mv "$tmp_file" "$target_path"
}

OPERATIONS=""

if [ "$TOOL" = "codex" ] || [ "$TOOL" = "all" ]; then
  OPERATIONS="${OPERATIONS}codex|managed-block|$TEMPLATE_ROOT/codex/AGENTS.memory.md|$PROJECT_ROOT/AGENTS.md
"
fi

if [ "$TOOL" = "cursor" ] || [ "$TOOL" = "all" ]; then
  OPERATIONS="${OPERATIONS}cursor|copy|$TEMPLATE_ROOT/cursor/superpowers-memory.mdc|$PROJECT_ROOT/.cursor/rules/superpowers-memory.mdc
"
fi

if [ "$TOOL" = "claude-code" ] || [ "$TOOL" = "all" ]; then
  OPERATIONS="${OPERATIONS}claude-code|managed-block|$TEMPLATE_ROOT/claude-code/CLAUDE.memory.md|$PROJECT_ROOT/CLAUDE.md
"
fi

OPS_FILE=$(mktemp)
printf "%s" "$OPERATIONS" >"$OPS_FILE"

echo "Superpowers memory integration"
echo "Project root: $PROJECT_ROOT"
echo ""
echo "Install plan:"

while IFS='|' read -r OP_TOOL OP_MODE OP_SOURCE OP_TARGET; do
  [ -n "$OP_TOOL" ] || continue
  STATUS="new"
  if [ -e "$OP_TARGET" ]; then
    STATUS="update"
  fi
  echo "- [$OP_TOOL] $OP_SOURCE -> $OP_TARGET [$STATUS]"
done <"$OPS_FILE"

if [ "$DRY_RUN" -eq 1 ]; then
  echo ""
  echo "Dry run only. No files were written."
  exit 0
fi

if [ "$FORCE" -ne 1 ]; then
  printf "Continue and install memory integration files? (y/N) "
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

while IFS='|' read -r OP_TOOL OP_MODE OP_SOURCE OP_TARGET; do
  [ -n "$OP_TOOL" ] || continue

  if [ ! -f "$OP_SOURCE" ]; then
    echo "Integration template not found: $OP_SOURCE" >&2
    exit 1
  fi

  EXISTS_BEFORE=0
  if [ -e "$OP_TARGET" ]; then
    EXISTS_BEFORE=1
  fi

  if [ "$OP_MODE" = "copy" ]; then
    if [ "$BACKUP" -eq 1 ] && [ "$EXISTS_BEFORE" -eq 1 ]; then
      backup_if_needed "$OP_TARGET" "$BACKUP_ROOT/$TIMESTAMP"
    fi
    mkdir -p "$(dirname "$OP_TARGET")"
    cp "$OP_SOURCE" "$OP_TARGET"
  else
    set_managed_block "$OP_TARGET" "$OP_SOURCE" "$BACKUP_ROOT/$TIMESTAMP"
  fi

  if [ "$EXISTS_BEFORE" -eq 1 ]; then
    RESULTS="${RESULTS}- [$OP_TOOL] $OP_TARGET: updated
"
  else
    RESULTS="${RESULTS}- [$OP_TOOL] $OP_TARGET: installed
"
  fi
done <"$OPS_FILE"

echo ""
echo "Install summary:"
printf "%s" "$RESULTS"

if [ "$BACKUP" -eq 1 ] && [ -d "$BACKUP_ROOT/$TIMESTAMP" ]; then
  echo "Backup created under: $BACKUP_ROOT/$TIMESTAMP"
fi

echo ""
echo "Installed Superpowers memory integration for $TOOL"
echo "Next: reopen the project in your tool so it picks up the new session-start instructions."
