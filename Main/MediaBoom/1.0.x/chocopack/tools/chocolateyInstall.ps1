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
  checksum      = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
  checksumType  = 'sha256'
  checksum64    = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
  checksumType64= 'sha256'
}

# Change URL if ARM64 is detected
if ($architecture -eq "Arm64") {
    $packageArgs.url        = "https://github.com/Aptivi/MediaBoom/releases/download/$version/mediaboom-win-arm64-installer.exe"
    $packageArgs.url64bit   = "https://github.com/Aptivi/MediaBoom/releases/download/$version/mediaboom-win-arm64-installer.exe"
    $packageArgs.checksum   = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
    $packageArgs.checksum64 = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
}

Write-Output "<*> URL: $($packageArgs.url)"
Write-Output "<*> Expected SHA256 Sum: $($packageArgs.checksum)"

Write-Output "<+> Starting installation..."
Install-ChocolateyPackage @packageArgs
Write-Output "<+> Installation complete!"
