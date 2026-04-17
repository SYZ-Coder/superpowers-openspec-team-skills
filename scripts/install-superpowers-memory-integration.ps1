param(
  [ValidateSet("codex", "cursor", "claude-code", "all")]
  [string]$Tool = "all",
  [string]$ProjectRoot = (Get-Location).Path,
  [switch]$DryRun,
  [switch]$Backup,
  [switch]$Force
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$templateRoot = Join-Path $repoRoot "templates\superpowers-memory\integrations"
$backupRoot = Join-Path $ProjectRoot ".ai-skill-backups\superpowers-memory-integration"
$markerStart = "<!-- superpowers-memory:start -->"
$markerEnd = "<!-- superpowers-memory:end -->"

function Backup-IfNeeded {
  param(
    [string]$Path,
    [string]$BackupDir
  )

  if (Test-Path $Path) {
    New-Item -ItemType Directory -Force -Path $BackupDir | Out-Null
    Copy-Item -Recurse -Force $Path $BackupDir
  }
}

function Set-ManagedBlock {
  param(
    [string]$TargetPath,
    [string]$BlockContent,
    [string]$BackupDir,
    [switch]$DryRunMode,
    [switch]$BackupMode
  )

  $existing = if (Test-Path $TargetPath) { Get-Content -Raw $TargetPath } else { "" }
  $managedPattern = [regex]::Escape($markerStart) + ".*?" + [regex]::Escape($markerEnd)

  if ([string]::IsNullOrWhiteSpace($existing)) {
    $newContent = $BlockContent.Trim() + [Environment]::NewLine
  } elseif ([regex]::IsMatch($existing, $managedPattern, [System.Text.RegularExpressions.RegexOptions]::Singleline)) {
    $newContent = [regex]::Replace(
      $existing,
      $managedPattern,
      $BlockContent.Trim(),
      [System.Text.RegularExpressions.RegexOptions]::Singleline
    )
    if (-not $newContent.EndsWith([Environment]::NewLine)) {
      $newContent += [Environment]::NewLine
    }
  } else {
    $separator = if ($existing.EndsWith([Environment]::NewLine + [Environment]::NewLine)) { "" } else { [Environment]::NewLine + [Environment]::NewLine }
    $newContent = $existing + $separator + $BlockContent.Trim() + [Environment]::NewLine
  }

  if ($DryRunMode) {
    return
  }

  if ($BackupMode) {
    Backup-IfNeeded -Path $TargetPath -BackupDir $BackupDir
  }

  $parent = Split-Path -Parent $TargetPath
  if ($parent) {
    New-Item -ItemType Directory -Force -Path $parent | Out-Null
  }
  Set-Content -Path $TargetPath -Value $newContent -Encoding UTF8
}

$operations = @()

if ($Tool -in @("codex", "all")) {
  $operations += [PSCustomObject]@{
    Tool = "codex"
    Mode = "managed-block"
    Source = Join-Path $templateRoot "codex\AGENTS.memory.md"
    Target = Join-Path $ProjectRoot "AGENTS.md"
  }
}

if ($Tool -in @("cursor", "all")) {
  $operations += [PSCustomObject]@{
    Tool = "cursor"
    Mode = "copy"
    Source = Join-Path $templateRoot "cursor\superpowers-memory.mdc"
    Target = Join-Path $ProjectRoot ".cursor\rules\superpowers-memory.mdc"
  }
}

if ($Tool -in @("claude-code", "all")) {
  $operations += [PSCustomObject]@{
    Tool = "claude-code"
    Mode = "managed-block"
    Source = Join-Path $templateRoot "claude-code\CLAUDE.memory.md"
    Target = Join-Path $ProjectRoot "CLAUDE.md"
  }
}

Write-Host "Superpowers memory integration"
Write-Host "Project root: $ProjectRoot"
Write-Host ""
Write-Host "Install plan:"
$operations | ForEach-Object {
  $status = if (Test-Path $_.Target) { "update" } else { "new" }
  Write-Host ("- [{0}] {1} -> {2} [{3}]" -f $_.Tool, $_.Source, $_.Target, $status)
}

if ($DryRun) {
  Write-Host ""
  Write-Host "Dry run only. No files were written."
  return
}

if (-not $Force) {
  $answer = Read-Host "Continue and install memory integration files? (y/N)"
  if ($answer -notin @("y", "Y", "yes", "YES")) {
    Write-Host "Install cancelled."
    return
  }
}

$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$backupDir = Join-Path $backupRoot $timestamp
$results = @()

foreach ($op in $operations) {
  if (-not (Test-Path $op.Source)) {
    throw "Integration template not found: $($op.Source)"
  }

  $existsBefore = Test-Path $op.Target

  if ($op.Mode -eq "copy") {
    if ($Backup -and $existsBefore) {
      Backup-IfNeeded -Path $op.Target -BackupDir $backupDir
    }
    $parent = Split-Path -Parent $op.Target
    if ($parent) {
      New-Item -ItemType Directory -Force -Path $parent | Out-Null
    }
    Copy-Item -Force $op.Source $op.Target
  } else {
    $block = Get-Content -Raw $op.Source
    Set-ManagedBlock -TargetPath $op.Target -BlockContent $block -BackupDir $backupDir -BackupMode:$Backup
  }

  $results += [PSCustomObject]@{
    Tool = $op.Tool
    Target = $op.Target
    Action = if ($existsBefore) { "updated" } else { "installed" }
  }
}

Write-Host ""
Write-Host "Install summary:"
$results | ForEach-Object {
  Write-Host ("- [{0}] {1}: {2}" -f $_.Tool, $_.Target, $_.Action)
}

if ($Backup -and (Test-Path $backupDir)) {
  Write-Host ("Backup created under: {0}" -f $backupDir)
}

Write-Host ""
Write-Host "Installed Superpowers memory integration for $Tool"
Write-Host "Next: reopen the project in your tool so it picks up the new session-start instructions."
