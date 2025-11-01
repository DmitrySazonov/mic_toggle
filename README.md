# mic_toggle

A small Windows utility written in Rust to **mute / unmute / toggle / check** the system microphone using the Windows CoreAudio API.

## ✨ Features
- Works on **Windows 10 / 11**
- No admin rights required
- Operates via system-level mute (CoreAudio `IAudioEndpointVolume`)
- Tiny, fast, single `.exe` file (~1 MB)
- Useful for scripts, automation, or hardware macro buttons

## 🧰 Commands

```bash
mic_toggle.exe status   # Show current mute state
mic_toggle.exe mute     # Mute microphone
mic_toggle.exe unmute   # Unmute microphone
mic_toggle.exe toggle   # Toggle mute/unmute
```

## 🧩 Build Instructions

### 1️⃣ Install Rust
Install Rust using the official installer:  
👉 [https://rustup.rs](https://rustup.rs)

####️⃣ Install Visual Studio Build Tools (MSVC)

Rust on Windows requires the MSVC toolchain.

Download the installer:
👉 https://aka.ms/vs/17/release/vs_buildtools.exe

During setup:

- ✅ Select Desktop development with C++

- ✅ Check MSVC v143 build tools (or newer)

- ✅ Check Windows 10/11 SDK

- Then install and restart the terminal (or open x64 Native Tools Command Prompt for VS).

## 🧩 Windows Hotkey Helper

An optional **AutoHotkey** script is included in the [`ahk/`](ahk/) folder to provide:
- A **Num Lock** hotkey to toggle the microphone mute state.
- A small OSD popup (🔴 / 🟢).
- Tray icon indicator (red = muted, green = active).
- Num Lock LED synced to mic state.

### Setup

1. Install [AutoHotkey v2](https://www.autohotkey.com/download/). 
2. Copy the compiled mic_toggle.exe to C:\Tools\mic_toggle\ or adjust the path inside the .ahk file.
3. Run ahk/mic_toggle_hotkey.ahk.

## 🖥️ Optional: Auto-start on Windows

If you want the **AutoHotkey** helper (`ahk/mic_toggle_hotkey.ahk`) to start automatically with Windows:

### Method 1 (recommended) – Startup folder
1. Press **Win + R**, type `shell:startup` and hit **Enter**.  
   This opens your personal Startup folder: C:\Users<YourName>\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup
2. Create a shortcut to `ahk/mic_toggle_hotkey.ahk` (right-click → *Send to → Desktop (create shortcut)*).
3. Move the shortcut into the Startup folder.  
   → The script will run automatically every time you log in.

### Method 2 – Compiled version
You can also compile the `.ahk` file to `.exe` using the **Ahk2Exe** compiler  
(included with AutoHotkey v2), then place that EXE shortcut in the Startup folder.

### Method 3 – Task Scheduler (for admin startup)
If you need the script to run with elevated privileges:
1. Open **Task Scheduler** → *Create Task*.
2. Under **Triggers**, choose *At log on*.
3. Under **Actions**, set:
- **Program:** `AutoHotkey64.exe`
- **Arguments:** `"C:\path\to\mic_toggle_hotkey.ahk"`
4. Enable *Run with highest privileges* and save.

---