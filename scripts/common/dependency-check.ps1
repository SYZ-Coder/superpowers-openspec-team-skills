function Read-BundleManifest {
  param(
    [Parameter(Mandatory = $true)]
    [string]$BundleRoot
  )

  $manifestPath = Join-Path $BundleRoot "manifest.json"
  if (-not (Test-Path $manifestPath)) {
    throw "Bundle manifest not found: $manifestPath"
  }

  return Get-Content $manifestPath -Raw | ConvertFrom-Json
}

function Test-RuntimeDependency {
  param(
    [Parameter(Mandatory = $true)]
    [string]$Requirement
  )

  switch ($Requirement) {
    "openspec-cli" {
      return $null -ne (Get-Command openspec -ErrorAction SilentlyContinue)
    }
    default {
      return $false
    }
  }
}

function Get-DependencyResults {
  param(
    [Parameter(Mandatory = $true)]
    $Manifest
  )

  $results = @()
  if (-not $Manifest.runtimeRequirements) {
    return $results
  }
  foreach ($req in $Manifest.runtimeRequirements) {
    $results += [PSCustomObject]@{
      Name = $req
      Available = (Test-RuntimeDependency $req)
    }
  }
  return ,$results
}

function Show-DependencyResults {
  param(
    [AllowNull()]
    [array]$DependencyResults
  )

  if (-not $DependencyResults) {
    return
  }

  if ($DependencyResults.Count -gt 0) {
    Write-Host "Runtime dependency check:"
    $DependencyResults | ForEach-Object {
      $status = if ($_.Available) { "ok" } else { "missing" }
      Write-Host ("- {0} [{1}]" -f $_.Name, $status)
    }
    Write-Host ""
  }
}

function Get-MissingDependencies {
  param(
    [AllowNull()]
    [array]$DependencyResults
  )

  if (-not $DependencyResults) {
    return @()
  }

  $results = @($DependencyResults | Where-Object { -not $_.Available })
  return ,$results
}
