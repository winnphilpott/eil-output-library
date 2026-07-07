# Render every .qmd in this folder to PDF, regardless of where it's called from.
#
# Requirements:
#   - Quarto:  https://quarto.org/docs/get-started/
#   - LaTeX:   run once  ->  quarto install tinytex
#
# Usage (PowerShell):  .\render.ps1
$ErrorActionPreference = "Stop"
Set-Location -Path $PSScriptRoot

function Find-Quarto {
    $cmd = Get-Command quarto -ErrorAction SilentlyContinue
    if ($cmd) { return $cmd.Source }
    $candidates = @(
        "$env:ProgramFiles\RStudio\resources\app\bin\quarto\bin\quarto.exe",
        "$env:LOCALAPPDATA\Programs\RStudio\resources\app\bin\quarto\bin\quarto.exe",
        "$env:ProgramFiles\Quarto\bin\quarto.exe"
    )
    foreach ($c in $candidates) { if (Test-Path $c) { return $c } }
    return $null
}

$quarto = Find-Quarto
if (-not $quarto) {
    Write-Error "quarto not found. Install from https://quarto.org/docs/get-started/"
    exit 1
}

$qmds = Get-ChildItem -Path . -Filter *.qmd
if ($qmds.Count -eq 0) {
    Write-Host "No .qmd files to render in $(Get-Location)"
    exit 0
}

foreach ($qmd in $qmds) {
    Write-Host "Rendering $($qmd.Name) ..."
    & $quarto render $qmd.Name
}
