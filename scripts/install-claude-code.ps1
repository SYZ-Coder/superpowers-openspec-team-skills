param(
  [ValidateSet(
    "openspec-superpowers",
    "openspec-superpowers-workflow",
    "superpowers-openspec-superpowers",
    "superpowers-openspec-superpowers-workflow",
    "superpowers-feature",
    "superpowers-feature-workflow",
    "openspec-feature",
    "openspec-feature-workflow",
    "superpowers-learning",
    "superpowers-learning-workflow"
  )]
  [string]$Bundle = "openspec-superpowers",
  [string]$ProjectRoot = (Get-Location).Path,
  [switch]$DryRun,
  [switch]$Backup,
  [switch]$MergeClaudeMd,
  [switch]$Force,
  [switch]$CheckDependencies
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
. (Join-Path $PSScriptRoot "common\dependency-check.ps1")

function Merge-ClaudeMdManagedBlock {
  param(
    [string]$BundleName,
    [string]$SourcePath,
    [string]$TargetPath
  )

  $startMarker = "<!-- BEGIN superpowers-openspec-team-skills:$BundleName -->"
  $endMarker = "<!-- END superpowers-openspec-team-skills:$BundleName -->"
  $sourceContent = Get-Content -LiteralPath $SourcePath -Raw
  $managedBlock = @(
    $startMarker
    $sourceContent.TrimEnd("`r", "`n")
    $endMarker
  ) -join "`r`n"

  if (-not (Test-Path -LiteralPath $TargetPath)) {
    Set-Content -LiteralPath $TargetPath -Value $managedBlock
    return
  }

  $targetContent = Get-Content -LiteralPath $TargetPath -Raw
  $pattern = [regex]::Escape($startMarker) + ".*?" + [regex]::Escape($endMarker)
  $withoutExistingBlock = [regex]::Replace(
    $targetContent,
    $pattern,
    "",
    [System.Text.RegularExpressions.RegexOptions]::Singleline
  ).TrimEnd("`r", "`n")

  if ([string]::IsNullOrWhiteSpace($withoutExistingBlock)) {
    Set-Content -LiteralPath $TargetPath -Value $managedBlock
    return
  }

  $mergedContent = @(
    $withoutExistingBlock
    ""
    $managedBlock
  ) -join "`r`n"

  Set-Content -LiteralPath $TargetPath -Value $mergedContent
}

$bundleFolder = switch ($Bundle) {
  "openspec-superpowers-workflow" { "openspec-superpowers" }
  "superpowers-openspec-superpowers-workflow" { "superpowers-openspec-superpowers" }
  "superpowers-feature-workflow" { "superpowers-feature" }
  "openspec-feature-workflow" { "openspec-feature" }
  "superpowers-learning-workflow" { "superpowers-learning" }
  default { $Bundle }
}
$bundleRoot = Join-Path $repoRoot "dist\claude-code\bundles\$bundleFolder"
$backupRoot = Join-Path $ProjectRoot ".ai-skill-backups\claude-code"

if (-not (Test-Path $bundleRoot)) {
  throw "Bundle not found: $bundleRoot"
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

$entries = Get-ChildItem $bundleRoot -Force | Where-Object { $_.Name -ne "manifest.json" -and $_.Name -ne "README.md" }
if (-not $entries) {
  throw "No installable files found in bundle: $bundleRoot"
}

$installPlan = foreach ($entry in $entries) {
  $target = Join-Path $ProjectRoot $entry.Name
  [PSCustomObject]@{
    Name = $entry.Name
    Source = $entry.FullName
    Target = $target
    Exists = Test-Path $target
  }
}

Write-Host "Claude Code bundle: $Bundle"
Write-Host "Source bundle: $bundleRoot"
Write-Host "Install target: $ProjectRoot"
Write-Host ""
Write-Host "Install plan:"
$installPlan | ForEach-Object {
  $status = if ($MergeClaudeMd -and $_.Name -eq "CLAUDE.md" -and $_.Exists) {
    "merge"
  } elseif ($_.Exists) {
    "overwrite"
  } else {
    "new"
  }
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
  $answer = Read-Host "One or more target files or directories already exist. Continue and apply the planned changes? (y/N)"
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

  if ($MergeClaudeMd -and $item.Name -eq "CLAUDE.md") {
    Merge-ClaudeMdManagedBlock -BundleName $bundleFolder -SourcePath $item.Source -TargetPath $item.Target
  } else {
    Copy-Item -Recurse -Force $item.Source $ProjectRoot
  }

  $results += [PSCustomObject]@{
    Name = $item.Name
    Action = if ($MergeClaudeMd -and $item.Name -eq "CLAUDE.md" -and $item.Exists) {
      "merged"
    } elseif ($item.Exists) {
      "overwritten"
    } else {
      "installed"
    }
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
Write-Host "Installed Claude Code bundle '$Bundle' into $ProjectRoot"
Write-Host "Next: reopen the repository in Claude Code and invoke the generated slash command."
