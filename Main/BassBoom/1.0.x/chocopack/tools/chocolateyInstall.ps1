$ErrorActionPreference = 'Stop';
Write-Output "<*>: for assumptions, <+> for progress, <-> for error"

# Prepare the basic variables
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$pkgName    = "bassboom"
$version    = "v1.0.3"
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
  checksum      = "21F049D88C7C939C7D917E663FAA4AA1F8768634A110CF5D902B04BFD071C37D"
  checksumType  = 'sha256'
  checksum64    = "21F049D88C7C939C7D917E663FAA4AA1F8768634A110CF5D902B04BFD071C37D"
  checksumType64= 'sha256'
}

# Change URL if ARM64 is detected
if ($architecture -eq "Arm64") {
    $packageArgs.url        = "https://github.com/Aptivi/BassBoom/releases/download/$version/bassboom-win-arm64-installer.exe"
    $packageArgs.url64bit   = "https://github.com/Aptivi/BassBoom/releases/download/$version/bassboom-win-arm64-installer.exe"
    $packageArgs.checksum   = "664A8C1ABCC93229E5FD28D226DB904E7B8D7C1342211A03914C0F1ED0D07B19"
    $packageArgs.checksum64 = "664A8C1ABCC93229E5FD28D226DB904E7B8D7C1342211A03914C0F1ED0D07B19"
}

Write-Output "<*> URL: $($packageArgs.url)"
Write-Output "<*> Expected SHA256 Sum: $($packageArgs.checksum)"

Write-Output "<+> Starting installation..."
Install-ChocolateyPackage @packageArgs
Write-Output "<+> Installation complete!"
