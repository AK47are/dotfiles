# Remove all OpenWithNeovim registry keys that the installer creates.
$locations = @(
    "Software\Classes\*\shell\OpenWithNeovim",
    "Software\Classes\Directory\shell\OpenWithNeovim",
    "Software\Classes\Directory\Background\shell\OpenWithNeovim"
)

foreach ($relPath in $locations) {
    $rootPath = $relPath -replace '\\OpenWithNeovim$', ''
    $regRoot = [Microsoft.Win32.Registry]::CurrentUser.OpenSubKey($rootPath, $true)
    if ($regRoot -and ($regRoot.GetSubKeyNames() -contains "OpenWithNeovim")) {
        $regRoot.DeleteSubKeyTree("OpenWithNeovim")
        $regRoot.Close()
    }
}

# Remove the installation directory, but NEVER delete the directory that
# contains this uninstall script (i.e. the project/checkout directory).
$installDir = Join-Path $env:USERPROFILE "scripts\open-with-neovim"
if (Test-Path $installDir) {
    $installDirResolved = (Resolve-Path $installDir).Path.TrimEnd('\')
    $scriptDirResolved = (Resolve-Path $PSScriptRoot).Path.TrimEnd('\')
    if ($installDirResolved -ne $scriptDirResolved) {
        Remove-Item -Path $installDir -Recurse -Force
    } else {
        Write-Warning "Skipping deletion of $installDir because it is the directory containing uninstall.ps1."
    }
}

Write-Output "Open with Neovim context menu uninstalled successfully."
