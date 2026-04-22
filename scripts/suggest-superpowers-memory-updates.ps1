param(
  [string]$ProjectRoot = (Get-Location).Path,
  [string[]]$ChangedPaths = @(),
  [string[]]$Signals = @()
)

$ErrorActionPreference = "Stop"

function Add-Suggestion {
  param(
    [System.Collections.Generic.List[object]]$Suggestions,
    [string]$Target,
    [string]$Reason,
    [int]$Priority = 50
  )

  $existing = $Suggestions | Where-Object { $_.Target -eq $Target } | Select-Object -First 1
  if ($existing) {
    if (-not ($existing.Reasons -contains $Reason)) {
      $existing.Reasons.Add($Reason) | Out-Null
    }
    if ($Priority -lt $existing.Priority) {
      $existing.Priority = $Priority
    }
  } else {
    $Suggestions.Add([PSCustomObject]@{
      Target = $Target
      Priority = $Priority
      Reasons = New-Object 'System.Collections.Generic.List[string]'
    }) | Out-Null
    ($Suggestions | Select-Object -Last 1).Reasons.Add($Reason) | Out-Null
  }
}

$suggestions = New-Object 'System.Collections.Generic.List[object]'
$normalizedPaths = $ChangedPaths | Where-Object { $_ } | ForEach-Object { $_.ToLowerInvariant() }
$normalizedSignals = $Signals | Where-Object { $_ } | ForEach-Object { $_.ToLowerInvariant() }

foreach ($path in $normalizedPaths) {
  if ($path -match 'docs|design|spec|architecture') {
    Add-Suggestion -Suggestions $suggestions -Target "PROJECT_CONTEXT.md" -Reason "Architecture or design-related files changed." -Priority 20
    Add-Suggestion -Suggestions $suggestions -Target "DECISIONS.md" -Reason "Design-oriented changes often imply a decision or updated rationale." -Priority 10
  }

  if ($path -match 'test|verify|validation|check') {
    Add-Suggestion -Suggestions $suggestions -Target "VERIFICATION_BASELINE.md" -Reason "Validation-related files changed." -Priority 15
  }

  if ($path -match 'bug|fix|failure|compat|shell|powershell|script') {
    Add-Suggestion -Suggestions $suggestions -Target "KNOWN_FAILURES.md" -Reason "Bug fixes or compatibility work may reveal a repeated failure pattern." -Priority 15
  }

  if ($path -match 'readme|guide|agents|claude|cursor|workflow|skill') {
    Add-Suggestion -Suggestions $suggestions -Target "TEAM_PREFERENCES.md" -Reason "Workflow or collaboration-facing files changed." -Priority 25
  }
}

foreach ($signal in $normalizedSignals) {
  if ($signal -match 'decision|tradeoff|architecture|boundary') {
    Add-Suggestion -Suggestions $suggestions -Target "DECISIONS.md" -Reason "A decision-style signal was provided." -Priority 10
  }

  if ($signal -match 'failure|pitfall|bug|misjudge|compat') {
    Add-Suggestion -Suggestions $suggestions -Target "KNOWN_FAILURES.md" -Reason "A failure-pattern signal was provided." -Priority 15
  }

  if ($signal -match 'verify|validation|baseline|evidence|test') {
    Add-Suggestion -Suggestions $suggestions -Target "VERIFICATION_BASELINE.md" -Reason "A verification-related signal was provided." -Priority 15
  }

  if ($signal -match 'preference|team|communication|workflow') {
    Add-Suggestion -Suggestions $suggestions -Target "TEAM_PREFERENCES.md" -Reason "A team-preference signal was provided." -Priority 25
  }

  if ($signal -match 'user|tone|language|format|communication-style') {
    Add-Suggestion -Suggestions $suggestions -Target "USER_PROFILE.md" -Reason "A durable user-preference signal was provided." -Priority 20
  }

  if ($signal -match 'agent|execution|reminder|quality|operational') {
    Add-Suggestion -Suggestions $suggestions -Target "AGENT_NOTES.md" -Reason "An agent-execution reminder signal was provided." -Priority 20
  }

  if ($signal -match 'fact|context|constraint|goal') {
    Add-Suggestion -Suggestions $suggestions -Target "PROJECT_CONTEXT.md" -Reason "A durable project-fact signal was provided." -Priority 20
  }

  if ($signal -match 'reusable|repeat|promotion|candidate|checklist|rule|skill') {
    Add-Suggestion -Suggestions $suggestions -Target "LEARNING_BACKLOG.md" -Reason "A reusable-pattern signal was provided." -Priority 30
  }
}

Add-Suggestion -Suggestions $suggestions -Target "CURRENT_STATE.md" -Reason "Always confirm the stopping point before ending a memory-aware session." -Priority 1
Add-Suggestion -Suggestions $suggestions -Target "session-journal/" -Reason "Add a short session note for meaningful work." -Priority 2
Add-Suggestion -Suggestions $suggestions -Target "SESSION_CLOSE_CHECKLIST.md" -Reason "Review the closeout checklist before claiming completion." -Priority 3

Write-Host "Superpowers memory update suggestions"
Write-Host "Project root: $ProjectRoot"
Write-Host ""

foreach ($item in ($suggestions | Sort-Object Priority, Target)) {
  Write-Host ("- {0}" -f $item.Target)
  Write-Host ("  priority={0}" -f $item.Priority)
  foreach ($reason in $item.Reasons) {
    Write-Host ("  - {0}" -f $reason)
  }
}
