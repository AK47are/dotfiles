# This script is for automatically setting up dotfiles

function Write-Success { param($msg) Write-Host "[Dotfiles] $msg" -ForegroundColor Green }
function Write-Info { param($msg) Write-Host "[Dotfiles] $msg" -ForegroundColor Cyan }
function Write-Warning { param($msg) Write-Host "[Dotfiles] $msg" -ForegroundColor Yellow }
function Write-Error { param($msg) Write-Host "[Dotfiles] $msg" -ForegroundColor Red }

Write-Info "=== Auto Setup ==="

Write-Info "Checking and installing scoop..."
if (-not ([bool](Get-Command scoop -ErrorAction SilentlyContinue))) {
  try {
    $response = Read-Host "Install Chinese version of scoop? [Y/N]"
    if ($response -eq "Y" -or $response -eq "y") {
      Write-Info "Installing Chinese version of scoop..."
      irm c.xrgzs.top/c/scoop | iex
    } else {
      Write-Info "Installing official scoop..."
      irm https://get.scoop.sh | iex
    }
    Write-Success "Scoop installed successfully"
  } catch {
    Write-Error "Scoop installation failed: $($_.Exception.Message)"
    exit 1
  }
} else {
  Write-Warning "Scoop already installed, skipping"
}

Write-Info "Checking and installing git"
if (-not ([bool](Get-Command git -ErrorAction SilentlyContinue))) {
  try {
    scoop install git
    Write-Success "Git installed successfully"
  } catch {
    Write-Error "Git installation failed: $($_.Exception.Message)"
    exit 1
  }
} else {
  Write-Warning "Git already installed, skipping"
}

$proxyURL = ""
$proxyResponse = Read-Host "Set up Github proxy? [Y/N]"
if ($proxyResponse -eq "Y" -or $proxyResponse -eq "y") {
  $proxyURL = Read-Host "Enter proxy URL"

  if (-not [string]::IsNullOrWhiteSpace($proxyURL)) {
    $proxyURL = if (-not $proxyURL.StartsWith("https")) { "https://" + $proxyURL } else { $proxyURL }
    $proxyURL = if (-not $proxyURL.EndsWith("/")) { $proxyURL + "/" } else { $proxyURL }
  }
}

function Get-ProxiedURL {
  param([string]$OriginalURL)
  if ($proxyURL) {
    return $proxyURL + $OriginalURL
  } else {
    return $OriginalURL
  }
}

if (-not (Test-Path "$HOME\.cfg")) {
  try {
    Write-Info "Pulling dotfiles..."
    git clone --bare (Get-ProxiedURL "https://github.com/AK47are/dotfiles.git") $HOME\.cfg
    git --git-dir=$HOME\.cfg\ --work-tree=$HOME checkout -f
    git --git-dir=$HOME\.cfg\ --work-tree=$HOME config --local status.showUntrackedFiles no
    Write-Success "Dotfiles pulled successfully"
  } catch {
    Write-Error "Failed to pull dotfiles: $($_.Exception.Message)"
    exit 1
  }
} else {
  Write-Warning ".cfg already exists, skipping dotfiles pull"
}

Write-Info "Setting up Rime input method configuration..."
if (-not Test-Path "$env:APPDATA\Rime\.git") {
  try {
    Write-Info "Pulling rime-ice configuration..."
    git clone (Get-ProxiedURL "https://github.com/iDvel/rime-ice.git") $env:APPDATA\Rime --depth 1
    Write-Success "rime-ice configuration pulled successfully"
  } catch {
    Write-Error "Failed to pull Rime configuration: $($_.Exception.Message)"
    exit 1
  }
} else {
  Write-Warning "rime-ice configuration(.git) already exists, skipping"
}

if (-not (Test-Path "$env:APPDATA\Rime\wanxiang-lts-zh-hans.gram")) {
  try {
    Write-Info "Downloading Wanxiang language model..."
    Invoke-WebRequest -Uri (Get-ProxiedURL "https://github.com/amzxyz/RIME-LMDG/releases/download/LTS/wanxiang-lts-zh-hans.gram") -OutFile "$env:APPDATA\Rime\wanxiang-lts-zh-hans.gram"
    Write-Success "Wanxiang language model downloaded successfully"
  } catch {
    Write-Error "Failed to download Wanxiang language model: $($_.Exception.Message)"
    exit 1
  }
} else {
  Write-Warning "Wanxiang language model already exists, skipping"
}

Write-Info "Installing Rime Weasel..."
try {
  scoop bucket add extras-cn https://github.com/Scoopforge/Extras-CN
  scoop install weasel
  Write-Success "Rime Weasel installed/verified successfully"
} catch {
  Write-Error "Rime Weasel installation failed: $($_.Exception.Message)"
  exit 1
}

Write-Info "Installing Autohotkey"
try {
  scoop install autohotkey
  Write-Success "Autohotkey installed/verified successfully"
} catch {
  Write-Error "Autohotkey installation failed: $($_.Exception.Message)"
  exit 1
}

Write-Info "Running Autohotkey setup script..."
autohotkey "$HOME\scripts\setup.ahk"
Write-Success "Autohotkey setup completed"

Write-Info "Installing other programs"
scoop install pwsh wezterm-nightly neovim fd ripgrep lazygit tree-sitter nodejs mingw

Write-Success "=== All components installed successfully! ==="
