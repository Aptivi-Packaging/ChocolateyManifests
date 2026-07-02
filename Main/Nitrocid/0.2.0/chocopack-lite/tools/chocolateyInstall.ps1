$ErrorActionPreference = 'Stop';
Write-Output "<*>: for assumptions, <+> for progress, <-> for error"

# Prepare the basic variables
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$pkgName    = "KS"
$version    = "v0.2.0.10"
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
  checksum      = "7928D7B0AA043B3CF965DD796410F3F48B7660837D205101AB54D91A73364094"
  checksumType  = 'sha256'
  checksum64    = "7928D7B0AA043B3CF965DD796410F3F48B7660837D205101AB54D91A73364094"
  checksumType64= 'sha256'
}

# Change URL if ARM64 is detected
if ($architecture -eq "Arm64") {
    $packageArgs.url        = "https://github.com/Aptivi/Nitrocid/releases/download/$version/nitrocid-win-arm64-installer.exe"
    $packageArgs.url64bit   = "https://github.com/Aptivi/Nitrocid/releases/download/$version/nitrocid-win-arm64-installer.exe"
    $packageArgs.checksum   = "4D9DC68B47CEA85D8AF523CAE1186BA257BB43B8E35C18761350F37EB65D504C"
    $packageArgs.checksum64 = "4D9DC68B47CEA85D8AF523CAE1186BA257BB43B8E35C18761350F37EB65D504C"
}

Write-Output "<*> URL: $($packageArgs.url)"
Write-Output "<*> Expected SHA256 Sum: $($packageArgs.checksum)"

Write-Output "<+> Starting installation..."
Install-ChocolateyPackage @packageArgs
Write-Output "<+> Installation complete!"
