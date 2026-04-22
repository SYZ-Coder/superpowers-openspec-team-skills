param(
  [string]$ProjectRoot = (Get-Location).Path,
  [switch]$Force
)

$ErrorActionPreference = "Stop"

function New-DraftResult {
  param(
    [string]$CandidateId,
    [string]$Artifact,
    [string]$Path,
    [string]$Action
  )

  return [PSCustomObject]@{
    CandidateId = $CandidateId
    Artifact = $Artifact
    Path = $Path
    Action = $Action
  }
}

function Parse-CandidateEntry {
  param(
    [string]$EntryText
  )

  $lines = $EntryText -split "`r?`n"
  $title = (($lines[0] -replace '^### Candidate:\s*', '')).Trim()
  $fields = @{}

  foreach ($line in $lines[1..($lines.Count - 1)]) {
    if ($line -match '^- ([A-Za-z0-9_]+):\s*(.*)$') {
      $fields[$Matches[1]] = $Matches[2].Trim()
    }
  }

  return [PSCustomObject]@{
    Title = $title
    CandidateId = $fields["candidate_id"]
    Status = $fields["status"]
    SuggestedArtifact = $fields["suggested_artifact"]
    Trigger = $fields["trigger"]
    RepeatedPattern = $fields["repeated_pattern"]
    Impact = $fields["impact"]
    EvidenceCount = $fields["evidence_count"]
    RepeatedTimes = $fields["repeated_times"]
    PromoteDecision = $fields["promote_decision"]
    LinkedEntries = $fields["linked_entries"]
    Source = $fields["source"]
    LastUpdated = $fields["last_updated"]
  }
}

function Get-CandidateEntries {
  param(
    [string]$BacklogPath
  )

  if (-not (Test-Path -LiteralPath $BacklogPath)) {
    return @()
  }

  $content = Get-Content -Raw -LiteralPath $BacklogPath
  $matches = [regex]::Matches($content, '(?ms)^### Candidate:.+?(?=^### Candidate:|\z)')
  $entries = @()

  foreach ($match in $matches) {
    $entryText = $match.Value.Trim()
    if ($entryText -match '<short-name>' -or $entryText -match '<slug>' -or $entryText -match 'YYYY-MM-DD') {
      continue
    }
    $entries += Parse-CandidateEntry -EntryText $entryText
  }

  return $entries
}

function Resolve-ArtifactKind {
  param(
    [string]$SuggestedArtifact
  )

  $value = ""
  if ($null -ne $SuggestedArtifact) {
    $value = $SuggestedArtifact.Trim().ToLower()
  }

  switch -Regex ($value) {
    'checklist' { return "checklist" }
    'rule' { return "rule" }
    'skill' { return "skill" }
    default { return $null }
  }
}

function Get-DraftPath {
  param(
    [string]$DraftRoot,
    [string]$ArtifactKind,
    [string]$CandidateId
  )

  $subdir = switch ($ArtifactKind) {
    "checklist" { "checklists" }
    "rule" { "rules" }
    "skill" { "skills" }
  }

  $targetDir = Join-Path $DraftRoot $subdir
  New-Item -ItemType Directory -Force -Path $targetDir | Out-Null

  return Join-Path $targetDir "$CandidateId.md"
}

function Build-ChecklistDraft {
  param(
    [pscustomobject]$Entry
  )

  return @"
# Checklist Draft: $($Entry.Title)

- candidate_id: $($Entry.CandidateId)
- artifact: checklist
- source: LEARNING_BACKLOG.md
- generated_at: $(Get-Date -Format 'yyyy-MM-dd')
- linked_entries: $($Entry.LinkedEntries)

## Why This Exists

- Trigger: $($Entry.Trigger)
- Repeated pattern: $($Entry.RepeatedPattern)
- Impact: $($Entry.Impact)
- Evidence count: $($Entry.EvidenceCount)
- Repeated times: $($Entry.RepeatedTimes)

## Draft Checklist

1. Confirm the trigger condition is actually present.
2. Follow the proven mitigation or workflow that addressed the repeated pattern.
3. Verify the expected outcome using the project's trusted verification path.
4. Record any new pitfall or refinement back into project memory.

## Review Notes

- Replace the generic steps with project-specific steps before promotion.
- Promote only after human review confirms the checklist is reusable.
"@
}

