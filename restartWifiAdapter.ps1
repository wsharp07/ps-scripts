#requires -Version 3.0

<# 

.SYNOPSIS

Tests to see if google.com responds to ping, if not the Wi-Fi adapter is restarted

.PARAMETER WifiAdapterName

Optional string input of the name of the Wi-Fi adapter. (Default: "Wi-Fi")

.PARAMETER LogPath

Optional path where you would like logs to be stored. (Default: "C:\Logs")

.EXAMPLE

Setup a 30 minute task in Windows Task Scheduler
./restartWifiAdapter.ps1 -WifiAdapterName "Wi-Fi" -LogPath "C:\Logs"
 
#>

param
(
	[string]
	$WifiAdapterName,
	[string]
	$LogPath
)

If (!$LogPath) {
	# Set default path
	$LogPath = "C:\Logs"
}

If (!$WifiAdapterName) {
    # Set default name
    $WifiAdapterName = "Wi-Fi"
}

Start-Transcript $LogPath\RestartWiFi_$(Get-Date -Format "yyyyMMddHHmm").txt
 
$pingTest = ping www.google.com | Select-String "Reply from"
 
If ( $pingTest.count -eq 0 ) {
    Write-Output "[WARN] Ping test failed. Restarting Wi-Fi adapter."

    Disable-NetAdapter $WifiAdapterName -Confirm:$false
    Sleep 5
    Enable-NetAdapter $WifiAdapterName -Confirm:$false
}
Else {
    Write-Output "[INFO] Ping test successful. Exiting."
}
 
Stop-Transcript