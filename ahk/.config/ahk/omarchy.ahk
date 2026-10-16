; AutoHotkey fallback binds -- only things whkd/komorebi genuinely can't do,
; or binds that may need to move here from whkdrc if whkd turns out to be
; keyboard-layout-sensitive once Real Programmer Dvorak is active (see
; windows-setup/keyboard/README.md "whkd + custom layout risk").
;
; Each entry below carries a comment saying why it's here and not in
; whkdrc -- keep that convention for anything added later.

#Requires AutoHotkey v2.0
#SingleInstance Force

; SUPER+CTRL+ALT+BACKSPACE: blank all monitors (DPMS off equivalent).
; No single Windows API call does this reliably across all GPUs/drivers,
; so this turns the primary monitor off via WM_SYSCOMMAND/SC_MONITORPOWER
; -- not a whkd/komorebi concern, hence AHK.
#^!Backspace::{
    SendMessage(0x0112, 0xF170, 2,, "Program Manager")  ; WM_SYSCOMMAND, SC_MONITORPOWER, off
}

; Reserved for CapsLock-as-layout-cycle if PowerToys Keyboard Manager
; proves unreliable for this (PowerToys config is linked by
; windows-setup/steps/70-dotfiles.ps1 as the primary mechanism; this is
; the documented fallback, intentionally left commented out until needed):
; CapsLock::AltTab  ; placeholder -- replace with actual layout-cycle call if PowerToys remap doesn't hold
