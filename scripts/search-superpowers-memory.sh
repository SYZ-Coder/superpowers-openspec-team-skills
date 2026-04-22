#!/usr/bin/env sh

set -eu

PROJECT_ROOT=$(pwd)
QUERY=""
TYPE="all"
STATUS=""
MAX_RESULTS=20
SINCE_DAYS=0
SUMMARY=0
RECENT_FIRST=0

while [ $# -gt 0 ]; do
  case "$1" in
    --project-root)
      PROJECT_ROOT=${2:?missing value for --project-root}
      shift 2
      ;;
    --query)
      QUERY=${2:?missing value for --query}
      shift 2
      ;;
    --type)
      TYPE=${2:?missing value for --type}
      shift 2
      ;;
    --status)
      STATUS=${2:?missing value for --status}
      shift 2
      ;;
    --max-results)
      MAX_RESULTS=${2:?missing value for --max-results}
      shift 2
      ;;
    --since-days)
      SINCE_DAYS=${2:?missing value for --since-days}
      shift 2
      ;;
    --summary)
      SUMMARY=1
      shift
      ;;
    --recent-first)
      RECENT_FIRST=1
      shift
      ;;
    -h|--help)
      echo "Usage: sh ./scripts/search-superpowers-memory.sh [--project-root <path>] [--query <text>] [--type <all|project_context|current_state|decisions|known_failures|verification|team_preferences|user_profile|agent_notes|backlog|journal>] [--status <status>] [--max-results <n>] [--since-days <n>] [--summary] [--recent-first]"
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

RESULTS_FILE=$(mktemp)
cleanup() {
  rm -f "$RESULTS_FILE"
}
trap cleanup EXIT

search_entry_file() {
  path=$1
  query=$2
  status=$3
  if [ ! -f "$path" ]; then
    return 0
  fi

  awk -v file_path="$path" -v query="$query" -v status_filter="$status" '
    function trim(s) {
      sub(/^[[:space:]]+/, "", s)
      sub(/[[:space:]]+$/, "", s)
      return s
    }
    function reset_entry() {
      title = status = placeholder = 0
      title_text = ""
    }
    function flush_entry() {
      if (title_text == "") return
      if (placeholder) {
        reset_entry()
        return
      }
      if (status_filter != "" && entry_status != status_filter) {
        reset_entry()
        return
      }
      if (query != "" && entry_body !~ query) {
        reset_entry()
        return
      }
      updated_at = ""
      if (match(entry_body, /^- last_updated:[[:space:]]*(.*)$/m, arr)) {
        updated_at = trim(arr[1])
      }
      printf "ENTRY|%s|%s|%s|%s\n", file_path, title_text, entry_status, updated_at
      reset_entry()
    }
    BEGIN {
      reset_entry()
      entry_body = ""
      entry_status = ""
    }
    /^### / {
      flush_entry()
      title_text = trim($0)
      placeholder = ($0 ~ /<short-title>|<short-name>/)
      entry_body = $0 "\n"
      entry_status = ""
      next
    }
    title_text != "" {
      entry_body = entry_body $0 "\n"
      if ($0 ~ /<slug>|YYYY-MM-DD/) placeholder = 1
      if ($0 ~ /^- status:/) entry_status = trim(substr($0, index($0, ":") + 1))
    }
    END { flush_entry() }
  ' "$path" >>"$RESULTS_FILE"
}

search_flat_file() {
  path=$1
  query=$2
  if [ ! -f "$path" ]; then
    return 0
  fi
  if [ -z "$query" ]; then
    updated_at=$(date -r "$path" "+%Y-%m-%d" 2>/dev/null || stat -f "%Sm" -t "%Y-%m-%d" "$path" 2>/dev/null || echo "")
    printf "ENTRY|%s|file||%s\n" "$path" "$updated_at" >>"$RESULTS_FILE"
    return 0
  fi
  grep -n -F "$query" "$path" 2>/dev/null | while IFS= read -r line; do
    updated_at=$(date -r "$path" "+%Y-%m-%d" 2>/dev/null || stat -f "%Sm" -t "%Y-%m-%d" "$path" 2>/dev/null || echo "")
    printf "ENTRY|%s|%s||%s\n" "$path" "$line" "$updated_at" >>"$RESULTS_FILE"
  done
}

