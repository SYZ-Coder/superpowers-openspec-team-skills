#!/usr/bin/env sh

set -eu

PROJECT_ROOT=$(pwd)
CURRENT_STATE_MAX_AGE_DAYS=14
JOURNAL_MAX_AGE_DAYS=14
BACKLOG_STALE_DAYS=60
DURABLE_ENTRY_STALE_DAYS=120
SKIP_INDEX_WRITE=0
VALIDATOR_VERSION=2

while [ $# -gt 0 ]; do
  case "$1" in
    --project-root)
      PROJECT_ROOT=${2:?missing value for --project-root}
      shift 2
      ;;
    --current-state-max-age-days)
      CURRENT_STATE_MAX_AGE_DAYS=${2:?missing value for --current-state-max-age-days}
      shift 2
      ;;
    --journal-max-age-days)
      JOURNAL_MAX_AGE_DAYS=${2:?missing value for --journal-max-age-days}
      shift 2
      ;;
    --backlog-stale-days)
      BACKLOG_STALE_DAYS=${2:?missing value for --backlog-stale-days}
      shift 2
      ;;
    --durable-entry-stale-days)
      DURABLE_ENTRY_STALE_DAYS=${2:?missing value for --durable-entry-stale-days}
      shift 2
      ;;
    --skip-index-write)
      SKIP_INDEX_WRITE=1
      shift
      ;;
    -h|--help)
      echo "Usage: sh ./scripts/validate-superpowers-memory.sh [--project-root <path>] [--current-state-max-age-days <n>] [--journal-max-age-days <n>] [--backlog-stale-days <n>] [--durable-entry-stale-days <n>] [--skip-index-write]"
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      exit 1
      ;;
  esac
done

RESULTS_FILE=$(mktemp)
ENTRIES_FILE=$(mktemp)
cleanup() {
  rm -f "$RESULTS_FILE" "$ENTRIES_FILE"
}
trap cleanup EXIT

add_result() {
  level=$1
  code=$2
  message=$3
  printf "%s|%s|%s\n" "$level" "$code" "$message" >>"$RESULTS_FILE"
}

file_epoch() {
  path=$1
  if [ ! -e "$path" ]; then
    return 1
  fi
  if stat -c %Y "$path" >/dev/null 2>&1; then
    stat -c %Y "$path"
    return 0
  fi
  if stat -f %m "$path" >/dev/null 2>&1; then
    stat -f %m "$path"
    return 0
  fi
  return 1
}

file_age_days() {
  path=$1
  epoch=$(file_epoch "$path") || return 1
  now=$(date +%s)
  echo $(((now - epoch) / 86400))
}

date_days_ago() {
  days=$1
  if date -d "today - $days days" +%Y-%m-%d >/dev/null 2>&1; then
    date -d "today - $days days" +%Y-%m-%d
    return 0
  fi
  if date -v-"$days"d +%Y-%m-%d >/dev/null 2>&1; then
    date -v-"$days"d +%Y-%m-%d
    return 0
  fi
  date +%Y-%m-%d
}

parse_date_epoch() {
  input=$1
  if [ -z "$input" ]; then
    return 1
  fi
  if date -d "$input" +%s >/dev/null 2>&1; then
    date -d "$input" +%s
    return 0
  fi
  if date -j -f %Y-%m-%d "$input" +%s >/dev/null 2>&1; then
    date -j -f %Y-%m-%d "$input" +%s
    return 0
  fi
  return 1
}

heading_check() {
  path=$1
  heading=$2
  code=$3
  if [ ! -f "$path" ]; then
    return 0
  fi
  if ! grep -F -q "$heading" "$path"; then
    add_result "WARN" "$code" "$(basename "$path") does not contain the expected heading: $heading"
  fi
}

