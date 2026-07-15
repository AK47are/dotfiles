# Resolve the paths of wezterm executables.
$wezterm = (Get-Command wezterm.exe -ErrorAction SilentlyContinue).Source
$weztermGui = (Get-Command wezterm-gui.exe -ErrorAction SilentlyContinue).Source

if (-not $wezterm) {
    Write-Error "wezterm.exe was not found in PATH. Installation aborted."
    exit 1
}

if (-not $weztermGui) {
    Write-Error "wezterm-gui.exe was not found in PATH. Installation aborted."
    exit 1
}

# Locate the Neovim icon that will be shown in the context menu.
$nvim = (Get-Command nvim.exe -ErrorAction SilentlyContinue).Source
if (-not $nvim) {
    Write-Error "nvim.exe was not found in PATH. Installation aborted."
    exit 1
}

$nvimRuntimeLine = & $nvim --headless -u NONE -c 'lua io.stdout:write(vim.env.VIMRUNTIME)' -c 'q' 2>&1 | Select-Object -First 1
$nvimRuntime = if ($nvimRuntimeLine) { $nvimRuntimeLine.Trim() } else { $null }
$nvimIcon = Join-Path $nvimRuntime "neovim.ico"
if (-not (Test-Path $nvimIcon)) {
    Write-Warning "Could not find neovim.ico under the Neovim runtime directory; falling back to the nvim executable icon."
    $nvimIcon = $nvim
}

# Ensure the installation directory exists.
$installDir = Join-Path $env:USERPROFILE "scripts\open-with-neovim"
if (-not (Test-Path $installDir)) {
    New-Item -ItemType Directory -Path $installDir -Force | Out-Null
}

# Place the dispatcher script in the installation directory.
$dispatchSource = Join-Path $PSScriptRoot "open-with-neovim.ps1"
if (-not (Test-Path $dispatchSource)) {
    Write-Error "open-with-neovim.ps1 was not found in $PSScriptRoot. Installation aborted."
    exit 1
}

$dispatchDest = Join-Path $installDir "open-with-neovim.ps1"
if ((Resolve-Path $dispatchSource).Path -ne $dispatchDest) {
    Copy-Item -Path $dispatchSource -Destination $dispatchDest -Force
}

function Register-NeovimVerb {
    param(
        [string]$RootPath,
        [string]$ArgumentTemplate,
        [string]$MultiSelectModel = $null
    )

    $appKey = [Microsoft.Win32.Registry]::CurrentUser.CreateSubKey("$RootPath\OpenWithNeovim")
    $appKey.SetValue("MUIVerb", "Open with Neovim")
    $appKey.SetValue("Icon", $nvimIcon)
    if ($MultiSelectModel) {
        $appKey.SetValue("MultiSelectModel", $MultiSelectModel)
    }

    $commandValue = "powershell.exe -NoProfile -NoLogo -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$installDir\open-with-neovim.ps1`" $ArgumentTemplate"

    $cmdKey = $appKey.CreateSubKey("command")
    $cmdKey.SetValue("", $commandValue)

    $cmdKey.Close()
    $appKey.Close()
}

# Pass up to 9 selected items so multi-select works. Empty placeholders are
# filtered out by the dispatcher script.
$fileArgumentTemplate = '"%1" "%2" "%3" "%4" "%5" "%6" "%7" "%8" "%9"'

# File selection (supports multiple files).
Register-NeovimVerb -RootPath "Software\Classes\*\shell" `
    -ArgumentTemplate $fileArgumentTemplate `
    -MultiSelectModel "Document"

# Folder selection (supports multiple folders).
Register-NeovimVerb -RootPath "Software\Classes\Directory\shell" `
    -ArgumentTemplate $fileArgumentTemplate `
    -MultiSelectModel "Document"

# Folder background / empty space (single working directory only).
Register-NeovimVerb -RootPath "Software\Classes\Directory\Background\shell" `
    -ArgumentTemplate '"%V"' `
    -MultiSelectModel "Single"

# Notify Windows Explorer that file associations have changed so the new icon
# appears immediately without requiring a manual restart.
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class ShellNotify {
    [DllImport("shell32.dll")]
    public static extern void SHChangeNotify(int wEventId, uint uFlags, IntPtr dwItem1, IntPtr dwItem2);
}
"@
[ShellNotify]::SHChangeNotify(0x08000000, 0, [IntPtr]::Zero, [IntPtr]::Zero)

Write-Output "Open with Neovim context menu installed successfully."
