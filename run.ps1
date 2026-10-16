#Requires -Version 7
# Mirrors ~/.dotfiles/run: resolve $DOTFILES and the package preset, then
# delegate to Link.ps1.
$ErrorActionPreference = 'Stop'

$Dotfiles = if ($env:DOTFILES) { $env:DOTFILES } else { "$HOME\.dotfiles" }
$presetFile = Join-Path $PSScriptRoot 'presets\windows'
$folders = Get-Content $presetFile | Where-Object { $_.Trim() }

$env:DOTFILES = $Dotfiles
& (Join-Path $PSScriptRoot 'Link.ps1') -Folders $folders
