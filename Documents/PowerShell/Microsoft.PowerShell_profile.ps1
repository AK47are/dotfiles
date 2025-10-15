Set-Alias vi nvim

function prompt {
      Write-Host("PS: $pwd>")
}

function config {
    git --git-dir=$HOME/.cfg/ --work-tree=$HOME @args
}

Set-PSReadLineOption -EditMode Emacs

# PSCompletions: use `psc add *` to init
Import-Module PSCompletions

# Completion Predictor
Import-Module CompletionPredictor
Set-PSReadLineOption -PredictionSource HistoryAndPlugin

# Customized alias https://www.xrgzs.top/posts/scoop-dev-setup
Set-Alias -Name ping -Value Test-Connection
Set-Alias -Name nslookup -Value Resolve-DnsName
Set-Alias -Name ifconfig -Value Get-NetIPConfiguration
Set-Alias -Name netstat -Value Get-NetTCPConnection
Set-Alias -Name zip -Value Compress-Archive
Set-Alias -Name unzip -Value Expand-Archive
Set-Alias -Name which -Value Get-Command

function .. { cd .. }
function traceroute { Test-Connection -ComputerName $args[0] -Traceroute }
function wget { aria2c -c -R --retry-wait=5 -x16 -s16 -j16 -k1M $args }
