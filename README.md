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