#!/usr/bin/env sh

set -eu

PROJECT_ROOT=$(pwd)
DRY_RUN=0
BACKUP=0
FORCE=0

while [ $# -gt 0 ]; do
  case "$1" in
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
      echo "Usage: sh ./scripts/install-superpowers-memory.sh [--project-root <path>] [--dry-run] [--backup] [--force]"
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
TEMPLATE_ROOT="$REPO_ROOT/templates/superpowers-memory"
TARGET_ROOT="$PROJECT_ROOT/.superpowers-memory"
BACKUP_ROOT="$PROJECT_ROOT/.ai-skill-backups/superpowers-memory"

if [ ! -d "$TEMPLATE_ROOT" ]; then
  echo "Memory template not found: $TEMPLATE_ROOT" >&2
  exit 1
fi

INSTALL_PLAN=$(find "$TEMPLATE_ROOT" -mindepth 1 -maxdepth 1 ! -name integrations | sort)
if [ -z "$INSTALL_PLAN" ]; then
  echo "No memory template files found in: $TEMPLATE_ROOT" >&2
  exit 1
fi

PLAN_FILE=$(mktemp)
trap 'rm -f "$PLAN_FILE"' EXIT
printf "%s\n" "$INSTALL_PLAN" >"$PLAN_FILE"

echo "Superpowers memory scaffold"
echo "Template source: $TEMPLATE_ROOT"
echo "Install target: $TARGET_ROOT"
echo ""
echo "Install plan:"

EXISTING_COUNT=0
while IFS= read -r SOURCE_PATH; do
  [ -n "$SOURCE_PATH" ] || continue
  NAME=$(basename "$SOURCE_PATH")
  TARGET_PATH="$TARGET_ROOT/$NAME"
  STATUS="new"
  if [ -e "$TARGET_PATH" ]; then
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

mkdir -p "$TARGET_ROOT"

if [ "$EXISTING_COUNT" -gt 0 ] && [ "$FORCE" -ne 1 ]; then
  printf "One or more memory files already exist. Continue and overwrite them? (y/N) "
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
  TARGET_PATH="$TARGET_ROOT/$NAME"
  EXISTS_BEFORE=0
  if [ -e "$TARGET_PATH" ]; then
    EXISTS_BEFORE=1
    if [ "$BACKUP" -eq 1 ]; then
      mkdir -p "$BACKUP_ROOT/$TIMESTAMP"
      cp -R "$TARGET_PATH" "$BACKUP_ROOT/$TIMESTAMP/"
    fi
    rm -rf "$TARGET_PATH"
  fi

  cp -R "$SOURCE_PATH" "$TARGET_ROOT/"

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
echo "Installed Superpowers memory scaffold into $TARGET_ROOT"
echo "Next: fill in PROJECT_CONTEXT.md, update CURRENT_STATE.md, and keep session-journal entries for future sessions."
