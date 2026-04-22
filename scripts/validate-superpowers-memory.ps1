param(
  [string]$ProjectRoot = (Get-Location).Path,
  [int]$CurrentStateMaxAgeDays = 14,
  [int]$JournalMaxAgeDays = 14,
  [int]$BacklogStaleDays = 60,
  [int]$DurableEntryStaleDays = 120,
  [switch]$SkipIndexWrite
)

$ErrorActionPreference = "Stop"
$ValidatorVersion = "2"

function Add-CheckResult {
  param(
    [System.Collections.Generic.List[object]]$Results,
    [string]$Level,
    [string]$Code,
    [string]$Message
  )

  $Results.Add([PSCustomObject]@{
    Level = $Level
    Code = $Code
    Message = $Message
  }) | Out-Null
}

function Test-RequiredFile {
  param(
    [string]$Path
  )

  return Test-Path -LiteralPath $Path
}

function Get-FileAgeDays {
  param(
    [string]$Path
  )

  if (-not (Test-Path -LiteralPath $Path)) {
    return $null
  }

  return [int]((Get-Date) - (Get-Item -LiteralPath $Path).LastWriteTime).TotalDays
}

function Get-MetadataValue {
  param(
    [string]$Entry,
    [string]$FieldName
  )

  $pattern = "(?m)^-\s*" + [regex]::Escape($FieldName) + ":\s*(.*)$"
  $match = [regex]::Match($Entry, $pattern)
  if (-not $match.Success) {
    return $null
  }

  return $match.Groups[1].Value.Trim()
}

function Get-EntryMatches {
  param(
    [string]$Path
  )

  if (-not (Test-Path -LiteralPath $Path)) {
    return @()
  }

  $content = Get-Content -Raw -LiteralPath $Path
  return [regex]::Matches($content, '(?ms)^### .+?(?=^### |\z)')
}

function Test-Heading {
  param(
    [string]$Path,
    [string]$Heading,
    [System.Collections.Generic.List[object]]$Results,
    [string]$Code
  )

  if (-not (Test-Path -LiteralPath $Path)) {
    return
  }

  $content = Get-Content -Raw -LiteralPath $Path
  if ($content -notmatch [regex]::Escape($Heading)) {
    Add-CheckResult -Results $Results -Level "WARN" -Code $Code -Message "$(Split-Path -Leaf $Path) does not contain the expected heading: $Heading"
  }
}

