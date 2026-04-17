param(
  [ValidateSet("openspec-superpowers", "superpowers-openspec-execution", "superpowers-feature", "openspec-feature", "superpowers-learning")]
  [string]$Bundle = "openspec-superpowers",
  [string]$CodexHome = "$env:USERPROFILE\.codex",
  [switch]$DryRun,
  [switch]$Backup,
  [switch]$Force,
  [switch]$CheckDependencies
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
. (Join-Path $PSScriptRoot "common\dependency-check.ps1")
$bundleRoot = Join-Path $repoRoot "dist\codex\bundles\$Bundle"
$skillsRoot = Join-Path $bundleRoot "skills"
$targetRoot = Join-Path $CodexHome "skills"
$backupRoot = Join-Path $CodexHome "backups\skills"

if (-not (Test-Path $skillsRoot)) {
  throw "Bundle not found: $skillsRoot"
}

$manifest = Read-BundleManifest -BundleRoot $bundleRoot
$dependencyResults = Get-DependencyResults -Manifest $manifest
Show-DependencyResults -DependencyResults $dependencyResults
$missingDependencies = Get-MissingDependencies -DependencyResults $dependencyResults

if ($CheckDependencies) {
  if ($missingDependencies.Count -gt 0) {
    throw "One or more runtime dependencies are missing."
  }
  Write-Host "Dependency check passed."
  return
}

New-Item -ItemType Directory -Force -Path $targetRoot | Out-Null

$sourceDirs = Get-ChildItem $skillsRoot -Directory
if (-not $sourceDirs) {
  throw "No skill directories found in bundle: $skillsRoot"
}

$installPlan = foreach ($dir in $sourceDirs) {
  $targetDir = Join-Path $targetRoot $dir.Name
  [PSCustomObject]@{
    Name = $dir.Name
    Source = $dir.FullName
    Target = $targetDir
    Exists = Test-Path $targetDir
  }
}

Write-Host "Codex bundle: $Bundle"
Write-Host "Source bundle: $bundleRoot"
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

if ($missingDependencies.Count -gt 0) {
  Write-Host "Warning: bundle files can be installed, but runtime dependencies are still missing."
  Write-Host "The installed workflow may not run until those dependencies are available."
  Write-Host ""
}

if (($installPlan | Where-Object { $_.Exists }).Count -gt 0 -and -not $Force) {
  $answer = Read-Host "One or more target skill directories already exist. Continue and overwrite them? (y/N)"
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
    Target = $item.Target
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
Write-Host "Installed Codex bundle '$Bundle' to $targetRoot"
Write-Host "Next: restart or refresh Codex, then invoke the workflow by name."
