use anyhow::{Context, Result};
use std::env;
use windows::{
    core::Result as WinResult,
    Win32::{
        Foundation::BOOL,
        Media::Audio::{
            eCapture, eCommunications, eMultimedia, EDataFlow, ERole,
            IMMDevice, IMMDeviceEnumerator, MMDeviceEnumerator,
            Endpoints::IAudioEndpointVolume,
        },
        System::Com::{
            CoCreateInstance, CoInitializeEx, CoUninitialize,
            CLSCTX_INPROC_SERVER, COINIT_APARTMENTTHREADED,
            StructuredStorage::PROPVARIANT, // можно не использовать явно, но пусть будет импорт
        },
    },
};

fn get_endpoint_volume() -> Result<IAudioEndpointVolume> {
    unsafe {
        CoInitializeEx(None, COINIT_APARTMENTTHREADED)
            .ok()
            .context("CoInitializeEx failed")?;
    }

    let enumerator: IMMDeviceEnumerator = unsafe {
        CoCreateInstance(&MMDeviceEnumerator, None, CLSCTX_INPROC_SERVER)
            .context("CoCreateInstance(IMMDeviceEnumerator) failed")?
    };

    fn activate_endpoint(enumerator: &IMMDeviceEnumerator, role: ERole) -> WinResult<IAudioEndpointVolume> {
        unsafe {
            let device: IMMDevice = enumerator.GetDefaultAudioEndpoint(EDataFlow(eCapture.0), role)?;
            // В 0.48 метод существует, когда включена фича StructuredStorage (PROPVARIANT).
            device.Activate::<IAudioEndpointVolume>(CLSCTX_INPROC_SERVER, None)
        }
    }

    let epv = activate_endpoint(&enumerator, ERole(eCommunications.0))
        .or_else(|_| activate_endpoint(&enumerator, ERole(eMultimedia.0)))
        .context("Failed to get IAudioEndpointVolume for default capture device")?;

    Ok(epv)
}

fn print_usage() {
    eprintln!("Usage: mic_toggle [toggle|mute|unmute|status]");
}

fn main() -> Result<()> {
    let cmd = env::args().nth(1).unwrap_or_else(|| "toggle".to_string());
    let epv = get_endpoint_volume().context("Cannot get endpoint volume")?;

    let res = match cmd.as_str() {
        "status" => {
            unsafe {
                let muted: BOOL = epv.GetMute()?;         // <-- без .ok()!
                println!("Muted: {}", muted.as_bool());
            }
            Ok(())
        }
        "mute" => {
            unsafe { epv.SetMute(BOOL(1), std::ptr::null())?; } // <-- без .ok()!
            println!("Muted.");
            Ok(())
        }
        "unmute" => {
            unsafe { epv.SetMute(BOOL(0), std::ptr::null())?; } // <-- без .ok()!
            println!("Unmuted.");
            Ok(())
        }
        "toggle" => {
            unsafe {
                let muted: BOOL = epv.GetMute()?;               // <-- без .ok()!
                let new_state = if muted.as_bool() { BOOL(0) } else { BOOL(1) };
                epv.SetMute(new_state, std::ptr::null())?;      // <-- без .ok()!
                println!("{}", if muted.as_bool() { "Unmuted." } else { "Muted." });
            }
            Ok(())
        }
        _ => {
            print_usage();
            Ok(())
        }
    };

    unsafe { CoUninitialize(); }
    res
}