function Test-DurableEntries {
  param(
    [string]$Path,
    [System.Collections.Generic.List[object]]$Results,
    [int]$StaleDays
  )

  $summary = [PSCustomObject]@{
    Entries = New-Object 'System.Collections.Generic.List[object]'
    StaleDurableEntries = 0
    EntriesMissingSource = 0
    EntriesMissingReviewAfter = 0
    ReviewOverdueEntries = 0
  }

  if (-not (Test-Path -LiteralPath $Path)) {
    return $summary
  }

  $fileName = Split-Path -Leaf $Path
  $entryMatches = Get-EntryMatches -Path $Path

  foreach ($entryMatch in $entryMatches) {
    $entry = $entryMatch.Value
    if ($entry -match '<short-title>' -or $entry -match '<slug>' -or $entry -match 'YYYY-MM-DD') {
      continue
    }

    $titleLine = (($entry -split "`r?`n")[0]).Trim()
    $id = Get-MetadataValue -Entry $entry -FieldName "id"
    $status = Get-MetadataValue -Entry $entry -FieldName "status"
    $confidence = Get-MetadataValue -Entry $entry -FieldName "confidence"
    $lastUpdatedRaw = Get-MetadataValue -Entry $entry -FieldName "last_updated"
    $source = Get-MetadataValue -Entry $entry -FieldName "source"
    $reviewAfterRaw = Get-MetadataValue -Entry $entry -FieldName "review_after"

    $missing = @()
    foreach ($field in @(
      @{ Name = "id"; Value = $id },
      @{ Name = "status"; Value = $status },
      @{ Name = "confidence"; Value = $confidence },
      @{ Name = "last_updated"; Value = $lastUpdatedRaw },
      @{ Name = "source"; Value = $source },
      @{ Name = "review_after"; Value = $reviewAfterRaw }
    )) {
      if ([string]::IsNullOrWhiteSpace($field.Value)) {
        $missing += $field.Name
      }
    }

    if ($missing.Count -gt 0) {
      Add-CheckResult -Results $Results -Level "WARN" -Code "ENTRY_METADATA_MISSING" -Message "$fileName entry '$titleLine' is missing metadata fields: $($missing -join ', ')"
    }

    if ([string]::IsNullOrWhiteSpace($source)) {
      $summary.EntriesMissingSource += 1
      if ($confidence -eq "verified") {
        Add-CheckResult -Results $Results -Level "WARN" -Code "VERIFIED_WITHOUT_SOURCE" -Message "$fileName entry '$titleLine' is marked verified but has no source evidence."
      }
    }

    if ([string]::IsNullOrWhiteSpace($reviewAfterRaw)) {
      $summary.EntriesMissingReviewAfter += 1
    } else {
      try {
        $reviewAfter = [datetime]::ParseExact($reviewAfterRaw, 'yyyy-MM-dd', $null)
        if ($reviewAfter -lt (Get-Date).Date -and $status -ne "superseded") {
          $summary.ReviewOverdueEntries += 1
          Add-CheckResult -Results $Results -Level "WARN" -Code "REVIEW_OVERDUE" -Message "$fileName entry '$titleLine' is overdue for review since $reviewAfterRaw."
        }
      } catch {
        Add-CheckResult -Results $Results -Level "WARN" -Code "REVIEW_AFTER_INVALID" -Message "$fileName entry '$titleLine' has an invalid review_after date: $reviewAfterRaw"
      }
    }

    if (-not [string]::IsNullOrWhiteSpace($lastUpdatedRaw)) {
      try {
        $lastUpdated = [datetime]::ParseExact($lastUpdatedRaw, 'yyyy-MM-dd', $null)
        $entryAge = [int]((Get-Date) - $lastUpdated).TotalDays
        if ($entryAge -gt $StaleDays -and $status -ne "superseded") {
          $summary.StaleDurableEntries += 1
          Add-CheckResult -Results $Results -Level "WARN" -Code "DURABLE_ENTRY_STALE" -Message "$fileName entry '$titleLine' is $entryAge days old and should be reviewed."
        }
      } catch {
        Add-CheckResult -Results $Results -Level "WARN" -Code "LAST_UPDATED_INVALID" -Message "$fileName entry '$titleLine' has an invalid last_updated date: $lastUpdatedRaw"
      }
    }

    $summary.Entries.Add([PSCustomObject]@{
      FileName = $fileName
      Title = $titleLine
      Id = $id
      Status = $status
      Confidence = $confidence
      Source = $source
      ReviewAfter = $reviewAfterRaw
      LastUpdated = $lastUpdatedRaw
    }) | Out-Null
  }

  return $summary
}

function Test-DuplicateDurableIds {
  param(
    [object[]]$Entries,
    [System.Collections.Generic.List[object]]$Results
  )

  $duplicateGroups = $Entries |
    Where-Object { -not [string]::IsNullOrWhiteSpace($_.Id) } |
    Group-Object -Property Id |
    Where-Object { $_.Count -gt 1 }

  foreach ($group in $duplicateGroups) {
    $locations = ($group.Group | ForEach-Object { "$($_.FileName):$($_.Title)" }) -join "; "
    Add-CheckResult -Results $Results -Level "WARN" -Code "ID_CONFLICT" -Message "Duplicate durable memory id '$($group.Name)' appears in multiple entries: $locations"
  }
}

function Test-MemoryIndexShape {
  param(
    [string]$Path,
    [System.Collections.Generic.List[object]]$Results
  )

  if (-not (Test-Path -LiteralPath $Path)) {
    return
  }

  $content = Get-Content -Raw -LiteralPath $Path
  foreach ($key in @(
    'version:',
    'last_full_review:',
    'memory_health:',
    'validator:',
    'learning_backlog:',
    'stale_durable_entries:',
    'entries_missing_source:',
    'entries_missing_review_after:',
    'review_overdue_entries:',
    'conflict_summary:',
    'last_validator_version:',
    'last_promotion_scan:',
    'promotion_ready_candidates:'
  )) {
    if ($content -notmatch [regex]::Escape($key)) {
      Add-CheckResult -Results $Results -Level "WARN" -Code "MEMORY_INDEX_SHAPE" -Message "memory-index.yaml is missing expected key: $key"
    }
  }
}

