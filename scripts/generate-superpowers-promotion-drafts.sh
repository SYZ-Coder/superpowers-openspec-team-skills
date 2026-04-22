#!/usr/bin/env sh

set -eu

PROJECT_ROOT=$(pwd)
FORCE=0

while [ $# -gt 0 ]; do
  case "$1" in
    --project-root)
      PROJECT_ROOT=${2:?missing value for --project-root}
      shift 2
      ;;
    --force)
      FORCE=1
      shift
      ;;
    -h|--help)
      echo "Usage: sh ./scripts/generate-superpowers-promotion-drafts.sh [--project-root <path>] [--force]"
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      exit 1
      ;;
  esac
done

MEMORY_ROOT="$PROJECT_ROOT/.superpowers-memory"
BACKLOG_PATH="$MEMORY_ROOT/LEARNING_BACKLOG.md"
DRAFT_ROOT="$MEMORY_ROOT/promotion-drafts"

if [ ! -d "$MEMORY_ROOT" ]; then
  echo "Missing .superpowers-memory directory under: $PROJECT_ROOT" >&2
  exit 1
fi

if [ ! -f "$BACKLOG_PATH" ]; then
  echo "Missing LEARNING_BACKLOG.md under: $MEMORY_ROOT" >&2
  exit 1
fi

mkdir -p "$DRAFT_ROOT/checklists" "$DRAFT_ROOT/rules" "$DRAFT_ROOT/skills"

RESULTS_FILE=$(mktemp)
cleanup() {
  rm -f "$RESULTS_FILE"
}
trap cleanup EXIT

emit_draft() {
  candidate_id=$1
  artifact_kind=$2
  draft_path=$3
  title=$4
  trigger=$5
  repeated_pattern=$6
  impact=$7
  evidence_count=$8
  repeated_times=$9
  linked_entries=${10}

  case "$artifact_kind" in
    checklist)
      cat >"$draft_path" <<EOF
# Checklist Draft: $title

- candidate_id: $candidate_id
- artifact: checklist
- source: LEARNING_BACKLOG.md
- generated_at: $(date +%Y-%m-%d)
- linked_entries: $linked_entries

## Why This Exists

- Trigger: $trigger
- Repeated pattern: $repeated_pattern
- Impact: $impact
- Evidence count: $evidence_count
- Repeated times: $repeated_times

## Draft Checklist

1. Confirm the trigger condition is actually present.
2. Follow the proven mitigation or workflow that addressed the repeated pattern.
3. Verify the expected outcome using the project's trusted verification path.
4. Record any new pitfall or refinement back into project memory.

## Review Notes

- Replace the generic steps with project-specific steps before promotion.
- Promote only after human review confirms the checklist is reusable.
EOF
      ;;
    rule)
      cat >"$draft_path" <<EOF
# Project Rule Draft: $title

- candidate_id: $candidate_id
- artifact: rule
- source: LEARNING_BACKLOG.md
- generated_at: $(date +%Y-%m-%d)
- linked_entries: $linked_entries

## Proposed Rule

When the following trigger appears, the team should apply the known handling path instead of rediscovering it:

- Trigger: $trigger
- Repeated pattern: $repeated_pattern

## Why

- Impact: $impact
- Evidence count: $evidence_count
- Repeated times: $repeated_times

## Enforcement Notes

- Decide where this rule belongs: team guide, workflow guardrail, or validator check.
- Convert this draft into a stronger artifact only after review.
EOF
      ;;
    skill)
      skill_name=$(printf "%s" "$candidate_id" | sed -E 's/^learn-[0-9]{4}-[0-9]{2}-[0-9]{2}-//; s/[^A-Za-z0-9._-]+/-/g' | tr 'A-Z' 'a-z')
      cat >"$draft_path" <<EOF
---
name: $skill_name
description: Draft skill generated from learning candidate $candidate_id. Review and refine before promotion.
---

# Skill Draft

## Trigger

$trigger

## Problem Pattern

$repeated_pattern

## Why It Matters

$impact

## Draft Workflow

1. Recognize the trigger condition early.
2. Apply the proven handling path instead of re-discovering it.
3. Verify the result using the project's trusted verification method.
4. Record any refinement back into memory or backlog.

## Evidence

- candidate_id: $candidate_id
- evidence_count: $evidence_count
- repeated_times: $repeated_times
- linked_entries: $linked_entries

## Review Notes

