# This script is for automatically setting up dotfiles

function Write-Success { param($msg) Write-Host "[Dotfiles] $msg" -ForegroundColor Green }
function Write-Info { param($msg) Write-Host "[Dotfiles] $msg" -ForegroundColor Cyan }
function Write-Warning { param($msg) Write-Host "[Dotfiles] $msg" -ForegroundColor Yellow }
function Write-Error { param($msg) Write-Host "[Dotfiles] $msg" -ForegroundColor Red }

$ErrorActionPreference = "Stop"

Write-Info "=== Auto Setup ==="

Write-Info "Checking and installing scoop..."
if (-not ([bool](Get-Command scoop -ErrorAction SilentlyContinue))) {
  $response = Read-Host "Install Chinese version of scoop(Recommanded)? [Y/N]"
  if ($response -eq "Y" -or $response -eq "y") {
    Write-Info "Installing Chinese version of scoop..."
    irm c.xrgzs.top/c/scoop | iex
  } else {
    Write-Info "Installing official scoop..."
    irm https://get.scoop.sh | iex
    scoop bucket add extras
    scoop bucket add versions
    scoop bucket add extras-cn https://github.com/Scoopforge/Extras-CN
  }
  Write-Success "Scoop installed successfully"
} else {
  Write-Warning "Scoop already installed, skipping"
}

Write-Info "Checking and installing git"
if (-not ([bool](Get-Command git -ErrorAction SilentlyContinue))) {
  scoop install git
  Write-Success "Git installed successfully"
} else {
  Write-Warning "Git already installed, skipping"
}

$proxyURL = [Environment]::GetEnvironmentVariable("DOTFILES_PROXY_URL", "User")
if ($null -eq $proxyURL) {
    $proxyResponse = Read-Host "Set up Github proxy? [Y/N]"
    if ($proxyResponse -eq "Y" -or $proxyResponse -eq "y") {
        $proxyURL = Read-Host "Enter proxy URL"
        if (-not [string]::IsNullOrWhiteSpace($proxyURL)) {
            $proxyURL = if (-not $proxyURL.StartsWith("https")) { "https://" + $proxyURL } else { $proxyURL }
            $proxyURL = if (-not $proxyURL.EndsWith("/")) { $proxyURL + "/" } else { $proxyURL }
        }
    } else {
        $proxyURL = ""
    }
    [Environment]::SetEnvironmentVariable("DOTFILES_PROXY_URL", $proxyURL, "User")
} elseif ($proxyURL -eq "") {
    Write-Info "Proxy not configured (saved preference)"
} else {
    Write-Info "Using saved proxy: $proxyURL"
}

function Get-ProxiedURL {
  param([string]$OriginalURL)
  if ($proxyURL) {
    return $proxyURL + $OriginalURL
  } else {
    return $OriginalURL
  }
}

Write-Info "Setting up Rime input method configuration..."
if (-not (Test-Path "$env:APPDATA\Rime\.git")) {
    Write-Info "Pulling rime-ice configuration..."
    $repo = "https://github.com/iDvel/rime-ice.git"
    $dest = "$env:APPDATA\Rime"
    try {
        if (Test-Path $dest) {
            git -C $dest init 2>$null
            git -C $dest remote add origin (Get-ProxiedURL $repo) 2>$null
            git -C $dest fetch origin --depth 1
            git -C $dest reset --hard origin/master
        } else {
            git clone (Get-ProxiedURL $repo) $dest --depth 1
        }
        Write-Success "rime-ice configuration pulled successfully"
    } catch {
        Write-Warning "Failed to pull rime-ice: $($_.Exception.Message)"
    }
} else {
    Write-Warning "rime-ice configuration(.git) already exists, skipping"
}

if (-not (Test-Path "$env:APPDATA\Rime\wanxiang-lts-zh-hans.gram")) {
  Write-Info "Downloading Wanxiang language model..."
  Invoke-WebRequest -Uri (Get-ProxiedURL "https://github.com/amzxyz/RIME-LMDG/releases/download/LTS/wanxiang-lts-zh-hans.gram") -OutFile "$env:APPDATA\Rime\wanxiang-lts-zh-hans.gram"
  Write-Success "Wanxiang language model downloaded successfully"
} else {
  Write-Warning "Wanxiang language model already exists, skipping"
}

if (-not (Test-Path "$HOME\.cfg")) {
    Write-Info "Pulling dotfiles..."
    git clone --bare (Get-ProxiedURL "https://github.com/AK47are/dotfiles.git") $HOME\.cfg
    $checkoutResponse = Read-Host "Overwrite home directory files with dotfiles? [Y/N]"
    if ($checkoutResponse -eq "Y" -or $checkoutResponse -eq "y") {
        git --git-dir=$HOME\.cfg\ --work-tree=$HOME checkout -f
        Write-Success "Dotfiles files checked out"
    } else {
        Write-Warning "Skipped checkout, dotfiles bare repo is at $HOME\.cfg"
    }
    git --git-dir=$HOME\.cfg\ --work-tree=$HOME config --local status.showUntrackedFiles no
    New-Item -ItemType File -Path "$HOME\.cfg\.dotfiles-applied" -Force | Out-Null
    Write-Success "Dotfiles pulled successfully"
} elseif (-not (Test-Path "$HOME\.cfg\.dotfiles-applied")) {
    Write-Info "Dotfiles repo exists, creating sentinel..."
    git --git-dir=$HOME\.cfg\ --work-tree=$HOME config --local status.showUntrackedFiles no
    New-Item -ItemType File -Path "$HOME\.cfg\.dotfiles-applied" -Force | Out-Null
    Write-Success "Dotfiles sentinel created"
} else {
    Write-Warning ".cfg already exists and applied, skipping dotfiles pull"
}

Write-Info "Installing Rime Weasel..."
$weaselInstalled = (scoop list weasel 2>$null) -match "weasel"
if (-not $weaselInstalled) {
  scoop install weasel
  Write-Success "Rime Weasel installed successfully"
} else {
  Write-Warning "weasel already installed, skipping"
}

Write-Info "Installing Autohotkey"
$ahkInstalled = (scoop list autohotkey 2>$null) -match "autohotkey"
if (-not $ahkInstalled) {
  scoop install autohotkey
  Write-Success "Autohotkey installed successfully"
} else {
  Write-Warning "autohotkey already installed, skipping"
}

Write-Info "Running Autohotkey setup script..."
autohotkey "$HOME\scripts\setup.ahk"
Write-Success "Autohotkey setup completed"

Write-Info "Installing other programs"
$packages = @("pwsh", "wezterm-nightly", "neovim", "fd", "ripgrep", "lazygit",
    "tree-sitter", "nodejs-lts", "mingw", "clash-verge-rev", "yazi", "zoxide", "jq",
    "resvg", "gh", "delta")
foreach ($pkg in $packages) {
    $installed = (scoop list $pkg 2>$null) -match $pkg
    if (-not $installed) {
        scoop install $pkg
        Write-Success "$pkg installed successfully"
    } else {
        Write-Warning "$pkg already installed, skipping"
    }
}

# 配置 yazi
$currentYazi = [Environment]::GetEnvironmentVariable("YAZI_FILE_ONE", "User")
if (-not $currentYazi) {
    [Environment]::SetEnvironmentVariable("YAZI_FILE_ONE",
        (scoop prefix git) + "\usr\bin\file.exe", "User")
    Write-Success "YAZI_FILE_ONE set"
} else {
    Write-Warning "YAZI_FILE_ONE already set to $currentYazi, skipping"
}

Write-Info "Note: Neovim, Wezterm initialization requires VPN connection"