function Get-LearningBacklogStats {
  param(
    [string]$Path,
    [int]$StaleDays
  )

  $stats = [PSCustomObject]@{
    TotalCandidates = 0
    ReadyForPromotion = 0
    StaleCandidates = 0
    PromotionReadyCandidates = 0
  }

  if (-not (Test-Path -LiteralPath $Path)) {
    return $stats
  }

  $content = Get-Content -Raw -LiteralPath $Path
  $entryMatches = [regex]::Matches($content, '(?ms)^### Candidate:.+?(?=^### Candidate:|\z)')

  foreach ($entryMatch in $entryMatches) {
    $entry = $entryMatch.Value
    if ($entry -match '<short-name>' -or $entry -match '<slug>' -or $entry -match 'YYYY-MM-DD') {
      continue
    }

    $stats.TotalCandidates += 1

    $status = Get-MetadataValue -Entry $entry -FieldName "status"
    if ($status -eq "ready_for_promotion") {
      $stats.ReadyForPromotion += 1
      $stats.PromotionReadyCandidates += 1
    }

    $lastUpdatedRaw = Get-MetadataValue -Entry $entry -FieldName "last_updated"
    if (-not [string]::IsNullOrWhiteSpace($lastUpdatedRaw)) {
      try {
        $lastUpdated = [datetime]::ParseExact($lastUpdatedRaw, 'yyyy-MM-dd', $null)
        $age = [int]((Get-Date) - $lastUpdated).TotalDays
        if ($age -gt $StaleDays) {
          $stats.StaleCandidates += 1
        }
      } catch {
      }
    }
  }

  return $stats
}

function Test-LearningBacklogPromotionRules {
  param(
    [string]$Path,
    [System.Collections.Generic.List[object]]$Results
  )

  if (-not (Test-Path -LiteralPath $Path)) {
    return
  }

  $content = Get-Content -Raw -LiteralPath $Path
  $entryMatches = [regex]::Matches($content, '(?ms)^### Candidate:.+?(?=^### Candidate:|\z)')

  foreach ($entryMatch in $entryMatches) {
    $entry = $entryMatch.Value
    if ($entry -match '<short-name>' -or $entry -match '<slug>' -or $entry -match 'YYYY-MM-DD') {
      continue
    }

    $titleLine = (($entry -split "`r?`n")[0]).Trim()
    $status = Get-MetadataValue -Entry $entry -FieldName "status"
    if ($status -ne "ready_for_promotion") {
      continue
    }

    $missing = @()
    foreach ($field in @("source", "review_after", "linked_entries")) {
      $value = Get-MetadataValue -Entry $entry -FieldName $field
      if ([string]::IsNullOrWhiteSpace($value)) {
        $missing += $field
      }
    }

    if ($missing.Count -gt 0) {
      Add-CheckResult -Results $Results -Level "WARN" -Code "BACKLOG_PROMOTION_METADATA" -Message "$titleLine is ready_for_promotion but missing fields: $($missing -join ', ')"
    }

    $evidenceCount = 0
    $repeatedTimes = 0
    $evidenceRaw = Get-MetadataValue -Entry $entry -FieldName "evidence_count"
    $repeatedRaw = Get-MetadataValue -Entry $entry -FieldName "repeated_times"
    [void][int]::TryParse($evidenceRaw, [ref]$evidenceCount)
    [void][int]::TryParse($repeatedRaw, [ref]$repeatedTimes)

    if ($evidenceCount -lt 2) {
      Add-CheckResult -Results $Results -Level "WARN" -Code "BACKLOG_EVIDENCE_TOO_LOW" -Message "$titleLine is ready_for_promotion but evidence_count is below 2."
    }

    if ($repeatedTimes -lt 2) {
      Add-CheckResult -Results $Results -Level "WARN" -Code "BACKLOG_REPEATED_TOO_LOW" -Message "$titleLine is ready_for_promotion but repeated_times is below 2."
    }
  }
}