- Replace the generic workflow with concrete, reusable project instructions.
- Do not install or activate this draft automatically.
EOF
      ;;
  esac
}

awk '
  function flush_entry() {
    if (candidate_title == "") return
    if (placeholder || status != "ready_for_promotion" || candidate_id == "") {
      reset_entry()
      return
    }
    artifact = tolower(suggested_artifact)
    if (artifact ~ /checklist/) artifact = "checklist"
    else if (artifact ~ /rule/) artifact = "rule"
    else if (artifact ~ /skill/) artifact = "skill"
    else artifact = ""
    if (artifact == "") {
      reset_entry()
      return
    }
    printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n",
      candidate_id, artifact, candidate_title, trigger, repeated_pattern,
      impact, evidence_count, repeated_times, linked_entries, suggested_artifact
    reset_entry()
  }
  function reset_entry() {
    candidate_title = candidate_id = status = suggested_artifact = ""
    trigger = repeated_pattern = impact = evidence_count = repeated_times = linked_entries = ""
    placeholder = 0
  }
  /^### Candidate:/ {
    flush_entry()
    candidate_title = $0
    sub(/^### Candidate:[[:space:]]*/, "", candidate_title)
    placeholder = (candidate_title ~ /<short-name>/)
    next
  }
  candidate_title != "" {
    if ($0 ~ /candidate_id:[[:space:]]*learn-YYYY-MM-DD-<slug>/) placeholder = 1
    if ($0 ~ /^- candidate_id:/) { candidate_id = $0; sub(/^- candidate_id:[[:space:]]*/, "", candidate_id) }
    else if ($0 ~ /^- status:/) { status = $0; sub(/^- status:[[:space:]]*/, "", status) }
    else if ($0 ~ /^- suggested_artifact:/) { suggested_artifact = $0; sub(/^- suggested_artifact:[[:space:]]*/, "", suggested_artifact) }
    else if ($0 ~ /^- trigger:/) { trigger = $0; sub(/^- trigger:[[:space:]]*/, "", trigger) }
    else if ($0 ~ /^- repeated_pattern:/) { repeated_pattern = $0; sub(/^- repeated_pattern:[[:space:]]*/, "", repeated_pattern) }
    else if ($0 ~ /^- impact:/) { impact = $0; sub(/^- impact:[[:space:]]*/, "", impact) }
    else if ($0 ~ /^- evidence_count:/) { evidence_count = $0; sub(/^- evidence_count:[[:space:]]*/, "", evidence_count) }
    else if ($0 ~ /^- repeated_times:/) { repeated_times = $0; sub(/^- repeated_times:[[:space:]]*/, "", repeated_times) }
    else if ($0 ~ /^- linked_entries:/) { linked_entries = $0; sub(/^- linked_entries:[[:space:]]*/, "", linked_entries) }
  }
  END { flush_entry() }
' "$BACKLOG_PATH" >"$RESULTS_FILE"

echo "Superpowers promotion draft generation"
echo "Project root: $PROJECT_ROOT"
echo ""

GENERATED_COUNT=0
while IFS="$(printf '\t')" read -r candidate_id artifact_kind title trigger repeated_pattern impact evidence_count repeated_times linked_entries suggested_artifact; do
  [ -n "$candidate_id" ] || continue
  case "$artifact_kind" in
    checklist) draft_path="$DRAFT_ROOT/checklists/$candidate_id.md" ;;
    rule) draft_path="$DRAFT_ROOT/rules/$candidate_id.md" ;;
    skill) draft_path="$DRAFT_ROOT/skills/$candidate_id.md" ;;
    *)
      echo "Skipping candidate $candidate_id: unsupported suggested_artifact '$suggested_artifact'"
      continue
      ;;
  esac

  if [ -f "$draft_path" ] && [ "$FORCE" -ne 1 ]; then
    echo "- [$artifact_kind] $candidate_id -> $draft_path (skipped_existing)"
    continue
  fi

  emit_draft "$candidate_id" "$artifact_kind" "$draft_path" "$title" "$trigger" "$repeated_pattern" "$impact" "$evidence_count" "$repeated_times" "$linked_entries"
  echo "- [$artifact_kind] $candidate_id -> $draft_path (written)"
  GENERATED_COUNT=$((GENERATED_COUNT + 1))
done <"$RESULTS_FILE"

if [ "$GENERATED_COUNT" -eq 0 ] && [ ! -s "$RESULTS_FILE" ]; then
  echo "No ready_for_promotion candidates found."
fi