durable_metadata_check() {
  path=$1
  stale_days=$2
  if [ ! -f "$path" ]; then
    return 0
  fi

  awk -v file_name="$(basename "$path")" -v stale_days="$stale_days" '
    function trim(s) {
      sub(/^[[:space:]]+/, "", s)
      sub(/[[:space:]]+$/, "", s)
      return s
    }
    function to_epoch(d,   cmd, out) {
      if (d == "") return 0
      cmd = "date -d \"" d "\" +%s 2>/dev/null"
      if ((cmd | getline out) > 0) {
        close(cmd)
        return out + 0
      }
      close(cmd)
      cmd = "date -j -f %Y-%m-%d \"" d "\" +%s 2>/dev/null"
      if ((cmd | getline out) > 0) {
        close(cmd)
        return out + 0
      }
      close(cmd)
      return 0
    }
    function reset_entry() {
      title = id = status = confidence = last_updated = source = review_after = ""
      placeholder = 0
    }
    function flush_entry(   missing, age, now, review_epoch, updated_epoch) {
      if (title == "") return
      if (placeholder) {
        reset_entry()
        return
      }

      missing = ""
      if (id == "") missing = missing "id, "
      if (status == "") missing = missing "status, "
      if (confidence == "") missing = missing "confidence, "
      if (last_updated == "") missing = missing "last_updated, "
      if (source == "") missing = missing "source, "
      if (review_after == "") missing = missing "review_after, "
      if (missing != "") {
        sub(/, $/, "", missing)
        printf "WARN|ENTRY_METADATA_MISSING|%s entry '\''%s'\'' is missing metadata fields: %s\n", file_name, title, missing
      }

      if (confidence == "verified" && source == "") {
        printf "WARN|VERIFIED_WITHOUT_SOURCE|%s entry '\''%s'\'' is marked verified but has no source evidence.\n", file_name, title
      }

      now_cmd = "date +%s"
      now_cmd | getline now
      close(now_cmd)

      if (review_after != "") {
        review_epoch = to_epoch(review_after)
        if (review_epoch == 0) {
          printf "WARN|REVIEW_AFTER_INVALID|%s entry '\''%s'\'' has an invalid review_after date: %s\n", file_name, title, review_after
        } else if (review_epoch < now && status != "superseded") {
          printf "WARN|REVIEW_OVERDUE|%s entry '\''%s'\'' is overdue for review since %s.\n", file_name, title, review_after
        }
      }

      if (last_updated != "") {
        updated_epoch = to_epoch(last_updated)
        if (updated_epoch == 0) {
          printf "WARN|LAST_UPDATED_INVALID|%s entry '\''%s'\'' has an invalid last_updated date: %s\n", file_name, title, last_updated
        } else if (status != "superseded") {
          age = int((now - updated_epoch) / 86400)
          if (age > stale_days) {
            printf "WARN|DURABLE_ENTRY_STALE|%s entry '\''%s'\'' is %d days old and should be reviewed.\n", file_name, title, age
          }
        }
      }

      if (id != "") {
        printf "ENTRY|%s|%s|%s\n", id, file_name, title >> entries_file
      }

      reset_entry()
    }
    BEGIN {
      entries_file = ENVIRON["ENTRIES_FILE_PATH"]
      reset_entry()
    }
    /^### / {
      flush_entry()
      title = trim($0)
      placeholder = ($0 ~ /<short-title>/)
      next
    }
    title != "" {
      if ($0 ~ /<slug>|YYYY-MM-DD/) placeholder = 1
      if ($0 ~ /^- id:/) { id = trim(substr($0, index($0, ":") + 1)) }
      else if ($0 ~ /^- status:/) { status = trim(substr($0, index($0, ":") + 1)) }
      else if ($0 ~ /^- confidence:/) { confidence = trim(substr($0, index($0, ":") + 1)) }
      else if ($0 ~ /^- last_updated:/) { last_updated = trim(substr($0, index($0, ":") + 1)) }
      else if ($0 ~ /^- source:/) { source = trim(substr($0, index($0, ":") + 1)) }
      else if ($0 ~ /^- review_after:/) { review_after = trim(substr($0, index($0, ":") + 1)) }
    }
    END { flush_entry() }
  ' ENTRIES_FILE_PATH="$ENTRIES_FILE" "$path" >>"$RESULTS_FILE"
}

duplicate_id_check() {
  if [ ! -s "$ENTRIES_FILE" ]; then
    return 0
  fi

  awk -F'|' '
    /^ENTRY\|/ {
      count[$2] += 1
      if (items[$2] == "") {
        items[$2] = $3 ":" $4
      } else {
        items[$2] = items[$2] "; " $3 ":" $4
      }
    }
    END {
      for (id in count) {
        if (count[id] > 1) {
          printf "WARN|ID_CONFLICT|Duplicate durable memory id '\''%s'\'' appears in multiple entries: %s\n", id, items[id]
        }
      }
    }
  ' "$ENTRIES_FILE" >>"$RESULTS_FILE"
}

