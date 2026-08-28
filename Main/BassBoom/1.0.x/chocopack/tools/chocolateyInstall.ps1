$ErrorActionPreference = 'Stop';
Write-Output "<*>: for assumptions, <+> for progress, <-> for error"

# Prepare the basic variables
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$pkgName    = "bassboom"
$version    = "v1.0.2.3"
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
  checksum      = "3FD3E15EA696DBDFCF35F8E61C538D9781DC0957652707385107956669413E13"
  checksumType  = 'sha256'
  checksum64    = "3FD3E15EA696DBDFCF35F8E61C538D9781DC0957652707385107956669413E13"
  checksumType64= 'sha256'
}

# Change URL if ARM64 is detected
if ($architecture -eq "Arm64") {
    $packageArgs.url        = "https://github.com/Aptivi/BassBoom/releases/download/$version/bassboom-win-arm64-installer.exe"
    $packageArgs.url64bit   = "https://github.com/Aptivi/BassBoom/releases/download/$version/bassboom-win-arm64-installer.exe"
    $packageArgs.checksum   = "258BC33F6AA87189BCBA1BE8B009054834626704CC114C00188C588D0FF524C0"
    $packageArgs.checksum64 = "258BC33F6AA87189BCBA1BE8B009054834626704CC114C00188C588D0FF524C0"
}

Write-Output "<*> URL: $($packageArgs.url)"
Write-Output "<*> Expected SHA256 Sum: $($packageArgs.checksum)"

Write-Output "<+> Starting installation..."
Install-ChocolateyPackage @packageArgs
Write-Output "<+> Installation complete!"
