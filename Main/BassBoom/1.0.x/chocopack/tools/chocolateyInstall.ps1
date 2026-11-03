$ErrorActionPreference = 'Stop';
Write-Output "<*>: for assumptions, <+> for progress, <-> for error"

# Prepare the basic variables
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$pkgName    = "bassboom"
$version    = "v1.0.3.1"
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
  checksum      = "12491C1E25F0A6C2B2437ACBF020A3F737B19D480B2464537D3FC7E2E1BFB5A2"
  checksumType  = 'sha256'
  checksum64    = "12491C1E25F0A6C2B2437ACBF020A3F737B19D480B2464537D3FC7E2E1BFB5A2"
  checksumType64= 'sha256'
}

# Change URL if ARM64 is detected
if ($architecture -eq "Arm64") {
    $packageArgs.url        = "https://github.com/Aptivi/BassBoom/releases/download/$version/bassboom-win-arm64-installer.exe"
    $packageArgs.url64bit   = "https://github.com/Aptivi/BassBoom/releases/download/$version/bassboom-win-arm64-installer.exe"
    $packageArgs.checksum   = "C0BB1E8F87DC63EADF5E3C27951A1A18EBD1518C3FEC23817DE79A60129C6286"
    $packageArgs.checksum64 = "C0BB1E8F87DC63EADF5E3C27951A1A18EBD1518C3FEC23817DE79A60129C6286"
}

Write-Output "<*> URL: $($packageArgs.url)"
Write-Output "<*> Expected SHA256 Sum: $($packageArgs.checksum)"

Write-Output "<+> Starting installation..."
Install-ChocolateyPackage @packageArgs
Write-Output "<+> Installation complete!"
