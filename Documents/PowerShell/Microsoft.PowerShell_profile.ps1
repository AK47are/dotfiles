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
