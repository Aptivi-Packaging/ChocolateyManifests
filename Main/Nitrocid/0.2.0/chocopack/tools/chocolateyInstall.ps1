$ErrorActionPreference = 'Stop';
Write-Output "<*>: for assumptions, <+> for progress, <-> for error"

# Prepare the basic variables
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$pkgName    = "KS"
$version    = "v0.2.0.11"
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
  silentArgs    = "/quiet /norestart"
  validExitCodes= @(0, 3010, 1641)
  softwareName  = 'Nitrocid*'
  checksum      = "31187F35D6678407C121C6A8DB5EFCE2105CCCA436C1B7E53164F713D0B275FB"
  checksumType  = 'sha256'
  checksum64    = "31187F35D6678407C121C6A8DB5EFCE2105CCCA436C1B7E53164F713D0B275FB"
  checksumType64= 'sha256'
}

# Change URL if ARM64 is detected
if ($architecture -eq "Arm64") {
    $packageArgs.url        = "https://github.com/Aptivi/Nitrocid/releases/download/$version/nitrocid-win-arm64-installer.exe"
    $packageArgs.url64bit   = "https://github.com/Aptivi/Nitrocid/releases/download/$version/nitrocid-win-arm64-installer.exe"
    $packageArgs.checksum   = "7C2C741226F970035F523B83CF06B4A7AA2BBBAA9DED4E7DE8B4EAE8DC0086D2"
    $packageArgs.checksum64 = "7C2C741226F970035F523B83CF06B4A7AA2BBBAA9DED4E7DE8B4EAE8DC0086D2"
}

Write-Output "<*> URL: $($packageArgs.url)"
Write-Output "<*> Expected SHA256 Sum: $($packageArgs.checksum)"

Write-Output "<+> Starting installation..."
Install-ChocolateyPackage @packageArgs
Write-Output "<+> Installation complete!"
