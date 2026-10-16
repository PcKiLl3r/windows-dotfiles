# PowerShell profile for the default terminal (alacritty -> pwsh), linked
# by windows-dotfiles/Link.ps1. Kept minimal -- aliases for the komorebi/
# whkd workflow and the $DOTFILES/$env:USERPROFILE\.setup paths this
# project uses, matching the terseness of the Linux ~/.bashrc.

$env:DOTFILES = "$HOME\.dotfiles"
$env:SETUP = "$HOME\.setup"

function Edit-Dotfiles { Set-Location $env:DOTFILES }
Set-Alias -Name dotfiles -Value Edit-Dotfiles

function Edit-Setup { Set-Location $env:SETUP }
Set-Alias -Name setup -Value Edit-Setup

function Restart-Tiling { & "$env:SETUP\steps\80-autostart.ps1" }
Set-Alias -Name retile -Value Restart-Tiling

Set-Alias -Name vim -Value nvim -ErrorAction SilentlyContinue
Set-Alias -Name g -Value git -ErrorAction SilentlyContinue
