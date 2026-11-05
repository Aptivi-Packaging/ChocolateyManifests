$ErrorActionPreference = 'Stop';
Write-Output "<*>: for assumptions, <+> for progress, <-> for error"

# Prepare the basic variables
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$pkgName    = "mediaboom"
$version    = "v1.0.0.0"
Write-Output "<*> Installation directory: $toolsDir"
Write-Output "<*> Package Name: $pkgName ($version)"

# Check the system architecture
$architecture = [System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture
Write-Output "<*> Architecture: $architecture"

$packageArgs = @{
  packageName   = $pkgName
  fileType      = 'exe'
  url           = "https://github.com/Aptivi/MediaBoom/releases/download/$version/mediaboom-win-x64-installer.exe"
  url64bit      = "https://github.com/Aptivi/MediaBoom/releases/download/$version/mediaboom-win-x64-installer.exe"
  silentArgs    = "/quiet /norestart"
  validExitCodes= @(0, 3010, 1641)
  softwareName  = 'Nitrocid*'
  checksum      = "8C841B8B941F17BA61778CB8B8F2B9E092CD5B40EFF7B0D40D67A6C6FC0FC66D"
  checksumType  = 'sha256'
  checksum64    = "8C841B8B941F17BA61778CB8B8F2B9E092CD5B40EFF7B0D40D67A6C6FC0FC66D"
  checksumType64= 'sha256'
}

# Change URL if ARM64 is detected
if ($architecture -eq "Arm64") {
    $packageArgs.url        = "https://github.com/Aptivi/MediaBoom/releases/download/$version/mediaboom-win-arm64-installer.exe"
    $packageArgs.url64bit   = "https://github.com/Aptivi/MediaBoom/releases/download/$version/mediaboom-win-arm64-installer.exe"
    $packageArgs.checksum   = "FC386C1CFA5886D6AF2D346353D1897F46269A2F3E477C034ACE5299FAE3C51A"
    $packageArgs.checksum64 = "FC386C1CFA5886D6AF2D346353D1897F46269A2F3E477C034ACE5299FAE3C51A"
}

Write-Output "<*> URL: $($packageArgs.url)"
Write-Output "<*> Expected SHA256 Sum: $($packageArgs.checksum)"

Write-Output "<+> Starting installation..."
Install-ChocolateyPackage @packageArgs
Write-Output "<+> Installation complete!"