function Update-MemoryIndex {
  param(
    [string]$Path,
    [Nullable[int]]$CurrentStateAgeDays,
    [Nullable[int]]$LatestJournalAgeDays,
    [int]$CurrentStateMaxAgeDays,
    [int]$JournalMaxAgeDays,
    [int]$ConflictCount,
    [int]$StaleEntryCount,
    [int]$StaleDurableEntries,
    [int]$EntriesMissingSource,
    [int]$EntriesMissingReviewAfter,
    [int]$ReviewOverdueEntries,
    [string]$ConflictSummary,
    [pscustomobject]$BacklogStats,
    [int]$WarnCount,
    [int]$ErrorCount,
    [string]$ValidatorVersion
  )

  $lastFullReview = (Get-Date).ToString('yyyy-MM-dd')
  $activeFocusLastUpdated = if ($null -eq $CurrentStateAgeDays) {
    ""
  } else {
    (Get-Date).AddDays(-1 * $CurrentStateAgeDays.Value).ToString('yyyy-MM-dd')
  }

  $currentStateFresh = if ($null -eq $CurrentStateAgeDays) { "false" } else { ($CurrentStateAgeDays.Value -le $CurrentStateMaxAgeDays).ToString().ToLower() }
  $journalRecent = if ($null -eq $LatestJournalAgeDays) { "false" } else { ($LatestJournalAgeDays.Value -le $JournalMaxAgeDays).ToString().ToLower() }

  $content = @"
version: 1
last_full_review: $lastFullReview
active_focus:
  file: CURRENT_STATE.md
  last_updated: $activeFocusLastUpdated
memory_health:
  current_state_fresh: $currentStateFresh
  journal_recent: $journalRecent
  conflicts_detected: $ConflictCount
  stale_entries: $StaleEntryCount
  stale_durable_entries: $StaleDurableEntries
  entries_missing_source: $EntriesMissingSource
  entries_missing_review_after: $EntriesMissingReviewAfter
  review_overdue_entries: $ReviewOverdueEntries
  warning_count: $WarnCount
  error_count: $ErrorCount
  conflict_summary: $ConflictSummary
validator:
  last_validator_version: $ValidatorVersion
  last_promotion_scan: $lastFullReview
learning_backlog:
  total_candidates: $($BacklogStats.TotalCandidates)
  ready_for_promotion: $($BacklogStats.ReadyForPromotion)
  stale_candidates: $($BacklogStats.StaleCandidates)
  promotion_ready_candidates: $($BacklogStats.PromotionReadyCandidates)
"@

  Set-Content -LiteralPath $Path -Value $content -Encoding UTF8
}

$memoryRoot = Join-Path $ProjectRoot ".superpowers-memory"
$results = New-Object 'System.Collections.Generic.List[object]'
$latestJournalAgeDays = $null
$currentStateAgeForIndex = $null
$durableEntries = New-Object 'System.Collections.Generic.List[object]'
$staleDurableEntries = 0
$entriesMissingSource = 0
$entriesMissingReviewAfter = 0
$reviewOverdueEntries = 0

