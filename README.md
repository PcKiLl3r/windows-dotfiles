# windows-dotfiles

Config files for the Windows Omarchy-parity setup, symlinked into `$HOME`
by `Link.ps1`. This is the Windows counterpart to
[`.dotfiles`](https://github.com/PcKiLl3r/.dotfiles) -- system-level
provisioning lives in the separate
[`windows-setup`](https://github.com/PcKiLl3r/windows-setup) repo; this
repo only links config into `$HOME`.

```powershell
./run.ps1                      # link the "windows" preset
./Link.ps1 -Mode windows       # same, explicit
./Link.ps1 -Folders komorebi,yasb   # link specific packages only
```

## Directory overview

Each top-level directory is a package, laid out as `<package>/<path-under-$HOME>`
-- same convention as `.dotfiles`, except `Link.ps1` symlinks individual
**files**, not whole directories (no Windows Stow, and directory-level
links would reintroduce the exact bug `.dotfiles/stow:34-43` documents:
unlinking a config dir briefly removes the target and lets the app
regenerate a stub in the gap).

| Package | Links to |
|---|---|
| `komorebi` | `~/.config/komorebi/{komorebi.json,applications.json}` |
| `whkd` | `~/.config/whkdrc` |
| `ahk` | `~/.config/ahk/omarchy.ahk` |
| `yasb` | `~/.config/yasb/{config.yaml,styles.css}` |
| `flow-launcher` | `~/AppData/Roaming/FlowLauncher/Settings/Settings.json` |
| `alacritty` | `~/.config/alacritty/{alacritty.toml,colors.toml}` |
| `pwsh` | `~/Documents/PowerShell/Microsoft.PowerShell_profile.ps1` |
| `git` | `~/.gitconfig` |
| `nvim` | `~/.config/nvim` (submodule -> same `PcKiLl3r/init.lua` as Linux) |
| `btop` | `~/.config/btop/{btop.conf,themes/tokyo-night.theme}` |

## Theming

`bin/Build-Theme.ps1 -Theme <name>` reads `themes/<name>/colors.toml`
(same 31-key palette shape as Omarchy's
`~/.local/state/omarchy/current/theme/colors.toml`) and regenerates
`yasb/styles.css`, `komorebi.json`'s `border_colours`, and
`alacritty/colors.toml`. Drop another Omarchy theme's `colors.toml` into a
new `themes/<name>/` directory and re-run to switch.

## Prerequisites

PowerShell 7, Git. Creating symlinks needs Developer Mode (enabled by
`windows-setup/steps/45-windows-tweaks.ps1`) or an elevated shell --
`Link.ps1` preflight-checks this and names the remedy.

## Keybinding source of truth

`whkd/.config/whkdrc` has per-bind comments explaining every Omarchy ->
komorebi/whkd translation, remap, or intentional drop. See
`windows-setup/README.md` for the audit checklist and OS-reserved-hotkey
notes.