memory_index_shape_check() {
  path=$1
  if [ ! -f "$path" ]; then
    return 0
  fi
  for key in \
    "version:" \
    "last_full_review:" \
    "memory_health:" \
    "validator:" \
    "learning_backlog:" \
    "stale_durable_entries:" \
    "entries_missing_source:" \
    "entries_missing_review_after:" \
    "review_overdue_entries:" \
    "conflict_summary:" \
    "last_validator_version:" \
    "last_promotion_scan:" \
    "promotion_ready_candidates:"; do
    if ! grep -F -q "$key" "$path"; then
      add_result "WARN" "MEMORY_INDEX_SHAPE" "memory-index.yaml is missing expected key: $key"
    fi
  done
}

backlog_stats() {
  path=$1
  stale_days=$2
  if [ ! -f "$path" ]; then
    echo "0|0|0|0"
    return 0
  fi

  awk -v stale_days="$stale_days" '
    function trim(s) {
      sub(/^[[:space:]]+/, "", s)
      sub(/[[:space:]]+$/, "", s)
      return s
    }
    function to_epoch(d,   cmd, out) {
      if (d == "") return 0
      cmd = "date -d \"" d "\" +%s 2>/dev/null"
      if ((cmd | getline out) > 0) {
        close(cmd)
        return out + 0
      }
      close(cmd)
      cmd = "date -j -f %Y-%m-%d \"" d "\" +%s 2>/dev/null"
      if ((cmd | getline out) > 0) {
        close(cmd)
        return out + 0
      }
      close(cmd)
      return 0
    }
    function flush_entry(   age, epoch) {
      if (candidate == "") return
      if (!placeholder) {
        total += 1
        if (status == "ready_for_promotion") {
          ready += 1
          promotion_ready += 1
        }
        if (last_updated != "") {
          epoch = to_epoch(last_updated)
          if (epoch > 0) {
            age = int((now - epoch) / 86400)
            if (age > stale_days) stale += 1
          }
        }
      }
      candidate = status = last_updated = ""
      placeholder = 0
    }
    BEGIN {
      cmd = "date +%s"
      cmd | getline now
      close(cmd)
    }
    /^### Candidate:/ {
      flush_entry()
      candidate = $0
      placeholder = ($0 ~ /<short-name>/)
      next
    }
    candidate != "" {
      if ($0 ~ /candidate_id: .*<slug>|YYYY-MM-DD/) placeholder = 1
      if ($0 ~ /^- status:/) {
        status = trim(substr($0, index($0, ":") + 1))
      } else if ($0 ~ /^- last_updated:/) {
        last_updated = trim(substr($0, index($0, ":") + 1))
      }
    }
    END {
      flush_entry()
      printf "%d|%d|%d|%d\n", total, ready, stale, promotion_ready
    }
  ' "$path"
}

backlog_promotion_check() {
  path=$1
  if [ ! -f "$path" ]; then
    return 0
  fi

  awk '
    function trim(s) {
      sub(/^[[:space:]]+/, "", s)
      sub(/[[:space:]]+$/, "", s)
      return s
    }
    function reset_entry() {
      title = status = source = review_after = linked_entries = ""
      evidence_count = repeated_times = 0
      placeholder = 0
    }
    function flush_entry(   missing) {
      if (title == "") return
      if (placeholder || status != "ready_for_promotion") {
        reset_entry()
        return
      }
      missing = ""
      if (source == "") missing = missing "source, "
      if (review_after == "") missing = missing "review_after, "
      if (linked_entries == "") missing = missing "linked_entries, "
      if (missing != "") {
        sub(/, $/, "", missing)
        printf "WARN|BACKLOG_PROMOTION_METADATA|%s is ready_for_promotion but missing fields: %s\n", title, missing
      }
      if (evidence_count < 2) {
        printf "WARN|BACKLOG_EVIDENCE_TOO_LOW|%s is ready_for_promotion but evidence_count is below 2.\n", title
      }
      if (repeated_times < 2) {
        printf "WARN|BACKLOG_REPEATED_TOO_LOW|%s is ready_for_promotion but repeated_times is below 2.\n", title
      }
      reset_entry()
    }
    /^### Candidate:/ {
      flush_entry()
      title = trim($0)
      placeholder = ($0 ~ /<short-name>/)
      next
    }
    title != "" {
      if ($0 ~ /candidate_id: .*<slug>|YYYY-MM-DD/) placeholder = 1
      if ($0 ~ /^- status:/) status = trim(substr($0, index($0, ":") + 1))
      else if ($0 ~ /^- source:/) source = trim(substr($0, index($0, ":") + 1))
      else if ($0 ~ /^- review_after:/) review_after = trim(substr($0, index($0, ":") + 1))
      else if ($0 ~ /^- linked_entries:/) linked_entries = trim(substr($0, index($0, ":") + 1))
      else if ($0 ~ /^- evidence_count:/) evidence_count = trim(substr($0, index($0, ":") + 1)) + 0
      else if ($0 ~ /^- repeated_times:/) repeated_times = trim(substr($0, index($0, ":") + 1)) + 0
    }
    END { flush_entry() }
  ' "$path" >>"$RESULTS_FILE"
}

