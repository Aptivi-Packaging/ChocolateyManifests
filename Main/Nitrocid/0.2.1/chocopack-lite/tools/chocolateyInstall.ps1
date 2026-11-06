$ErrorActionPreference = 'Stop';
Write-Output "<*>: for assumptions, <+> for progress, <-> for error"

# Prepare the basic variables
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$pkgName    = "KS"
$version    = "v0.2.1.1"
Write-Output "<*> Installation directory: $toolsDir"
Write-Output "<*> Package Name: $pkgName ($version)"

# Check the system architecture
$architecture = [System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture
Write-Output "<*> Architecture: $architecture"

$packageArgs = @{
  packageName   = $pkgName
  fileType      = 'exe'
  url           = "https://github.com/Aptivi/Nitrocid/releases/download/$version/nitrocid-win-x64-installer.exe"
  url64bit      = "https://github.com/Aptivi/Nitrocid/releases/download/$version/nitrocid-win-x64-installer.exe"
  silentArgs    = "/quiet /norestart NitrocidLite=1"
  validExitCodes= @(0, 3010, 1641)
  softwareName  = 'Nitrocid*'
  checksum      = "D75AA63E171654F4D44522D531AC124A407D634B7D52568C11762553960408BB"
  checksumType  = 'sha256'
  checksum64    = "D75AA63E171654F4D44522D531AC124A407D634B7D52568C11762553960408BB"
  checksumType64= 'sha256'
}

# Change URL if ARM64 is detected
if ($architecture -eq "Arm64") {
    $packageArgs.url        = "https://github.com/Aptivi/Nitrocid/releases/download/$version/nitrocid-win-arm64-installer.exe"
    $packageArgs.url64bit   = "https://github.com/Aptivi/Nitrocid/releases/download/$version/nitrocid-win-arm64-installer.exe"
    $packageArgs.checksum   = "192E5A13CCCB694DBE84AC42C208F6AE152CB2ED53AC8F26D5103886E2E1D62B"
    $packageArgs.checksum64 = "192E5A13CCCB694DBE84AC42C208F6AE152CB2ED53AC8F26D5103886E2E1D62B"
}

Write-Output "<*> URL: $($packageArgs.url)"
Write-Output "<*> Expected SHA256 Sum: $($packageArgs.checksum)"

Write-Output "<+> Starting installation..."
Install-ChocolateyPackage @packageArgs
Write-Output "<+> Installation complete!"
