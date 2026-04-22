param(
  [string]$ProjectRoot = (Get-Location).Path,
  [string]$Query = "",
  [string]$Type = "all",
  [string]$Status = "",
  [int]$MaxResults = 20,
  [int]$SinceDays = 0,
  [switch]$RecentFirst,
  [switch]$Summary
)

$ErrorActionPreference = "Stop"

$memoryRoot = Join-Path $ProjectRoot ".superpowers-memory"
if (-not (Test-Path -LiteralPath $memoryRoot)) {
  Write-Error "Missing .superpowers-memory directory under: $ProjectRoot"
}

$typeMap = @{
  "project_context" = @("PROJECT_CONTEXT.md")
  "current_state" = @("CURRENT_STATE.md")
  "decisions" = @("DECISIONS.md")
  "known_failures" = @("KNOWN_FAILURES.md")
  "verification" = @("VERIFICATION_BASELINE.md")
  "team_preferences" = @("TEAM_PREFERENCES.md")
  "user_profile" = @("USER_PROFILE.md")
  "agent_notes" = @("AGENT_NOTES.md")
  "backlog" = @("LEARNING_BACKLOG.md")
  "journal" = @("session-journal")
}

function Get-TargetPaths {
  param(
    [string]$MemoryRoot,
    [string]$Type
  )

  if ($Type -eq "all") {
    return @(
      (Join-Path $MemoryRoot "PROJECT_CONTEXT.md"),
      (Join-Path $MemoryRoot "CURRENT_STATE.md"),
      (Join-Path $MemoryRoot "DECISIONS.md"),
      (Join-Path $MemoryRoot "KNOWN_FAILURES.md"),
      (Join-Path $MemoryRoot "VERIFICATION_BASELINE.md"),
      (Join-Path $MemoryRoot "TEAM_PREFERENCES.md"),
      (Join-Path $MemoryRoot "USER_PROFILE.md"),
      (Join-Path $MemoryRoot "AGENT_NOTES.md"),
      (Join-Path $MemoryRoot "LEARNING_BACKLOG.md"),
      (Join-Path $MemoryRoot "session-journal")
    )
  }

  if (-not $typeMap.ContainsKey($Type)) {
    throw "Unknown type '$Type'. Valid values: all, $($typeMap.Keys -join ', ')"
  }

  return $typeMap[$Type] | ForEach-Object { Join-Path $MemoryRoot $_ }
}

function Test-WithinSinceDays {
  param(
    [string]$UpdatedAt,
    [int]$SinceDays
  )

  if ($SinceDays -le 0) {
    return $true
  }

  if ([string]::IsNullOrWhiteSpace($UpdatedAt)) {
    return $false
  }

  try {
    $updated = [datetime]::ParseExact($UpdatedAt, 'yyyy-MM-dd', $null)
    return ([int]((Get-Date) - $updated).TotalDays) -le $SinceDays
  } catch {
    return $false
  }
}

function Get-MetadataValue {
  param(
    [string]$Entry,
    [string]$FieldName
  )

  $match = [regex]::Match($Entry, "(?m)^-\s*" + [regex]::Escape($FieldName) + ":\s*(.*)$")
  if (-not $match.Success) {
    return ""
  }
  return $match.Groups[1].Value.Trim()
}

function Search-EntryFile {
  param(
    [string]$Path,
    [string]$Query,
    [string]$Status,
    [int]$MaxResults
  )

  if (-not (Test-Path -LiteralPath $Path)) {
    return @()
  }

  $content = Get-Content -Raw -LiteralPath $Path
  $entryMatches = [regex]::Matches($content, '(?ms)^### .+?(?=^### |\z)')
  $results = @()

  foreach ($entryMatch in $entryMatches) {
    $entry = $entryMatch.Value
    if ($entry -match '<short-title>' -or $entry -match '<short-name>' -or $entry -match '<slug>' -or $entry -match 'YYYY-MM-DD') {
      continue
    }

    $title = (($entry -split "`r?`n")[0]).Trim()
    $entryStatus = Get-MetadataValue -Entry $entry -FieldName "status"
    if ($Status -and $entryStatus -ne $Status) {
      continue
    }

    if ($Query -and $entry -notmatch [regex]::Escape($Query)) {
      continue
    }

    $results += [PSCustomObject]@{
      Kind = Split-Path -Leaf $Path
      Path = $Path
      Title = $title
      Status = $entryStatus
      Id = Get-MetadataValue -Entry $entry -FieldName "id"
      UpdatedAt = Get-MetadataValue -Entry $entry -FieldName "last_updated"
    }

    if ($results.Count -ge $MaxResults) {
      break
    }
  }

  return $results
}

