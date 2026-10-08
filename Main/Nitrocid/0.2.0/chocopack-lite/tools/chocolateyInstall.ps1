$ErrorActionPreference = 'Stop';
Write-Output "<*>: for assumptions, <+> for progress, <-> for error"

# Prepare the basic variables
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$pkgName    = "KS"
$version    = "v0.2.0.19"
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
  checksum      = "8B51150E245E204E84D2FDA8D4B122B328545314523630BCA9ED6ECD8C8D83D4"
  checksumType  = 'sha256'
  checksum64    = "8B51150E245E204E84D2FDA8D4B122B328545314523630BCA9ED6ECD8C8D83D4"
  checksumType64= 'sha256'
}

# Change URL if ARM64 is detected
if ($architecture -eq "Arm64") {
    $packageArgs.url        = "https://github.com/Aptivi/Nitrocid/releases/download/$version/nitrocid-win-arm64-installer.exe"
    $packageArgs.url64bit   = "https://github.com/Aptivi/Nitrocid/releases/download/$version/nitrocid-win-arm64-installer.exe"
    $packageArgs.checksum   = "061D166B20A40858259BDF6036268FBADC37CC03AC87FB790B93140FE61E295A"
    $packageArgs.checksum64 = "061D166B20A40858259BDF6036268FBADC37CC03AC87FB790B93140FE61E295A"
}

Write-Output "<*> URL: $($packageArgs.url)"
Write-Output "<*> Expected SHA256 Sum: $($packageArgs.checksum)"

Write-Output "<+> Starting installation..."
Install-ChocolateyPackage @packageArgs
Write-Output "<+> Installation complete!"