write_memory_index() {
  path=$1
  current_state_age=$2
  journal_age=$3
  conflict_count=$4
  stale_entry_count=$5
  stale_durable_entries=$6
  entries_missing_source=$7
  entries_missing_review_after=$8
  review_overdue_entries=$9
  conflict_summary=${10}
  total_candidates=${11}
  ready_candidates=${12}
  stale_candidates=${13}
  promotion_ready_candidates=${14}
  warning_count=${15}
  error_count=${16}

  today=$(date +%Y-%m-%d)
  active_last_updated=""
  if [ "$current_state_age" -ge 0 ]; then
    active_last_updated=$(date_days_ago "$current_state_age")
  fi

  current_state_fresh=false
  journal_recent=false
  if [ "$current_state_age" -ge 0 ] && [ "$current_state_age" -le "$CURRENT_STATE_MAX_AGE_DAYS" ]; then
    current_state_fresh=true
  fi
  if [ "$journal_age" -ge 0 ] && [ "$journal_age" -le "$JOURNAL_MAX_AGE_DAYS" ]; then
    journal_recent=true
  fi

  cat >"$path" <<EOF
version: 1
last_full_review: $today
active_focus:
  file: CURRENT_STATE.md
  last_updated: $active_last_updated
memory_health:
  current_state_fresh: $current_state_fresh
  journal_recent: $journal_recent
  conflicts_detected: $conflict_count
  stale_entries: $stale_entry_count
  stale_durable_entries: $stale_durable_entries
  entries_missing_source: $entries_missing_source
  entries_missing_review_after: $entries_missing_review_after
  review_overdue_entries: $review_overdue_entries
  warning_count: $warning_count
  error_count: $error_count
  conflict_summary: $conflict_summary
validator:
  last_validator_version: $VALIDATOR_VERSION
  last_promotion_scan: $today
learning_backlog:
  total_candidates: $total_candidates
  ready_for_promotion: $ready_candidates
  stale_candidates: $stale_candidates
  promotion_ready_candidates: $promotion_ready_candidates
EOF
}

count_matches() {
  level=$1
  if [ ! -s "$RESULTS_FILE" ]; then
    echo 0
    return 0
  fi
  grep -c "^$level|" "$RESULTS_FILE" || true
}

MEMORY_ROOT="$PROJECT_ROOT/.superpowers-memory"
LATEST_JOURNAL_AGE=-1
CURRENT_STATE_AGE=-1

if [ ! -d "$MEMORY_ROOT" ]; then
  add_result "ERROR" "MEMORY_ROOT_MISSING" "Missing .superpowers-memory directory."