search_journal() {
  path=$1
  query=$2
  if [ ! -d "$path" ]; then
    return 0
  fi
  for file in "$path"/*.md; do
    [ -e "$file" ] || continue
    [ "$(basename "$file")" = "README.md" ] && continue
    if [ -z "$query" ] || grep -q -F "$query" "$file"; then
      updated_at=$(date -r "$file" "+%Y-%m-%d" 2>/dev/null || stat -f "%Sm" -t "%Y-%m-%d" "$file" 2>/dev/null || echo "")
      printf "ENTRY|%s|%s||%s\n" "$file" "$(basename "$file")" "$updated_at" >>"$RESULTS_FILE"
    fi
  done
}

run_for_type() {
  type_name=$1
  case "$type_name" in
    project_context) search_flat_file "$MEMORY_ROOT/PROJECT_CONTEXT.md" "$QUERY" ;;
    current_state) search_flat_file "$MEMORY_ROOT/CURRENT_STATE.md" "$QUERY" ;;
    decisions) search_entry_file "$MEMORY_ROOT/DECISIONS.md" "$QUERY" "$STATUS" ;;
    known_failures) search_entry_file "$MEMORY_ROOT/KNOWN_FAILURES.md" "$QUERY" "$STATUS" ;;
    verification) search_entry_file "$MEMORY_ROOT/VERIFICATION_BASELINE.md" "$QUERY" "$STATUS" ;;
    team_preferences) search_entry_file "$MEMORY_ROOT/TEAM_PREFERENCES.md" "$QUERY" "$STATUS" ;;
    user_profile) search_entry_file "$MEMORY_ROOT/USER_PROFILE.md" "$QUERY" "$STATUS" ;;
    agent_notes) search_entry_file "$MEMORY_ROOT/AGENT_NOTES.md" "$QUERY" "$STATUS" ;;
    backlog) search_entry_file "$MEMORY_ROOT/LEARNING_BACKLOG.md" "$QUERY" "$STATUS" ;;
    journal) search_journal "$MEMORY_ROOT/session-journal" "$QUERY" ;;
    *)
      echo "Unknown type: $type_name" >&2
      exit 1
      ;;
  esac
}

if [ "$TYPE" = "all" ]; then
  for name in project_context current_state decisions known_failures verification team_preferences user_profile agent_notes backlog journal; do
    run_for_type "$name"
  done
else
  run_for_type "$TYPE"
fi

if [ "$SINCE_DAYS" -gt 0 ]; then
  FILTERED_FILE=$(mktemp)
  awk -F'|' -v since_days="$SINCE_DAYS" '
    function days_since(date_value, now_epoch, cmd, updated_epoch) {
      if (date_value == "") return -1
      cmd = "date -d \"" date_value "\" +%s 2>/dev/null"
      cmd | getline updated_epoch
      close(cmd)
      if (updated_epoch == "") {
        cmd = "date -j -f \"%Y-%m-%d\" \"" date_value "\" +%s 2>/dev/null"
        cmd | getline updated_epoch
        close(cmd)
      }
      if (updated_epoch == "") return -1
      return int((now_epoch - updated_epoch) / 86400)
    }
    BEGIN {
      "date +%s" | getline now_epoch
      close("date +%s")
    }
    {
      age = days_since($5, now_epoch)
      if (age >= 0 && age <= since_days) print $0
    }
  ' "$RESULTS_FILE" >"$FILTERED_FILE"
  mv "$FILTERED_FILE" "$RESULTS_FILE"
fi

if [ "$RECENT_FIRST" -eq 1 ]; then
  SORTED_FILE=$(mktemp)
  awk -F'|' '
    {
      print $0
    }
  ' "$RESULTS_FILE" | sort -t'|' -k5,5r -k2,2 >"$SORTED_FILE"
  mv "$SORTED_FILE" "$RESULTS_FILE"
fi

echo "Superpowers memory search"
echo "Project root: $PROJECT_ROOT"
if [ "$SINCE_DAYS" -gt 0 ]; then
  echo "Time window: last $SINCE_DAYS day(s)"
fi
if [ "$TYPE" != "all" ]; then
  echo "Type filter: $TYPE"
fi
if [ "$RECENT_FIRST" -eq 1 ]; then
  echo "Sort order: recent first"
fi
if [ -n "$STATUS" ]; then
  echo "Status filter: $STATUS"
fi
echo ""

if [ ! -s "$RESULTS_FILE" ]; then
  echo "No matching memory entries found."
  exit 0
fi

if [ "$SUMMARY" -eq 1 ]; then
  echo "Summary:"
  echo "- total_results=$(wc -l < "$RESULTS_FILE" | tr -d ' ')"
  awk -F'|' '
    {
      path = $2
      gsub(/^.*\//, "", path)
      kind = path
      if (path ~ /session-journal/) kind = "session-journal"
      if (kind == "") kind = "unknown"
      kind_counts[kind] += 1
      if ($4 != "") status_counts[$4] += 1
    }
    END {
      line = ""
      for (kind in kind_counts) {
        if (line != "") line = line ", "
        line = line kind "=" kind_counts[kind]
      }
      if (line != "") print "- by_kind: " line
      line = ""
      for (status in status_counts) {
        if (line != "") line = line ", "
        line = line status "=" status_counts[status]
      }
      if (line != "") print "- by_status: " line
    }
  ' "$RESULTS_FILE"
  echo ""
fi

awk -F'|' -v max_results="$MAX_RESULTS" '
  count < max_results {
    status_suffix = ""
    if ($4 != "") {
      status_suffix = " [status=" $4 "]"
    }
    date_suffix = ""
    if ($5 != "") {
      date_suffix = " [updated=" $5 "]"
    }
    printf "- %s%s%s\n  %s\n", $3, status_suffix, date_suffix, $2
    count += 1
  }
' "$RESULTS_FILE"
