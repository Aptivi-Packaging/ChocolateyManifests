$ErrorActionPreference = 'Stop';
Write-Output "<*>: for assumptions, <+> for progress, <-> for error"

# Prepare the basic variables
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$pkgName    = "bassboom"
$version    = "v1.0.1"
Write-Output "<*> Installation directory: $toolsDir"
Write-Output "<*> Package Name: $pkgName ($version)"

# Check the system architecture
$architecture = [System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture
Write-Output "<*> Architecture: $architecture"

$packageArgs = @{
  packageName   = $pkgName
  fileType      = 'exe'
  url           = "https://github.com/Aptivi/BassBoom/releases/download/$version/bassboom-win-x64-installer.exe"
  url64bit      = "https://github.com/Aptivi/BassBoom/releases/download/$version/bassboom-win-x64-installer.exe"
  silentArgs    = "/quiet /norestart"
  validExitCodes= @(0, 3010, 1641)
  softwareName  = 'Nitrocid*'
  checksum      = "531B78C55C5335970C0B8474D70F3CA1812F437AE494D13323B7E434F6FA2B16"
  checksumType  = 'sha256'
  checksum64    = "531B78C55C5335970C0B8474D70F3CA1812F437AE494D13323B7E434F6FA2B16"
  checksumType64= 'sha256'
}

# Change URL if ARM64 is detected
if ($architecture -eq "Arm64") {
    $packageArgs.url        = "https://github.com/Aptivi/BassBoom/releases/download/$version/bassboom-win-arm64-installer.exe"
    $packageArgs.url64bit   = "https://github.com/Aptivi/BassBoom/releases/download/$version/bassboom-win-arm64-installer.exe"
    $packageArgs.checksum   = "071C753F34D42A9891B2B4573937F05073B191293641A16664A0CB63677E5FE4"
    $packageArgs.checksum64 = "071C753F34D42A9891B2B4573937F05073B191293641A16664A0CB63677E5FE4"
}

Write-Output "<*> URL: $($packageArgs.url)"
Write-Output "<*> Expected SHA256 Sum: $($packageArgs.checksum)"

Write-Output "<+> Starting installation..."
Install-ChocolateyPackage @packageArgs
Write-Output "<+> Installation complete!"
