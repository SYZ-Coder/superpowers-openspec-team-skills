#!/usr/bin/env sh

set -eu

BUNDLE="openspec-superpowers"
PROJECT_ROOT=$(pwd)
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
    --check-dependencies)
      CHECK_DEPS=1
      shift
      ;;
    -h|--help)
      echo "Usage: sh ./scripts/install-cursor.sh [--bundle <name>] [--project-root <path>] [--dry-run] [--backup] [--force] [--check-dependencies]"
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

BUNDLE_ROOT="$REPO_ROOT/dist/cursor/bundles/$BUNDLE"
BACKUP_ROOT="$PROJECT_ROOT/.ai-skill-backups/cursor"

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

echo "Cursor bundle: $BUNDLE"
echo "Source bundle: $BUNDLE_ROOT"
echo "Install target: $PROJECT_ROOT"
echo ""
echo "Install plan:"

EXISTING_COUNT=0
for SOURCE_PATH in $INSTALL_PLAN; do
  NAME=$(basename "$SOURCE_PATH")
  TARGET_PATH="$PROJECT_ROOT/$NAME"
  STATUS="new"
  if [ -e "$TARGET_PATH" ]; then
    STATUS="overwrite"
    EXISTING_COUNT=$((EXISTING_COUNT + 1))
  fi
  echo "- $NAME -> $TARGET_PATH [$STATUS]"
done

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
  printf "One or more target files or directories already exist. Continue and overwrite them? (y/N) "
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

for SOURCE_PATH in $INSTALL_PLAN; do
  NAME=$(basename "$SOURCE_PATH")
  TARGET_PATH="$PROJECT_ROOT/$NAME"
  EXISTS_BEFORE=0
  if [ -e "$TARGET_PATH" ]; then
    EXISTS_BEFORE=1
    if [ "$BACKUP" -eq 1 ]; then
      mkdir -p "$BACKUP_ROOT/$TIMESTAMP"
      cp -R "$TARGET_PATH" "$BACKUP_ROOT/$TIMESTAMP/"
    fi
    rm -rf "$TARGET_PATH"
  fi

  cp -R "$SOURCE_PATH" "$PROJECT_ROOT/"

  if [ "$EXISTS_BEFORE" -eq 1 ]; then
    RESULTS="${RESULTS}- $NAME: overwritten
"
  else
    RESULTS="${RESULTS}- $NAME: installed
"
  fi
done

echo ""
echo "Install summary:"
printf "%s" "$RESULTS"

if [ "$BACKUP" -eq 1 ] && [ "$EXISTING_COUNT" -gt 0 ]; then
  echo "Backup created under: $BACKUP_ROOT/$TIMESTAMP"
fi

echo ""
echo "Installed Cursor bundle '$BUNDLE' into $PROJECT_ROOT"
echo "Next: reopen the repository in Cursor and use the bundled rule files."
