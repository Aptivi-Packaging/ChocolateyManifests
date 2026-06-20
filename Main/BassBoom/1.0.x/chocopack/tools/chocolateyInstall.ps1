$ErrorActionPreference = 'Stop';
Write-Output "<*>: for assumptions, <+> for progress, <-> for error"

# Prepare the basic variables
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$pkgName    = "bassboom"
$version    = "v1.0.1"
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
    Throw "<-> BassBoom doesn't support $architecture"
}

# Determine the URL and the SHA256 sum
$url        = "https://github.com/Aptivi/BassBoom/releases/download/$version/bassboom-win-$arch-installer.exe"
$shacheck   = switch ($arch) {
    "x64"   { "531B78C55C5335970C0B8474D70F3CA1812F437AE494D13323B7E434F6FA2B16" }
    "arm64" { "071C753F34D42A9891B2B4573937F05073B191293641A16664A0CB63677E5FE4" }
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
  softwareName  = 'BassBoom*'
  checksum      = $shacheck
  checksumType  = 'sha256'
}

Write-Output "<+> Starting installation..."
Install-ChocolateyPackage @packageArgs
Write-Output "<+> Installation complete!"
