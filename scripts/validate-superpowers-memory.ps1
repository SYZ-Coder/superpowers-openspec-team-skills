param(
  [string]$ProjectRoot = (Get-Location).Path,
  [int]$CurrentStateMaxAgeDays = 14,
  [int]$JournalMaxAgeDays = 14
)

$ErrorActionPreference = "Stop"

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

$memoryRoot = Join-Path $ProjectRoot ".superpowers-memory"
$results = New-Object 'System.Collections.Generic.List[object]'

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
    $latestJournal = Get-ChildItem -LiteralPath $journalRoot -File -ErrorAction SilentlyContinue |
      Sort-Object LastWriteTime -Descending |
      Select-Object -First 1

    if (-not $latestJournal) {
      Add-CheckResult -Results $results -Level "WARN" -Code "JOURNAL_EMPTY" -Message "No session journal entries found."
    } else {
      $journalAge = [int]((Get-Date) - $latestJournal.LastWriteTime).TotalDays
      if ($journalAge -gt $JournalMaxAgeDays) {
        Add-CheckResult -Results $results -Level "WARN" -Code "JOURNAL_STALE" -Message "Latest session journal entry is $journalAge days old."
      } else {
        Add-CheckResult -Results $results -Level "INFO" -Code "JOURNAL_FRESH" -Message "Latest session journal entry is recent."
      }
    }
  }

  $currentStatePath = Join-Path $memoryRoot "CURRENT_STATE.md"
  $currentStateAge = Get-FileAgeDays -Path $currentStatePath
  if ($null -eq $currentStateAge) {
    Add-CheckResult -Results $results -Level "WARN" -Code "CURRENT_STATE_MISSING" -Message "CURRENT_STATE.md is missing."
  } elseif ($currentStateAge -gt $CurrentStateMaxAgeDays) {
    Add-CheckResult -Results $results -Level "WARN" -Code "CURRENT_STATE_STALE" -Message "CURRENT_STATE.md is $currentStateAge days old."
  } else {
    Add-CheckResult -Results $results -Level "INFO" -Code "CURRENT_STATE_FRESH" -Message "CURRENT_STATE.md is recent."
  }

  $projectContextPath = Join-Path $memoryRoot "PROJECT_CONTEXT.md"
  if (Test-Path -LiteralPath $projectContextPath) {
    $content = Get-Content -Raw -LiteralPath $projectContextPath
    if ($content -notmatch "## Project Summary") {
      Add-CheckResult -Results $results -Level "WARN" -Code "PROJECT_CONTEXT_SHAPE" -Message "PROJECT_CONTEXT.md does not contain the expected Project Summary heading."
    }
  }

  $learningBacklogPath = Join-Path $memoryRoot "LEARNING_BACKLOG.md"
  if (Test-Path -LiteralPath $learningBacklogPath) {
    $content = Get-Content -Raw -LiteralPath $learningBacklogPath
    if ($content -notmatch "Candidate") {
      Add-CheckResult -Results $results -Level "INFO" -Code "BACKLOG_EMPTY_OR_MINIMAL" -Message "LEARNING_BACKLOG.md does not yet contain candidate entries."
    }
  }
}

$errorCount = ($results | Where-Object Level -eq "ERROR").Count
$warnCount = ($results | Where-Object Level -eq "WARN").Count
$infoCount = ($results | Where-Object Level -eq "INFO").Count

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
