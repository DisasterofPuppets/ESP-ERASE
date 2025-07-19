# PowerShell script to list COM ports and erase ESP32 and 8266 boards using esptool

Write-Host "Scanning available COM ports..." -ForegroundColor Cyan

# Use Win32_PnPEntity to avoid locking ports
$ports = Get-CimInstance Win32_PnPEntity | Where-Object { 
    $_.ClassGuid -eq "{4d36e978-e325-11ce-bfc1-08002be10318}" -and 
    $_.Name -match "COM\d+"
}

# Initialize variables
$menuMap = @{}
$i = 1

# Extract COM port from Name field
foreach ($port in $ports) {
    if ($port.Name -match "(COM\d+)") {
        $comPort = $matches[1]
        $desc = $port.Name
        Write-Host "${i}: $desc"
        $menuMap[$i] = $comPort
        $i++
    }
}

if (-not $ports) {
    Write-Host "No COM ports detected. Plug in your ESP32 and try again." -ForegroundColor Red
    exit
}


# Prompt for selection
$selection = Read-Host "Enter the number of the COM port to use for ESPX erase"

if (-not ($selection -match '^\d+$') -or -not $menuMap.ContainsKey([int]$selection)) {
    Write-Host "Invalid selection. Aborting." -ForegroundColor Red
    exit
}

$comPort = $menuMap[[int]$selection]
Write-Host ""
Write-Host "Selected port: $comPort"
Write-Host "Starting flash erase using esptool..."

# Auto-detect chip type and erase
Write-Host "Auto-detecting chip type..." -ForegroundColor Yellow
$detectCmd = "python -m esptool --port $comPort chip_id"
$detectOutput = Invoke-Expression $detectCmd 2>&1

if ($detectOutput -match "ESP32") {
    Write-Host "Detected ESP32" -ForegroundColor Green
    $cmd = "python -m esptool --port $comPort erase_flash"
} elseif ($detectOutput -match "ESP8266") {
    Write-Host "Detected ESP8266" -ForegroundColor Green  
    $cmd = "python -m esptool --chip esp8266 --port $comPort erase_flash"
} else {
    Write-Host "Could not detect chip type. Trying generic erase..." -ForegroundColor Yellow
    $cmd = "python -m esptool --port $comPort erase_flash"
}

Write-Host "Erasing flash..."
Invoke-Expression $cmd
