Set-PSReadLineOption -EditMode Emacs
# ==================================
# 模块导入
# ==================================

# PSCompletions
if (-not (Get-Module -ListAvailable PSCompletions)) {
  Write-Host "Installing PSCompletions..."
  Install-Module PSCompletions -Scope CurrentUser
  Import-Module PSCompletions
  psc add git scoop 7z cargo docker node npm powershell python pwsh pnpm pip
} else {
  import-Module PSCompletions
}

# ==================================
# 环境变量
# ==================================

$NVIM = "$env:USERPROFILE\AppData\Local\nvim"
$env:Editor = 'nvim'

# ==================================
# 核心函数与别名
# ==================================

function config {
  if ($args.Count -eq 0) {
    config add -u
    config commit
  } else {
    git --git-dir=$HOME/.cfg/ --work-tree=$HOME $args
  }
}

function lzdot {
    lazygit --git-dir="$HOME\.cfg" --work-tree="$HOME"
}

function y {
    $tmp = (New-TemporaryFile).FullName
    yazi $args --cwd-file="$tmp"
    $cwd = Get-Content -Path $tmp -Encoding UTF8
    if (-not [String]::IsNullOrEmpty($cwd) -and $cwd -ne $PWD.Path) {
        Set-Location -LiteralPath (Resolve-Path -LiteralPath $cwd).Path
    }
    Remove-Item -Path $tmp
}

Set-Alias -Name dot -Value config

function leet { nvim leetcode }
Set-Alias vi nvim


# ==================================
# 命令行交互设置
# ==================================

function prompt { Write-Host("PS: $pwd>")}
# use <C-A-S-/> or Get-PSReadLineKeyHandler show all key bindings
Write-Host -NoNewline "`e[5 q"
function OnViModeChange {
    if ($args[0] -eq 'Command') {
        # Set the cursor to a blinking block.
        Write-Host -NoNewline "`e[1 q"
    } else {
        # Set the cursor to a blinking line.
        Write-Host -NoNewline "`e[5 q"
    }
}
Set-PSReadLineOption -ViModeIndicator Script -ViModeChangeHandler $Function:OnViModeChange

Set-PSReadLineOption -PredictionSource HistoryAndPlugin

# 添加插入模式快捷键，和 Neovim 体验统一
# Set-PSReadLineKeyHandler -Chord "Ctrl+h" -Function BackwardDeleteChar -ViMode Insert
# Set-PSReadLineKeyHandler -Chord "Ctrl+w" -Function BackwardDeleteWord -ViMode Insert
Set-PSReadLineKeyHandler -Key "Shift+Enter" -Function AddLine

# ==================================
# 自定义通用函数
# ==================================

function .. { cd .. }
function traceroute { Test-Connection -ComputerName $args[0] -Traceroute }
function wget { aria2c -c -R --retry-wait=5 -x16 -s16 -j16 -k1M $args }


# ==================================
# 兼容性别名
# ==================================

# Customized alias https://www.xrgzs.top/posts/scoop-dev-setup
Set-Alias -Name ping -Value Test-Connection
Set-Alias -Name nslookup -Value Resolve-DnsName
Set-Alias -Name ifconfig -Value Get-NetIPConfiguration
Set-Alias -Name netstat -Value Get-NetTCPConnection
Set-Alias -Name zip -Value Compress-Archive
Set-Alias -Name unzip -Value Expand-Archive
Set-Alias -Name which -Value Get-Command

# 初始化 zoxide
Invoke-Expression (& { (zoxide init powershell | Out-String) })
