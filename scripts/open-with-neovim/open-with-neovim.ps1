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

# Use the project folder (where this script lives) as Neovim's working directory.
$workingDir = $PSScriptRoot

# Deterministic named pipe for the single shared Neovim instance. Using a named
# pipe avoids stale socket files and is scoped to the current user.
$serverAddr = "\\.\pipe\nvim-opener-$env:USERNAME"

function Test-NvimServer {
    param([string]$Server)
    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = $nvim
    $psi.Arguments = "--headless --server `"$Server`" --remote-expr `"1`""
    $psi.UseShellExecute = $false
    $psi.CreateNoWindow = $true
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError = $true
    $proc = [System.Diagnostics.Process]::Start($psi)
    if (-not $proc.WaitForExit(2000)) {
        $proc.Kill()
        return $false
    }
    return ($proc.ExitCode -eq 0)
}

function Send-NvimRemote {
    param([string]$Server, [string[]]$Paths)
    $argList = [System.Collections.Generic.List[string]]::new()
    $argList.Add("--server")
    $argList.Add("`"$Server`"")
    $argList.Add("--remote")
    foreach ($p in $Paths) {
        $argList.Add("`"$p`"")
    }
    Start-Process -FilePath $nvim -ArgumentList $argList.ToArray() -WindowStyle Hidden
}

# Serialize launcher processes so that only one of them creates the initial
# WezTerm/Neovim instance, and wait until it is ready so subsequent callers see
# the shared server.
$mutexName = "Local\nvim-opener-$env:USERNAME"
$mutex = New-Object System.Threading.Mutex($false, $mutexName)
$owned = $false
try {
    $owned = $mutex.WaitOne(15000)
} catch [System.Threading.AbandonedMutexException] {
    # Previous owner crashed; we now own it.
    $owned = $true
} catch {
    Write-Warning "Could not acquire the launcher mutex; proceeding without lock."
}

try {
    # If the shared instance is already listening, send the file(s) to it and
    # return immediately without touching WezTerm.
    if (Test-NvimServer -Server $serverAddr) {
        if ($paths.Count -gt 0) {
            Send-NvimRemote -Server $serverAddr -Paths $paths.ToArray()
        }
        return
    }

    $argumentList = [System.Collections.Generic.List[string]]::new()

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

    # Locate a running WezTerm GUI instance that we can spawn into.
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
        if ($workingDir) {
            $argumentList.Add("--cwd")
            $argumentList.Add("`"$workingDir`"")
        }
        $argumentList.Add("--pane-id")
        $argumentList.Add($targetPaneId)
    } else {
        # No GUI yet; start a fresh WezTerm window.
        $argumentList.Add("start")
        $argumentList.Add("--always-new-process")
    }
    $argumentList.Add("--")
    $argumentList.Add("`"$nvim`"")
    $argumentList.Add("--listen")
    $argumentList.Add("`"$serverAddr`"")
    if ($paths.Count -gt 0) {
        $argumentList.Add("--")
        foreach ($p in $paths) {
            $argumentList.Add("`"$p`"")
        }
    }

    Start-Process -FilePath $wezterm -ArgumentList $argumentList.ToArray() -WindowStyle Hidden -WorkingDirectory $workingDir

    # Wait for the shared instance to start listening so the next opener call
    # (which may arrive immediately) finds it rather than spawning another one.
    $ready = $false
    $deadline = [DateTime]::UtcNow.AddSeconds(10)
    while ([DateTime]::UtcNow -lt $deadline) {
        Start-Sleep -Milliseconds 300
        if (Test-NvimServer -Server $serverAddr) {
            $ready = $true
            break
        }
    }
    if (-not $ready) {
        Write-Warning "Shared Neovim instance did not become ready within 10 seconds."
    }
} finally {
    if ($owned) {
        $mutex.ReleaseMutex()
    }
}