if (-not (Test-Path -LiteralPath $memoryRoot)) {
  Add-CheckResult -Results $results -Level "ERROR" -Code "MEMORY_ROOT_MISSING" -Message "Missing .superpowers-memory directory."
} else {
  $requiredFiles = @(
    "PROJECT_CONTEXT.md",
    "CURRENT_STATE.md",
    "LEARNING_BACKLOG.md",
    "DECISIONS.md",
    "KNOWN_FAILURES.md",
    "VERIFICATION_BASELINE.md",
    "TEAM_PREFERENCES.md",
    "USER_PROFILE.md",
    "AGENT_NOTES.md",
    "SESSION_CLOSE_CHECKLIST.md",
    "memory-index.yaml"
  )

  foreach ($name in $requiredFiles) {
    $path = Join-Path $memoryRoot $name
    if (-not (Test-RequiredFile -Path $path)) {
      Add-CheckResult -Results $results -Level "WARN" -Code "MEMORY_FILE_MISSING" -Message "Missing recommended memory file: $name"
    }
  }

  $journalRoot = Join-Path $memoryRoot "session-journal"
  if (-not (Test-Path -LiteralPath $journalRoot)) {
    Add-CheckResult -Results $results -Level "WARN" -Code "JOURNAL_DIR_MISSING" -Message "Missing session-journal directory."
  } else {
    $journalFiles = Get-ChildItem -LiteralPath $journalRoot -File -ErrorAction SilentlyContinue |
      Sort-Object LastWriteTime -Descending

    foreach ($journalFile in $journalFiles) {
      if ($journalFile.Name -eq "README.md") {
        continue
      }
      if ($journalFile.Name -notmatch '^\d{4}-\d{2}-\d{2}-\d{4}-.+\.md$') {
        Add-CheckResult -Results $results -Level "WARN" -Code "JOURNAL_NAME_SHAPE" -Message "Session journal file does not follow the recommended naming pattern: $($journalFile.Name)"
      }
    }

    $latestJournal = $journalFiles | Select-Object -First 1

    if (-not $latestJournal) {
      Add-CheckResult -Results $results -Level "WARN" -Code "JOURNAL_EMPTY" -Message "No session journal entries found."
    } else {
      $journalAge = [int]((Get-Date) - $latestJournal.LastWriteTime).TotalDays
      $latestJournalAgeDays = $journalAge
      if ($journalAge -gt $JournalMaxAgeDays) {
        Add-CheckResult -Results $results -Level "WARN" -Code "JOURNAL_STALE" -Message "Latest session journal entry is $journalAge days old."
      } else {
        Add-CheckResult -Results $results -Level "INFO" -Code "JOURNAL_FRESH" -Message "Latest session journal entry is recent."
      }
    }
  }

  $currentStatePath = Join-Path $memoryRoot "CURRENT_STATE.md"
  $currentStateAge = Get-FileAgeDays -Path $currentStatePath
  $currentStateAgeForIndex = $currentStateAge
  if ($null -eq $currentStateAge) {
    Add-CheckResult -Results $results -Level "WARN" -Code "CURRENT_STATE_MISSING" -Message "CURRENT_STATE.md is missing."
  } elseif ($currentStateAge -gt $CurrentStateMaxAgeDays) {
    Add-CheckResult -Results $results -Level "WARN" -Code "CURRENT_STATE_STALE" -Message "CURRENT_STATE.md is $currentStateAge days old."
  } else {
    Add-CheckResult -Results $results -Level "INFO" -Code "CURRENT_STATE_FRESH" -Message "CURRENT_STATE.md is recent."
  }

  $projectContextPath = Join-Path $memoryRoot "PROJECT_CONTEXT.md"
  Test-Heading -Path $projectContextPath -Heading "## Project Summary" -Results $results -Code "PROJECT_CONTEXT_SHAPE"
  $projectContextSummary = Test-DurableEntries -Path $projectContextPath -Results $results -StaleDays $DurableEntryStaleDays

  Test-Heading -Path $currentStatePath -Heading "## Active Focus" -Results $results -Code "CURRENT_STATE_SHAPE"

  $decisionsPath = Join-Path $memoryRoot "DECISIONS.md"
  Test-Heading -Path $decisionsPath -Heading "## Entry Template" -Results $results -Code "DECISIONS_SHAPE"
  $decisionsSummary = Test-DurableEntries -Path $decisionsPath -Results $results -StaleDays $DurableEntryStaleDays

  $knownFailuresPath = Join-Path $memoryRoot "KNOWN_FAILURES.md"
  Test-Heading -Path $knownFailuresPath -Heading "## Entry Template" -Results $results -Code "KNOWN_FAILURES_SHAPE"
  $knownFailuresSummary = Test-DurableEntries -Path $knownFailuresPath -Results $results -StaleDays $DurableEntryStaleDays

  $verificationBaselinePath = Join-Path $memoryRoot "VERIFICATION_BASELINE.md"
  Test-Heading -Path $verificationBaselinePath -Heading "## Entry Template" -Results $results -Code "VERIFICATION_BASELINE_SHAPE"
  $verificationSummary = Test-DurableEntries -Path $verificationBaselinePath -Results $results -StaleDays $DurableEntryStaleDays

  $teamPreferencesPath = Join-Path $memoryRoot "TEAM_PREFERENCES.md"
  Test-Heading -Path $teamPreferencesPath -Heading "## Entry Template" -Results $results -Code "TEAM_PREFERENCES_SHAPE"
  $teamPreferencesSummary = Test-DurableEntries -Path $teamPreferencesPath -Results $results -StaleDays $DurableEntryStaleDays

  $userProfilePath = Join-Path $memoryRoot "USER_PROFILE.md"
  Test-Heading -Path $userProfilePath -Heading "## Entry Template" -Results $results -Code "USER_PROFILE_SHAPE"
  $userProfileSummary = Test-DurableEntries -Path $userProfilePath -Results $results -StaleDays $DurableEntryStaleDays

  $agentNotesPath = Join-Path $memoryRoot "AGENT_NOTES.md"
  Test-Heading -Path $agentNotesPath -Heading "## Entry Template" -Results $results -Code "AGENT_NOTES_SHAPE"
  $agentNotesSummary = Test-DurableEntries -Path $agentNotesPath -Results $results -StaleDays $DurableEntryStaleDays

  foreach ($summary in @($projectContextSummary, $decisionsSummary, $knownFailuresSummary, $verificationSummary, $teamPreferencesSummary, $userProfileSummary, $agentNotesSummary)) {
    foreach ($entry in $summary.Entries) {
      $durableEntries.Add($entry) | Out-Null
    }
    $staleDurableEntries += $summary.StaleDurableEntries
    $entriesMissingSource += $summary.EntriesMissingSource
    $entriesMissingReviewAfter += $summary.EntriesMissingReviewAfter
    $reviewOverdueEntries += $summary.ReviewOverdueEntries
  }

  Test-DuplicateDurableIds -Entries $durableEntries.ToArray() -Results $results

  $memoryIndexPath = Join-Path $memoryRoot "memory-index.yaml"
  Test-MemoryIndexShape -Path $memoryIndexPath -Results $results

  $learningBacklogPath = Join-Path $memoryRoot "LEARNING_BACKLOG.md"
  if (Test-Path -LiteralPath $learningBacklogPath) {
    $content = Get-Content -Raw -LiteralPath $learningBacklogPath
    if ($content -notmatch "Candidate") {
      Add-CheckResult -Results $results -Level "INFO" -Code "BACKLOG_EMPTY_OR_MINIMAL" -Message "LEARNING_BACKLOG.md does not yet contain candidate entries."
    }

    Test-LearningBacklogPromotionRules -Path $learningBacklogPath -Results $results

    $backlogAge = Get-FileAgeDays -Path $learningBacklogPath
    if ($null -ne $backlogAge -and $backlogAge -gt $BacklogStaleDays) {
      Add-CheckResult -Results $results -Level "INFO" -Code "BACKLOG_STALE_REVIEW" -Message "LEARNING_BACKLOG.md is $backlogAge days old. Consider reviewing stale candidates."
    }
  }
}

