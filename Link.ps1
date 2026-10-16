#Requires -Version 7
# Mirrors ~/.dotfiles/stow's role, but creates FILE-level symlinks instead
# of directory-level ones (no Stow equivalent exists on Windows, and
# directory symlinks would reintroduce the exact bug the Linux repo's
# stow script works around: unlinking a whole config dir briefly removes
# the target and lets the app regenerate a stub in the gap -- see
# ~/.dotfiles/stow:34-43 for the load-bearing comment this follows).
#
# Usage:
#   ./Link.ps1 -Mode windows          # read presets/windows
#   ./Link.ps1 -Folders komorebi,yasb # explicit package list
#
# Idempotent: New-Item -ItemType SymbolicLink -Force overwrites an existing
# link pointing anywhere (including a stale target); it refuses to
# overwrite a REAL file, same as `stow` refusing on a conflicting file.
param(
    [string]$Mode,
    [string[]]$Folders
)
$ErrorActionPreference = 'Stop'

if (-not $env:DOTFILES) {
    Write-Error "`$env:DOTFILES not set -- run via run.ps1, or set `$env:DOTFILES = '<path to this repo>' first."
    exit 1
}
$Dotfiles = $env:DOTFILES

if ($Mode) {
    $presetFile = Join-Path $Dotfiles "presets\$Mode"
    if (-not (Test-Path $presetFile)) {
        Write-Error "no such preset: presets\$Mode. Available presets:`n$((Get-ChildItem (Join-Path $Dotfiles 'presets')).Name -join "`n")"
        exit 1
    }
    $Folders = Get-Content $presetFile | Where-Object { $_.Trim() }
}

if (-not $Folders) {
    Write-Error "Usage: ./Link.ps1 -Mode <preset> | -Folders <pkg1>,<pkg2>,..."
    exit 1
}

if (-not ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))) {
    $devMode = Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock' -Name 'AllowDevelopmentWithoutDevLicense' -ErrorAction SilentlyContinue
    if (-not $devMode -or $devMode.AllowDevelopmentWithoutDevLicense -ne 1) {
        Write-Error "Creating symlinks needs Developer Mode or an elevated shell. Run windows-setup/steps/45-windows-tweaks.ps1 first, or re-run this from an admin PowerShell."
        exit 1
    }
}

foreach ($folder in $Folders) {
    $pkgRoot = Join-Path $Dotfiles $folder
    if (-not (Test-Path $pkgRoot)) {
        Write-Warning "package not found, skipping: $folder"
        continue
    }
    Write-Host "link $folder"
    Get-ChildItem -Path $pkgRoot -Recurse -File | ForEach-Object {
        $relative = $_.FullName.Substring($pkgRoot.Length + 1)
        $target = Join-Path $HOME $relative
        $targetDir = Split-Path $target -Parent
        if (-not (Test-Path $targetDir)) {
            New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
        }
        if ((Test-Path $target) -and -not (Get-Item $target -Force).LinkType) {
            Write-Warning "    real file exists at $target, not a symlink -- skipping (back it up and remove it to link this package fully)"
            return
        }
        New-Item -ItemType SymbolicLink -Path $target -Target $_.FullName -Force | Out-Null
        Write-Host "    -> $target"
    }
}
