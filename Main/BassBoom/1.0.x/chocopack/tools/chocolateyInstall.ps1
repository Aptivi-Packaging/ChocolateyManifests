$ErrorActionPreference = 'Stop';
Write-Output "<*>: for assumptions, <+> for progress, <-> for error"

# Prepare the basic variables
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$pkgName    = "bassboom"
$version    = "v1.0.2"
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
  checksum      = "863D519A296D21DF357366862C30E169199B7972A94182A82CF90FB3B21C9567"
  checksumType  = 'sha256'
  checksum64    = "863D519A296D21DF357366862C30E169199B7972A94182A82CF90FB3B21C9567"
  checksumType64= 'sha256'
}

# Change URL if ARM64 is detected
if ($architecture -eq "Arm64") {
    $packageArgs.url        = "https://github.com/Aptivi/BassBoom/releases/download/$version/bassboom-win-arm64-installer.exe"
    $packageArgs.url64bit   = "https://github.com/Aptivi/BassBoom/releases/download/$version/bassboom-win-arm64-installer.exe"
    $packageArgs.checksum   = "AAA817752DED77A5558BB0A869DEEE434BC2BE12154635452BAC597B61A79F02"
    $packageArgs.checksum64 = "AAA817752DED77A5558BB0A869DEEE434BC2BE12154635452BAC597B61A79F02"
}

Write-Output "<*> URL: $($packageArgs.url)"
Write-Output "<*> Expected SHA256 Sum: $($packageArgs.checksum)"

Write-Output "<+> Starting installation..."
Install-ChocolateyPackage @packageArgs
Write-Output "<+> Installation complete!"
