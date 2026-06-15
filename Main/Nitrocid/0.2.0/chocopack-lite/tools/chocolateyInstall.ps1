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
    "x64"   { "31187F35D6678407C121C6A8DB5EFCE2105CCCA436C1B7E53164F713D0B275FB" }
    "arm64" { "7C2C741226F970035F523B83CF06B4A7AA2BBBAA9DED4E7DE8B4EAE8DC0086D2" }
    Default { "E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855" }
}
Write-Output "<*> URL: $url"
Write-Output "<*> Expected SHA256 Sum: $shacheck"

$packageArgs = @{
  packageName   = $packageName
  fileType      = 'exe'
  url           = $url
  silentArgs    = "/quiet /norestart NitrocidLite=1"
  validExitCodes= @(0, 3010, 1641)
  softwareName  = 'Nitrocid*'
  checksum      = $shacheck
  checksumType  = 'sha256'
}

Write-Output "<+> Starting installation..."
Install-ChocolateyPackage @packageArgs
Write-Output "<+> Installation complete!"
