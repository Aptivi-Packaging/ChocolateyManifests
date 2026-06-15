$ErrorActionPreference = 'Stop';
Write-Output "<*>: for assumptions, <+> for progress, <-> for error"

# Prepare the basic variables
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$pkgName    = "KS"
$version    = "v0.1.0.77"
Write-Output "<*> Installation directory: $toolsDir"
Write-Output "<*> Package Name: $pkgName ($version)"

# Check the system architecture
$architecture = [System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture
$arch         = switch ($architecture) {
    "X64"   { "x64" }
    "Arm64" { "arm64" }
    Default { "unknown" }
}
Write-Output "<*> Architecture: $arch [$architecture]"
if ($arch -eq "unknown") {
    Throw "<-> Nitrocid doesn't support $architecture"
}

# Determine the URL and the SHA256 sum
$url        = "https://github.com/Aptivi/Nitrocid/releases/download/$version/nitrocid-win-$arch-installer.exe"
$shacheck   = switch ($arch) {
    "x64"   { "714CE358B33010DF70CDAB7A4ED27BA367FD4A00B2C40D80EE2CCC60821FB963" }
    "arm64" { "9FB5235C6E9D40DEA9998374C9218ABBC67DD5E7FC64965A0FA8C576AEBAF790" }
}
Write-Output "<*> URL: $url"
Write-Output "<*> Expected SHA256 Sum: $shacheck"

$packageArgs = @{
  packageName   = $pkgName
  fileType      = 'exe'
  url           = $url
  silentArgs    = "/quiet /norestart"
  validExitCodes= @(0, 3010, 1641)
  softwareName  = 'Nitrocid*'
  checksum      = $shacheck
  checksumType  = 'sha256'
}

Write-Output "<+> Starting installation..."
Install-ChocolateyPackage @packageArgs
Write-Output "<+> Installation complete!"
