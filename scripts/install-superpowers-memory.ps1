param(
  [string]$ProjectRoot = (Get-Location).Path,
  [switch]$DryRun,
  [switch]$Backup,
  [switch]$Force
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$templateRoot = Join-Path $repoRoot "templates\superpowers-memory"
$targetRoot = Join-Path $ProjectRoot ".superpowers-memory"
$backupRoot = Join-Path $ProjectRoot ".ai-skill-backups\superpowers-memory"

if (-not (Test-Path $templateRoot)) {
  throw "Memory template not found: $templateRoot"
}

$entries = Get-ChildItem $templateRoot -Force
if (-not $entries) {
  throw "No memory template files found in: $templateRoot"
}

$installPlan = foreach ($entry in $entries) {
  $target = Join-Path $targetRoot $entry.Name
  [PSCustomObject]@{
    Name = $entry.Name
    Source = $entry.FullName
    Target = $target
    Exists = Test-Path $target
  }
}

Write-Host "Superpowers memory scaffold"
Write-Host "Template source: $templateRoot"
Write-Host "Install target: $targetRoot"
Write-Host ""
Write-Host "Install plan:"
$installPlan | ForEach-Object {
  $status = if ($_.Exists) { "overwrite" } else { "new" }
  Write-Host ("- {0} -> {1} [{2}]" -f $_.Name, $_.Target, $status)
}

if ($DryRun) {
  Write-Host ""
  Write-Host "Dry run only. No files were copied."
  return
}

New-Item -ItemType Directory -Force -Path $targetRoot | Out-Null

if (($installPlan | Where-Object { $_.Exists }).Count -gt 0 -and -not $Force) {
  $answer = Read-Host "One or more memory files already exist. Continue and overwrite them? (y/N)"
  if ($answer -notin @("y", "Y", "yes", "YES")) {
    Write-Host "Install cancelled."
    return
  }
}

$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$results = @()

foreach ($item in $installPlan) {
  if ($item.Exists -and $Backup) {
    $backupDir = Join-Path $backupRoot $timestamp
    New-Item -ItemType Directory -Force -Path $backupDir | Out-Null
    Copy-Item -Recurse -Force $item.Target $backupDir
  }

  Copy-Item -Recurse -Force $item.Source $targetRoot
  $results += [PSCustomObject]@{
    Name = $item.Name
    Action = if ($item.Exists) { "overwritten" } else { "installed" }
  }
}

Write-Host ""
Write-Host "Install summary:"
$results | ForEach-Object {
  Write-Host ("- {0}: {1}" -f $_.Name, $_.Action)
}

if ($Backup -and ($installPlan | Where-Object { $_.Exists }).Count -gt 0) {
  Write-Host ("Backup created under: {0}" -f (Join-Path $backupRoot $timestamp))
}

Write-Host ""
Write-Host "Installed Superpowers memory scaffold into $targetRoot"
Write-Host "Next: fill in PROJECT_CONTEXT.md, update CURRENT_STATE.md, and keep session-journal entries for future sessions."
