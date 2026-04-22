#!/usr/bin/env sh

set -eu

PROJECT_ROOT=$(pwd)
CHANGED_PATHS=""
SIGNALS=""

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
    -h|--help)
      echo "Usage: sh ./scripts/suggest-superpowers-memory-updates.sh [--project-root <path>] [--changed-paths <comma-separated-paths>] [--signals <comma-separated-signals>]"
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      exit 1
      ;;
  esac
done

RESULTS_FILE=$(mktemp)
cleanup() {
  rm -f "$RESULTS_FILE"
}
trap cleanup EXIT

add_suggestion() {
  target=$1
  reason=$2
  priority=$3
  if grep -F -q "$target|" "$RESULTS_FILE" 2>/dev/null; then
    awk -F'|' -v target="$target" -v reason="$reason" -v priority="$priority" '
      BEGIN { updated = 0 }
      $1 == target {
        if (index($3, reason) == 0) {
          if ($3 == "") { $3 = reason } else { $3 = $3 ";;" reason }
        }
        if ((priority + 0) < ($2 + 0)) {
          $2 = priority
        }
        updated = 1
      }
      { print $1 "|" $2 "|" $3 }
    ' "$RESULTS_FILE" >"$RESULTS_FILE.tmp"
    mv "$RESULTS_FILE.tmp" "$RESULTS_FILE"
  else
    printf "%s|%s|%s\n" "$target" "$priority" "$reason" >>"$RESULTS_FILE"
  fi
}

OLD_IFS=$IFS
IFS=','
for path in $CHANGED_PATHS; do
  lower=$(printf "%s" "$path" | tr 'A-Z' 'a-z')
  [ -n "$lower" ] || continue
  case "$lower" in
    *docs*|*design*|*spec*|*architecture*)
      add_suggestion "PROJECT_CONTEXT.md" "Architecture or design-related files changed." 20
      add_suggestion "DECISIONS.md" "Design-oriented changes often imply a decision or updated rationale." 10
      ;;
  esac
  case "$lower" in
    *test*|*verify*|*validation*|*check*)
      add_suggestion "VERIFICATION_BASELINE.md" "Validation-related files changed." 15
      ;;
  esac
  case "$lower" in
    *bug*|*fix*|*failure*|*compat*|*shell*|*powershell*|*script*)
      add_suggestion "KNOWN_FAILURES.md" "Bug fixes or compatibility work may reveal a repeated failure pattern." 15
      ;;
  esac
  case "$lower" in
    *readme*|*guide*|*agents*|*claude*|*cursor*|*workflow*|*skill*)
      add_suggestion "TEAM_PREFERENCES.md" "Workflow or collaboration-facing files changed." 25
      ;;
  esac
done

for signal in $SIGNALS; do
  lower=$(printf "%s" "$signal" | tr 'A-Z' 'a-z')
  [ -n "$lower" ] || continue
  case "$lower" in
    *decision*|*tradeoff*|*architecture*|*boundary*)
      add_suggestion "DECISIONS.md" "A decision-style signal was provided." 10
      ;;
  esac
  case "$lower" in
    *failure*|*pitfall*|*bug*|*misjudge*|*compat*)
      add_suggestion "KNOWN_FAILURES.md" "A failure-pattern signal was provided." 15
      ;;
  esac
  case "$lower" in
    *verify*|*validation*|*baseline*|*evidence*|*test*)
      add_suggestion "VERIFICATION_BASELINE.md" "A verification-related signal was provided." 15
      ;;
  esac
  case "$lower" in
    *preference*|*team*|*communication*|*workflow*)
      add_suggestion "TEAM_PREFERENCES.md" "A team-preference signal was provided." 25
      ;;
  esac
  case "$lower" in
    *user*|*tone*|*language*|*format*|*communication-style*)
      add_suggestion "USER_PROFILE.md" "A durable user-preference signal was provided." 20
      ;;
  esac
  case "$lower" in
    *agent*|*execution*|*reminder*|*quality*|*operational*)
      add_suggestion "AGENT_NOTES.md" "An agent-execution reminder signal was provided." 20
      ;;
  esac
  case "$lower" in
    *fact*|*context*|*constraint*|*goal*)
      add_suggestion "PROJECT_CONTEXT.md" "A durable project-fact signal was provided." 20
      ;;
  esac
  case "$lower" in
    *reusable*|*repeat*|*promotion*|*candidate*|*checklist*|*rule*|*skill*)
      add_suggestion "LEARNING_BACKLOG.md" "A reusable-pattern signal was provided." 30
      ;;
  esac
done
IFS=$OLD_IFS

add_suggestion "CURRENT_STATE.md" "Always confirm the stopping point before ending a memory-aware session." 1
add_suggestion "session-journal/" "Add a short session note for meaningful work." 2
add_suggestion "SESSION_CLOSE_CHECKLIST.md" "Review the closeout checklist before claiming completion." 3

echo "Superpowers memory update suggestions"
echo "Project root: $PROJECT_ROOT"
echo ""

sort -t'|' -k2,2n -k1,1 "$RESULTS_FILE" | while IFS='|' read -r target priority reasons; do
  [ -n "$target" ] || continue
  echo "- $target"
  echo "  priority=$priority"
  OLD_IFS=$IFS
  IFS=';'
  for reason in $(printf "%s" "$reasons" | sed 's/;;/;/g'); do
    [ -n "$reason" ] || continue
    echo "  - $reason"
  done
  IFS=$OLD_IFS
done
