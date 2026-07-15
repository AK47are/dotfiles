param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [AllowEmptyCollection()]
    [string[]]$Files = @()
)

$wezterm = (Get-Command wezterm.exe -ErrorAction SilentlyContinue).Source
$nvim = (Get-Command nvim.exe -ErrorAction SilentlyContinue).Source

if (-not $wezterm) {
    throw "wezterm.exe was not found in PATH."
}
if (-not $nvim) {
    throw "nvim.exe was not found in PATH."
}

# Filter out empty placeholders that come from unused registry arguments like
# %2..%9, and convert each path to a full path before passing it on.
$paths = [System.Collections.Generic.List[string]]::new()
foreach ($f in $Files) {
    if (-not [string]::IsNullOrWhiteSpace($f)) {
        $paths.Add([System.IO.Path]::GetFullPath($f))
    }
}

# When launched from Explorer the WezTerm-specific env vars (especially
# WEZTERM_UNIX_SOCKET) are not set, so the CLI cannot find the running GUI.
# Reconstruct the socket path from an active wezterm-gui process id so that
# `wezterm cli` can connect to it.
$socketDir = Join-Path $env:USERPROFILE ".local\share\wezterm"
foreach ($proc in (Get-Process -Name wezterm-gui -ErrorAction SilentlyContinue)) {
    $candidate = Join-Path $socketDir "gui-sock-$($proc.Id)"
    if (Test-Path $candidate) {
        $env:WEZTERM_UNIX_SOCKET = $candidate
        break
    }
}

$argumentList = [System.Collections.Generic.List[string]]::new()

# Locate a running WezTerm GUI instance that we can spawn into.
# WEZTERM_UNIX_SOCKET is only set above when an active wezterm-gui process
# with a matching socket file was found. If it isn't set, skip the CLI probe
# entirely: wezterm cli would try stale sockets and hang for ~5s each.
$targetPaneId = $null
if ($env:WEZTERM_UNIX_SOCKET) {
    try {
        $paneList = & $wezterm cli list --format=json 2>&1 | ConvertFrom-Json
        if ($paneList -and $paneList.Count -gt 0) {
            # Prefer the active pane so the new tab lands in the active window.
            $activePane = $paneList | Where-Object { $_.is_active } | Select-Object -First 1
            $targetPaneId = if ($activePane) { $activePane.pane_id } else { $paneList[0].pane_id }
        }
    } catch {
        # The GUI is unreachable. Fall back to a new window below.
    }
}

if ($targetPaneId -ne $null) {
    # Reuse an existing WezTerm window by spawning a new tab into it.
    $argumentList.Add("cli")
    $argumentList.Add("spawn")
    $argumentList.Add("--pane-id")
    $argumentList.Add($targetPaneId)
} else {
    # No GUI yet; start a fresh WezTerm window.
    $argumentList.Add("start")
    $argumentList.Add("--always-new-process")
}
$argumentList.Add("--")
$argumentList.Add($nvim)
if ($paths.Count -gt 0) {
    $argumentList.Add("--")
    $argumentList.AddRange($paths)
}

# The WezTerm CLI process only needs to tell the running GUI what to do; run
# it hidden so no console window flashes and return immediately.
Start-Process -FilePath $wezterm -ArgumentList $argumentList.ToArray() -WindowStyle Hidden
