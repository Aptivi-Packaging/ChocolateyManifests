$ErrorActionPreference = 'Stop';
Write-Output "<*>: for assumptions, <+> for progress, <-> for error"

# Prepare the basic variables
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$pkgName    = "KS"
$version    = "v0.1.0.78"
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
    "x64"   { "F9D8A2C6545A6C236FEC805336C3BFBC1DF950CAE3EF066A31BD8F30F2D5C23E" }
    "arm64" { "0A3D035F9D5E248B68027531CFC5D4999B773A26388843F555A927A360C39A0F" }
    Default { "E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855" }
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
