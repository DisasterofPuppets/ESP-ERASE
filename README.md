# ESP Flash Erase Script

PowerShell script to detect COM ports and erase ESP32/ESP8266 flash memory using esptool.

## Features

- Auto-detects available COM ports without locking them
- Interactive menu for port selection
- Auto-detects ESP32 vs ESP8266 chip type
- Uses esptool for reliable flash erasing

## Prerequisites

- **PowerShell 3.0+** (uses `Get-CimInstance`, available in Windows 8/Server 2012+)
- **Python with esptool:** `pip install esptool`
- **ESP32/ESP8266 USB drivers** (CP210x or CH340)

## PowerShell Compatibility

- **Windows PowerShell 3.0-5.1:** Full support
- **PowerShell Core 6.0+:** Full support (cross-platform)
- **Built-in cmdlets used:** `Get-CimInstance`, `Write-Host`, `Read-Host`, `Invoke-Expression`
- **No external modules required**

## Usage

1. Connect your ESP32/ESP8266 via USB
2. Run the script:
  ```powershell
  .\esp-flash-erase.ps1
