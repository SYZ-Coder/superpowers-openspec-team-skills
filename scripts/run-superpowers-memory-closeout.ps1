param(
  [string]$ProjectRoot = (Get-Location).Path,
  [string[]]$ChangedPaths = @(),
  [string[]]$Signals = @(),
  [switch]$RunValidator
)

$ErrorActionPreference = "Stop"

$memoryRoot = Join-Path $ProjectRoot ".superpowers-memory"
if (-not (Test-Path -LiteralPath $memoryRoot)) {
  Write-Error "Missing .superpowers-memory directory under: $ProjectRoot"
}

$checklistPath = Join-Path $memoryRoot "SESSION_CLOSE_CHECKLIST.md"

Write-Host "Superpowers memory closeout"
Write-Host "Project root: $ProjectRoot"
Write-Host ""

Write-Host "Checklist reference:"
if (Test-Path -LiteralPath $checklistPath) {
  Write-Host ("- {0}" -f $checklistPath)
} else {
  Write-Host "- SESSION_CLOSE_CHECKLIST.md is missing."
}
Write-Host ""

Write-Host "Suggested memory targets:"
$suggestionOutput = & (Join-Path $PSScriptRoot "suggest-superpowers-memory-updates.ps1") `
  -ProjectRoot $ProjectRoot `
  -ChangedPaths $ChangedPaths `
  -Signals $Signals
$suggestionOutput | ForEach-Object { Write-Host $_ }

if ($RunValidator) {
  Write-Host ""
  Write-Host "Validation:"
  $validatorOutput = & (Join-Path $PSScriptRoot "validate-superpowers-memory.ps1") -ProjectRoot $ProjectRoot
  $validatorOutput | ForEach-Object { Write-Host $_ }
} else {
  Write-Host ""
  Write-Host "Validation:"
  Write-Host "- Skipped. Re-run with -RunValidator to validate and refresh memory-index.yaml."
}

Write-Host ""
Write-Host "Closeout summary:"
Write-Host ("- checklist: {0}" -f $(if (Test-Path -LiteralPath $checklistPath) { "available" } else { "missing" }))
Write-Host ("- changed_paths: {0}" -f $ChangedPaths.Count)
Write-Host ("- signals: {0}" -f $Signals.Count)
Write-Host ("- validator_run: {0}" -f $RunValidator.ToString().ToLower())
Write-Host "- next_step: update the suggested memory files, then re-run with validation if memory changed."
