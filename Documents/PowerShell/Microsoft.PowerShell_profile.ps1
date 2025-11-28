# ==================================
# 模块导入
# ==================================

# PSCompletions
if (-not (Get-Module -ListAvailable PSCompletions)) {
  Write-Host "Installing PSCompletions..."
  Install-Module PSCompletions -Scope CurrentUser
  Import-Module PSCompletions
} else {
  Import-Module PSCompletions
}

# Completion Predictor
if (-not (Get-Module -ListAvailable CompletionPredictor)) {
  Write-Host "Installing CompletionPredictor..."
  Install-Module PSCompletions -Scope CurrentUser
  Import-Module CompletionPredictor
} else {
  Import-Module CompletionPredictor
}

# ==================================
# 环境变量
# ==================================

$NVIM = "$env:USERPROFILE\AppData\Local\nvim"


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

Set-Alias -Name dot -Value config

function leet { nvim leetcode }
Set-Alias vi nvim


# ==================================
# 命令行交互设置
# ==================================

function prompt { Write-Host("PS: $pwd>")}
# use <C-A-S-/> or Get-PSReadLineKeyHandler show all key bindings, it't useful
Set-PSReadLineOption -EditMode vi
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


# ==================================
# 自定义通用函数
# ==================================

function New-Symlink {
    param (
        [string] $Reference,
        [string] $Origin,
        [switch] $ExpandSourcePath
    )
    if ($ExpandSourcePath) {
        $wd = Get-Location
        $Source = "$wd\$Source"
    }

    New-Item -ItemType SymbolicLink -Value $Origin -Path $Reference
}
Set-Alias ln New-Symlink

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
