param(
  [switch]$Clean
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$distRoot = Join-Path $repoRoot "dist"
$teamSkillsRoot = Join-Path $repoRoot "team-skills"

if ($Clean -and (Test-Path $distRoot)) {
  Remove-Item -Recurse -Force $distRoot
}

New-Item -ItemType Directory -Force -Path $distRoot | Out-Null

Write-Host "build-dist.ps1 currently preserves hand-authored bundles under dist/."
Write-Host "This script establishes the maintainer workflow and validates the expected source directories."
Write-Host ""

$requiredWorkflows = @(
  "openspec-superpowers-workflow",
  "superpowers-openspec-execution-workflow",
  "superpowers-feature-workflow",
  "openspec-feature-workflow",
  "superpowers-learning-workflow"
)

Write-Host "Source workflow check:"
foreach ($workflow in $requiredWorkflows) {
  $workflowPath = Join-Path $teamSkillsRoot $workflow
  $metaPath = Join-Path $workflowPath "workflow.yaml"
  $skillPath = Join-Path $workflowPath "SKILL.md"
  $ok = (Test-Path $workflowPath) -and (Test-Path $metaPath) -and (Test-Path $skillPath)
  $status = if ($ok) { "ok" } else { "missing" }
  Write-Host ("- {0} [{1}]" -f $workflow, $status)
}

Write-Host ""
Write-Host "Dist bundles remain available under:"
Write-Host "- dist/codex/bundles"
Write-Host "- dist/cursor/bundles"
Write-Host "- dist/claude-code/bundles"
Write-Host ""
Write-Host "Next step for maintainers: replace hand-authored dist generation with template-based rendering from workflow.yaml."
