#requires -Version 3.0

<# 

.SYNOPSIS

Tests to see if google.com responds to ping, if not the Wi-Fi adapter is restarted

.PARAMETER WifiAdapterName

Optional string input of the name of the Wi-Fi adapter. (Default: "Wi-Fi")

.PARAMETER LogPath

Optional path where you would like logs to be stored. (Default: "C:\Logs")

.PARAMETER IsEnabled

If True the adapter will be enabled, if False the adapter will be disabled (Default: True)

.EXAMPLE

Setup a 30 minute task in Windows Task Scheduler
./restartWifiAdapter.ps1 -WifiAdapterName "Wi-Fi" -LogPath "C:\Logs"
 
#>

param
(
	[string]
	$WifiAdapterName = "Wi-Fi",
	[string]
	$LogPath = "C:\Logs",
    [bool]
    $IsEnabled = $TRUE
)

Start-Transcript $LogPath\SetWifiAdapter_$(Get-Date -Format "yyyyMMddHHmm").txt

$_currentAdapterStatus = (Get-NetAdapter -Name $WifiAdapterName).Status 

# Not enabled, want to enable
If (($_currentAdapterStatus -ne 'Connected') && $IsEnabled -eq $TRUE) {
    Write-Output "Enabling Wi-Fi Adapter"
    Enable-NetAdapter -Name $WifiAdapterName -Confirm:$false
}

# Not enabled, want to disable
If (($_currentAdapterStatus -ne 'Connected') && $IsEnabled -eq $FALSE) {
    Write-Output "Wi-Fi Adapter is already disabled"
}

# Enabled, want to enable
If (($_currentAdapterStatus -eq 'Connected') && $IsEnabled -eq $TRUE) {
    Write-Output "Wi-Fi Adapter is already enabled"
}

# Enabled, want to disable
If (($_currentAdapterStatus -eq 'Connected') && $IsEnabled -eq $FALSE) {
    Write-Output "Disabling Wi-Fi Adapter"
    Disable-NetAdapter -Name $WifiAdapterName -Confirm:$false
}

Stop-Transcript