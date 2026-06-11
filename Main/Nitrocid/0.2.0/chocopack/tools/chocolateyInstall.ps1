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
    "x64"   { "7928D7B0AA043B3CF965DD796410F3F48B7660837D205101AB54D91A73364094" }
    "arm64" { "4D9DC68B47CEA85D8AF523CAE1186BA257BB43B8E35C18761350F37EB65D504C" }
}
Write-Output "<*> URL: $url"
Write-Output "<*> Expected SHA256 Sum: $shacheck"

$packageArgs = @{
  packageName   = $packageName
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