function Build-RuleDraft {
  param(
    [pscustomobject]$Entry
  )

  return @"
# Project Rule Draft: $($Entry.Title)

- candidate_id: $($Entry.CandidateId)
- artifact: rule
- source: LEARNING_BACKLOG.md
- generated_at: $(Get-Date -Format 'yyyy-MM-dd')
- linked_entries: $($Entry.LinkedEntries)

## Proposed Rule

When the following trigger appears, the team should apply the known handling path instead of rediscovering it:

- Trigger: $($Entry.Trigger)
- Repeated pattern: $($Entry.RepeatedPattern)

## Why

- Impact: $($Entry.Impact)
- Evidence count: $($Entry.EvidenceCount)
- Repeated times: $($Entry.RepeatedTimes)

## Enforcement Notes

- Decide where this rule belongs: team guide, workflow guardrail, or validator check.
- Convert this draft into a stronger artifact only after review.
"@
}

function Build-SkillDraft {
  param(
    [pscustomobject]$Entry
  )

  $skillName = (($Entry.CandidateId -replace '^learn-\d{4}-\d{2}-\d{2}-', '') -replace '[^a-zA-Z0-9._-]', '-').ToLower()

  return @"
---
name: $skillName
description: Draft skill generated from learning candidate $($Entry.CandidateId). Review and refine before promotion.
---

# Skill Draft

## Trigger

$($Entry.Trigger)

## Problem Pattern

$($Entry.RepeatedPattern)

## Why It Matters

$($Entry.Impact)

## Draft Workflow

1. Recognize the trigger condition early.
2. Apply the proven handling path instead of re-discovering it.
3. Verify the result using the project's trusted verification method.
4. Record any refinement back into memory or backlog.

## Evidence

- candidate_id: $($Entry.CandidateId)
- evidence_count: $($Entry.EvidenceCount)
- repeated_times: $($Entry.RepeatedTimes)
- linked_entries: $($Entry.LinkedEntries)

## Review Notes

- Replace the generic workflow with concrete, reusable project instructions.
- Do not install or activate this draft automatically.
"@
}

$memoryRoot = Join-Path $ProjectRoot ".superpowers-memory"
$backlogPath = Join-Path $memoryRoot "LEARNING_BACKLOG.md"
$draftRoot = Join-Path $memoryRoot "promotion-drafts"

if (-not (Test-Path -LiteralPath $memoryRoot)) {
  throw "Missing .superpowers-memory directory under: $ProjectRoot"
}

if (-not (Test-Path -LiteralPath $backlogPath)) {
  throw "Missing LEARNING_BACKLOG.md under: $memoryRoot"
}

$entries = Get-CandidateEntries -BacklogPath $backlogPath |
  Where-Object { $_.Status -eq "ready_for_promotion" }

if (-not $entries -or $entries.Count -eq 0) {
  Write-Host "No ready_for_promotion candidates found."
  return
}

$results = @()

foreach ($entry in $entries) {
  $artifactKind = Resolve-ArtifactKind -SuggestedArtifact $entry.SuggestedArtifact
  if (-not $artifactKind) {
    Write-Host "Skipping candidate $($entry.CandidateId): unsupported suggested_artifact '$($entry.SuggestedArtifact)'"
    continue
  }

  if (-not $entry.CandidateId) {
    Write-Host "Skipping candidate '$($entry.Title)': missing candidate_id"
    continue
  }

  $draftPath = Get-DraftPath -DraftRoot $draftRoot -ArtifactKind $artifactKind -CandidateId $entry.CandidateId
  if ((Test-Path -LiteralPath $draftPath) -and -not $Force) {
    $results += New-DraftResult -CandidateId $entry.CandidateId -Artifact $artifactKind -Path $draftPath -Action "skipped_existing"
    continue
  }

  $content = switch ($artifactKind) {
    "checklist" { Build-ChecklistDraft -Entry $entry }
    "rule" { Build-RuleDraft -Entry $entry }
    "skill" { Build-SkillDraft -Entry $entry }
  }

  Set-Content -LiteralPath $draftPath -Value $content -Encoding UTF8
  $action = if (Test-Path -LiteralPath $draftPath) { "written" } else { "unknown" }
  $results += New-DraftResult -CandidateId $entry.CandidateId -Artifact $artifactKind -Path $draftPath -Action $action
}

Write-Host "Superpowers promotion draft generation"
Write-Host "Project root: $ProjectRoot"
Write-Host ""

foreach ($result in $results) {
  Write-Host ("- [{0}] {1} -> {2} ({3})" -f $result.Artifact, $result.CandidateId, $result.Path, $result.Action)
}

if ($results.Count -eq 0) {
  Write-Host "No drafts were generated."
}
