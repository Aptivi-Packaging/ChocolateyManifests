$ErrorActionPreference = 'Stop';
Write-Output "<*>: for assumptions, <+> for progress, <-> for error"

# Prepare the basic variables
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$pkgName    = "KS"
$version    = "v0.1.0.79"
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
  checksum      = "B109E104A4E653347339E255EFAA88E2FDD2B66018F549FAA5BF77B992FE4EE8"
  checksumType  = 'sha256'
  checksum64    = "B109E104A4E653347339E255EFAA88E2FDD2B66018F549FAA5BF77B992FE4EE8"
  checksumType64= 'sha256'
}

# Change URL if ARM64 is detected
if ($architecture -eq "Arm64") {
    $packageArgs.url        = "https://github.com/Aptivi/Nitrocid/releases/download/$version/nitrocid-win-arm64-installer.exe"
    $packageArgs.url64bit   = "https://github.com/Aptivi/Nitrocid/releases/download/$version/nitrocid-win-arm64-installer.exe"
    $packageArgs.checksum   = "C61D7086336F896150B984A5F431B4A02DDBEFB975DDF2B8D21B4DB27B54AF73"
    $packageArgs.checksum64 = "C61D7086336F896150B984A5F431B4A02DDBEFB975DDF2B8D21B4DB27B54AF73"
}

Write-Output "<*> URL: $($packageArgs.url)"
Write-Output "<*> Expected SHA256 Sum: $($packageArgs.checksum)"

Write-Output "<+> Starting installation..."
Install-ChocolateyPackage @packageArgs
Write-Output "<+> Installation complete!"
