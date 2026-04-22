#!/usr/bin/env sh

set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
PROJECT_ROOT=$(pwd)
CHANGED_PATHS=""
SIGNALS=""
RUN_VALIDATOR=0

while [ $# -gt 0 ]; do
  case "$1" in
    --project-root)
      PROJECT_ROOT=${2:?missing value for --project-root}
      shift 2
      ;;
    --changed-paths)
      CHANGED_PATHS=${2:?missing value for --changed-paths}
      shift 2
      ;;
    --signals)
      SIGNALS=${2:?missing value for --signals}
      shift 2
      ;;
    --run-validator)
      RUN_VALIDATOR=1
      shift
      ;;
    -h|--help)
      echo "Usage: sh ./scripts/run-superpowers-memory-closeout.sh [--project-root <path>] [--changed-paths <comma-separated-paths>] [--signals <comma-separated-signals>] [--run-validator]"
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      exit 1
      ;;
  esac
done

MEMORY_ROOT="$PROJECT_ROOT/.superpowers-memory"
if [ ! -d "$MEMORY_ROOT" ]; then
  echo "Missing .superpowers-memory directory under: $PROJECT_ROOT" >&2
  exit 1
fi

CHECKLIST_PATH="$MEMORY_ROOT/SESSION_CLOSE_CHECKLIST.md"

echo "Superpowers memory closeout"
echo "Project root: $PROJECT_ROOT"
echo ""

echo "Checklist reference:"
if [ -f "$CHECKLIST_PATH" ]; then
  echo "- $CHECKLIST_PATH"
else
  echo "- SESSION_CLOSE_CHECKLIST.md is missing."
fi
echo "" 

echo "Suggested memory targets:"
sh "$SCRIPT_DIR/suggest-superpowers-memory-updates.sh" --project-root "$PROJECT_ROOT" --changed-paths "$CHANGED_PATHS" --signals "$SIGNALS"

echo ""
echo "Validation:"
if [ "$RUN_VALIDATOR" -eq 1 ]; then
  sh "$SCRIPT_DIR/validate-superpowers-memory.sh" --project-root "$PROJECT_ROOT"
else
  echo "- Skipped. Re-run with --run-validator to validate and refresh memory-index.yaml."
fi

echo ""
echo "Closeout summary:"
if [ -f "$CHECKLIST_PATH" ]; then
  echo "- checklist: available"
else
  echo "- checklist: missing"
fi
if [ -n "$CHANGED_PATHS" ]; then
  changed_count=$(printf "%s" "$CHANGED_PATHS" | awk -F',' '{ print NF }')
else
  changed_count=0
fi
if [ -n "$SIGNALS" ]; then
  signal_count=$(printf "%s" "$SIGNALS" | awk -F',' '{ print NF }')
else
  signal_count=0
fi
echo "- changed_paths: $changed_count"
echo "- signals: $signal_count"
echo "- validator_run: $RUN_VALIDATOR"
echo "- next_step: update the suggested memory files, then re-run with validation if memory changed."