else
  for name in PROJECT_CONTEXT.md CURRENT_STATE.md LEARNING_BACKLOG.md DECISIONS.md KNOWN_FAILURES.md VERIFICATION_BASELINE.md TEAM_PREFERENCES.md USER_PROFILE.md AGENT_NOTES.md SESSION_CLOSE_CHECKLIST.md memory-index.yaml; do
    if [ ! -e "$MEMORY_ROOT/$name" ]; then
      add_result "WARN" "MEMORY_FILE_MISSING" "Missing recommended memory file: $name"
    fi
  done

  JOURNAL_ROOT="$MEMORY_ROOT/session-journal"
  if [ ! -d "$JOURNAL_ROOT" ]; then
    add_result "WARN" "JOURNAL_DIR_MISSING" "Missing session-journal directory."
  else
    latest_journal=""
    latest_epoch=0
    for journal in "$JOURNAL_ROOT"/*.md; do
      [ -e "$journal" ] || continue
      name=$(basename "$journal")
      if [ "$name" != "README.md" ] && ! printf "%s" "$name" | grep -Eq '^[0-9]{4}-[0-9]{2}-[0-9]{2}-[0-9]{4}-.+\.md$'; then
        add_result "WARN" "JOURNAL_NAME_SHAPE" "Session journal file does not follow the recommended naming pattern: $name"
      fi
      epoch=$(file_epoch "$journal" || echo 0)
      if [ "$epoch" -gt "$latest_epoch" ]; then
        latest_epoch=$epoch
        latest_journal=$journal
      fi
    done

    if [ -z "$latest_journal" ]; then
      add_result "WARN" "JOURNAL_EMPTY" "No session journal entries found."
    else
      LATEST_JOURNAL_AGE=$(file_age_days "$latest_journal" || echo -1)
      if [ "$LATEST_JOURNAL_AGE" -gt "$JOURNAL_MAX_AGE_DAYS" ]; then
        add_result "WARN" "JOURNAL_STALE" "Latest session journal entry is $LATEST_JOURNAL_AGE days old."
      else
        add_result "INFO" "JOURNAL_FRESH" "Latest session journal entry is recent."
      fi
    fi
  fi

  CURRENT_STATE_PATH="$MEMORY_ROOT/CURRENT_STATE.md"
  if CURRENT_STATE_AGE=$(file_age_days "$CURRENT_STATE_PATH" 2>/dev/null); then
    :
  else
    CURRENT_STATE_AGE=-1
  fi
  if [ "$CURRENT_STATE_AGE" -lt 0 ]; then
    add_result "WARN" "CURRENT_STATE_MISSING" "CURRENT_STATE.md is missing."
  elif [ "$CURRENT_STATE_AGE" -gt "$CURRENT_STATE_MAX_AGE_DAYS" ]; then
    add_result "WARN" "CURRENT_STATE_STALE" "CURRENT_STATE.md is $CURRENT_STATE_AGE days old."
  else
    add_result "INFO" "CURRENT_STATE_FRESH" "CURRENT_STATE.md is recent."
  fi

  heading_check "$MEMORY_ROOT/PROJECT_CONTEXT.md" "## Project Summary" "PROJECT_CONTEXT_SHAPE"
  heading_check "$MEMORY_ROOT/CURRENT_STATE.md" "## Active Focus" "CURRENT_STATE_SHAPE"
  heading_check "$MEMORY_ROOT/DECISIONS.md" "## Entry Template" "DECISIONS_SHAPE"
  heading_check "$MEMORY_ROOT/KNOWN_FAILURES.md" "## Entry Template" "KNOWN_FAILURES_SHAPE"
  heading_check "$MEMORY_ROOT/VERIFICATION_BASELINE.md" "## Entry Template" "VERIFICATION_BASELINE_SHAPE"
  heading_check "$MEMORY_ROOT/TEAM_PREFERENCES.md" "## Entry Template" "TEAM_PREFERENCES_SHAPE"
  heading_check "$MEMORY_ROOT/USER_PROFILE.md" "## Entry Template" "USER_PROFILE_SHAPE"
  heading_check "$MEMORY_ROOT/AGENT_NOTES.md" "## Entry Template" "AGENT_NOTES_SHAPE"

  durable_metadata_check "$MEMORY_ROOT/PROJECT_CONTEXT.md" "$DURABLE_ENTRY_STALE_DAYS"
  durable_metadata_check "$MEMORY_ROOT/DECISIONS.md" "$DURABLE_ENTRY_STALE_DAYS"
  durable_metadata_check "$MEMORY_ROOT/KNOWN_FAILURES.md" "$DURABLE_ENTRY_STALE_DAYS"
  durable_metadata_check "$MEMORY_ROOT/VERIFICATION_BASELINE.md" "$DURABLE_ENTRY_STALE_DAYS"
  durable_metadata_check "$MEMORY_ROOT/TEAM_PREFERENCES.md" "$DURABLE_ENTRY_STALE_DAYS"
  durable_metadata_check "$MEMORY_ROOT/USER_PROFILE.md" "$DURABLE_ENTRY_STALE_DAYS"
  durable_metadata_check "$MEMORY_ROOT/AGENT_NOTES.md" "$DURABLE_ENTRY_STALE_DAYS"
  duplicate_id_check
  memory_index_shape_check "$MEMORY_ROOT/memory-index.yaml"

  BACKLOG_PATH="$MEMORY_ROOT/LEARNING_BACKLOG.md"
  if [ -f "$BACKLOG_PATH" ]; then
    if ! grep -F -q "Candidate" "$BACKLOG_PATH"; then
      add_result "INFO" "BACKLOG_EMPTY_OR_MINIMAL" "LEARNING_BACKLOG.md does not yet contain candidate entries."
    fi
    backlog_promotion_check "$BACKLOG_PATH"
    if backlog_age=$(file_age_days "$BACKLOG_PATH" 2>/dev/null); then
      if [ "$backlog_age" -gt "$BACKLOG_STALE_DAYS" ]; then
        add_result "INFO" "BACKLOG_STALE_REVIEW" "LEARNING_BACKLOG.md is $backlog_age days old. Consider reviewing stale candidates."
      fi
    fi
  fi
fi

ERROR_COUNT=$(count_matches ERROR)
WARN_COUNT=$(count_matches WARN)
INFO_COUNT=$(count_matches INFO)

if [ -d "$MEMORY_ROOT" ] && [ "$SKIP_INDEX_WRITE" -ne 1 ]; then
  BACKLOG_STATS=$(backlog_stats "$MEMORY_ROOT/LEARNING_BACKLOG.md" "$BACKLOG_STALE_DAYS")
  TOTAL_CANDIDATES=$(printf "%s" "$BACKLOG_STATS" | awk -F'|' '{print $1}')
  READY_CANDIDATES=$(printf "%s" "$BACKLOG_STATS" | awk -F'|' '{print $2}')
  STALE_CANDIDATES=$(printf "%s" "$BACKLOG_STATS" | awk -F'|' '{print $3}')
  PROMOTION_READY_CANDIDATES=$(printf "%s" "$BACKLOG_STATS" | awk -F'|' '{print $4}')
  CONFLICT_COUNT=$(awk -F'|' '($2 ~ /CONFLICT/) { count += 1 } END { print count + 0 }' "$RESULTS_FILE")
  STALE_ENTRY_COUNT=$(awk -F'|' '($2 ~ /STALE/ || $2 == "ENTRY_METADATA_MISSING" || $2 == "REVIEW_OVERDUE" || $2 == "VERIFIED_WITHOUT_SOURCE") { count += 1 } END { print count + 0 }' "$RESULTS_FILE")
  STALE_DURABLE_ENTRIES=$(awk -F'|' '($2 == "DURABLE_ENTRY_STALE") { count += 1 } END { print count + 0 }' "$RESULTS_FILE")
  ENTRIES_MISSING_SOURCE=$(awk -F'|' '($2 == "ENTRY_METADATA_MISSING" && $3 ~ /source/) { count += 1 } ($2 == "VERIFIED_WITHOUT_SOURCE") { count += 1 } END { print count + 0 }' "$RESULTS_FILE")
  ENTRIES_MISSING_REVIEW_AFTER=$(awk -F'|' '($2 == "ENTRY_METADATA_MISSING" && $3 ~ /review_after/) { count += 1 } END { print count + 0 }' "$RESULTS_FILE")
  REVIEW_OVERDUE_ENTRIES=$(awk -F'|' '($2 == "REVIEW_OVERDUE") { count += 1 } END { print count + 0 }' "$RESULTS_FILE")
  if [ "$CONFLICT_COUNT" -eq 0 ]; then
    CONFLICT_SUMMARY="none"
  else
    CONFLICT_SUMMARY=$(awk -F'|' '($2 ~ /CONFLICT/) { print $2 }' "$RESULTS_FILE" | head -n 3 | tr '\n' ',' | sed 's/,$//')
  fi
  write_memory_index "$MEMORY_ROOT/memory-index.yaml" "$CURRENT_STATE_AGE" "$LATEST_JOURNAL_AGE" "$CONFLICT_COUNT" "$STALE_ENTRY_COUNT" "$STALE_DURABLE_ENTRIES" "$ENTRIES_MISSING_SOURCE" "$ENTRIES_MISSING_REVIEW_AFTER" "$REVIEW_OVERDUE_ENTRIES" "$CONFLICT_SUMMARY" "$TOTAL_CANDIDATES" "$READY_CANDIDATES" "$STALE_CANDIDATES" "$PROMOTION_READY_CANDIDATES" "$WARN_COUNT" "$ERROR_COUNT"
fi

echo "Superpowers memory validation"
echo "Project root: $PROJECT_ROOT"
echo ""

if [ -s "$RESULTS_FILE" ]; then
  while IFS='|' read -r level code message; do
    [ -n "$level" ] || continue
    echo "[$level] $code - $message"
  done <"$RESULTS_FILE"
fi

echo ""
echo "Summary: $ERROR_COUNT error(s), $WARN_COUNT warning(s), $INFO_COUNT info item(s)"

if [ "$ERROR_COUNT" -gt 0 ]; then
  exit 1
fi