$errorCount = @($results | Where-Object { $_.Level -eq "ERROR" }).Count
$warnCount = @($results | Where-Object { $_.Level -eq "WARN" }).Count
$infoCount = @($results | Where-Object { $_.Level -eq "INFO" }).Count

if ((-not $SkipIndexWrite) -and (Test-Path -LiteralPath $memoryRoot)) {
  $memoryIndexPath = Join-Path $memoryRoot "memory-index.yaml"
  $backlogStats = Get-LearningBacklogStats -Path (Join-Path $memoryRoot "LEARNING_BACKLOG.md") -StaleDays $BacklogStaleDays
  $conflictResults = @($results | Where-Object { $_.Code -match 'CONFLICT' })
  $conflictCount = $conflictResults.Count
  $staleEntryCount = @($results | Where-Object { $_.Code -match 'STALE' -or $_.Code -in @('ENTRY_METADATA_MISSING', 'REVIEW_OVERDUE', 'VERIFIED_WITHOUT_SOURCE') }).Count
  $conflictSummary = if ($conflictCount -eq 0) { "none" } else { ($conflictResults | Select-Object -First 3 | ForEach-Object { $_.Code }) -join ',' }
  Update-MemoryIndex `
    -Path $memoryIndexPath `
    -CurrentStateAgeDays $currentStateAgeForIndex `
    -LatestJournalAgeDays $latestJournalAgeDays `
    -CurrentStateMaxAgeDays $CurrentStateMaxAgeDays `
    -JournalMaxAgeDays $JournalMaxAgeDays `
    -ConflictCount $conflictCount `
    -StaleEntryCount $staleEntryCount `
    -StaleDurableEntries $staleDurableEntries `
    -EntriesMissingSource $entriesMissingSource `
    -EntriesMissingReviewAfter $entriesMissingReviewAfter `
    -ReviewOverdueEntries $reviewOverdueEntries `
    -ConflictSummary $conflictSummary `
    -BacklogStats $backlogStats `
    -WarnCount $warnCount `
    -ErrorCount $errorCount `
    -ValidatorVersion $ValidatorVersion
}

Write-Host "Superpowers memory validation"
Write-Host "Project root: $ProjectRoot"
Write-Host ""

foreach ($item in $results) {
  Write-Host ("[{0}] {1} - {2}" -f $item.Level, $item.Code, $item.Message)
}

Write-Host ""
Write-Host ("Summary: {0} error(s), {1} warning(s), {2} info item(s)" -f $errorCount, $warnCount, $infoCount)

if ($errorCount -gt 0) {
  exit 1
}