function Search-FlatFile {
  param(
    [string]$Path,
    [string]$Query,
    [int]$MaxResults
  )

  if (-not (Test-Path -LiteralPath $Path)) {
    return @()
  }

  $results = @()
  $matches = if ([string]::IsNullOrWhiteSpace($Query)) {
    @()
  } else {
    Select-String -LiteralPath $Path -Pattern $Query -SimpleMatch
  }

  if ($matches.Count -eq 0 -and [string]::IsNullOrWhiteSpace($Query)) {
    $results += [PSCustomObject]@{
      Kind = Split-Path -Leaf $Path
      Path = $Path
      Title = "file"
      Status = ""
      Id = ""
      UpdatedAt = (Get-Item -LiteralPath $Path).LastWriteTime.ToString("yyyy-MM-dd")
    }
    return $results
  }

  foreach ($match in $matches | Select-Object -First $MaxResults) {
    $results += [PSCustomObject]@{
      Kind = Split-Path -Leaf $Path
      Path = $Path
      Title = "line $($match.LineNumber): $($match.Line.Trim())"
      Status = ""
      Id = ""
      UpdatedAt = (Get-Item -LiteralPath $Path).LastWriteTime.ToString("yyyy-MM-dd")
    }
  }

  return $results
}

function Search-Journal {
  param(
    [string]$Path,
    [string]$Query,
    [int]$MaxResults
  )

  if (-not (Test-Path -LiteralPath $Path)) {
    return @()
  }

  $results = @()
  $journalFiles = Get-ChildItem -LiteralPath $Path -File -Filter *.md -ErrorAction SilentlyContinue |
    Where-Object { $_.Name -ne "README.md" } |
    Sort-Object LastWriteTime -Descending

  foreach ($file in $journalFiles) {
    $content = Get-Content -Raw -LiteralPath $file.FullName
    if ($Query -and $content -notmatch [regex]::Escape($Query)) {
      continue
    }

    $results += [PSCustomObject]@{
      Kind = "session-journal"
      Path = $file.FullName
      Title = $file.Name
      Status = ""
      Id = ""
      UpdatedAt = $file.LastWriteTime.ToString("yyyy-MM-dd")
    }

    if ($results.Count -ge $MaxResults) {
      break
    }
  }

  return $results
}

$results = @()
foreach ($targetPath in (Get-TargetPaths -MemoryRoot $memoryRoot -Type $Type)) {
  $leaf = Split-Path -Leaf $targetPath
  if ($leaf -eq "CURRENT_STATE.md" -or $leaf -eq "PROJECT_CONTEXT.md") {
    $results += Search-FlatFile -Path $targetPath -Query $Query -MaxResults $MaxResults
  } elseif ($leaf -eq "session-journal") {
    $results += Search-Journal -Path $targetPath -Query $Query -MaxResults $MaxResults
  } else {
    $results += Search-EntryFile -Path $targetPath -Query $Query -Status $Status -MaxResults $MaxResults
  }
}

$results = $results | Where-Object { Test-WithinSinceDays -UpdatedAt $_.UpdatedAt -SinceDays $SinceDays }

if ($RecentFirst) {
  $results = $results |
    Sort-Object @{ Expression = {
      try {
        if ([string]::IsNullOrWhiteSpace($_.UpdatedAt)) { [datetime]::MinValue }
        else { [datetime]::ParseExact($_.UpdatedAt, 'yyyy-MM-dd', $null) }
      } catch {
        [datetime]::MinValue
      }
    }; Descending = $true }
}

$results = $results | Select-Object -First $MaxResults

Write-Host "Superpowers memory search"
Write-Host "Project root: $ProjectRoot"
if ($SinceDays -gt 0) {
  Write-Host "Time window: last $SinceDays day(s)"
}
if ($Type -ne "all") {
  Write-Host "Type filter: $Type"
}
if (-not [string]::IsNullOrWhiteSpace($Status)) {
  Write-Host "Status filter: $Status"
}
Write-Host ""

if ($results.Count -eq 0) {
  Write-Host "No matching memory entries found."
  exit 0
}

if ($Summary) {
  $resultCount = @($results).Count
  $kindSummary = $results |
    Group-Object Kind |
    Sort-Object -Property @{ Expression = "Count"; Descending = $true }, @{ Expression = "Name"; Descending = $false } |
    ForEach-Object { "{0}={1}" -f $_.Name, $_.Count }
  $statusSummary = $results |
    Where-Object { -not [string]::IsNullOrWhiteSpace($_.Status) } |
    Group-Object Status |
    Sort-Object -Property @{ Expression = "Count"; Descending = $true }, @{ Expression = "Name"; Descending = $false } |
    ForEach-Object { "{0}={1}" -f $_.Name, $_.Count }

  Write-Host "Summary:"
  Write-Host ("- total_results={0}" -f $resultCount)
  if ($kindSummary.Count -gt 0) {
    Write-Host ("- by_kind: {0}" -f ($kindSummary -join ", "))
  }
  if ($statusSummary.Count -gt 0) {
    Write-Host ("- by_status: {0}" -f ($statusSummary -join ", "))
  }
  Write-Host ""
}

foreach ($result in $results) {
  $statusSuffix = ""
  if (-not [string]::IsNullOrWhiteSpace($result.Status)) {
    $statusSuffix = " [status=$($result.Status)]"
  }
  $dateSuffix = ""
  if (-not [string]::IsNullOrWhiteSpace($result.UpdatedAt)) {
    $dateSuffix = " [updated=$($result.UpdatedAt)]"
  }
  Write-Host ("- [{0}] {1}{2}{3}" -f $result.Kind, $result.Title, $statusSuffix, $dateSuffix)
  Write-Host ("  {0}" -f $result.Path)
}
