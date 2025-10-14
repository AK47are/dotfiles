Set-Alias vi nvim

function prompt {
      Write-Host("PS: $pwd>")
}

function config {
    git --git-dir=$HOME/.cfg/ --work-tree=$HOME @args
}

Set-PSReadLineOption -EditMode Emacs

Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -BellStyle None
