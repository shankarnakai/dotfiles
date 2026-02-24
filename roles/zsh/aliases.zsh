# SEARCH
alias pg="ps -ef | grep"

## KUBERNETES
alias k="kubectl"

## EDITOR
alias vim="nvim"
alias vi="nvim"

## GIT
alias url_repo="git remote get-url origin | sed 's/.*@\([^:/]*\)[:/]\(.*\)\.git/https:\/\/\1\/\2/'"
alias clean_git_branches='git branch --merged | grep -v "^\*\\|main" | xargs -n 1 git branch -d'

## UTILS
alias damnit='sudo "$(fc -nl -1)"'
alias reload!='. ~/.zshrc'
alias pkill!="pkill -9 -f "
alias lj='jobs'
alias timezsh="time zsh -i -c echo"

## CURL
alias curltime="curl -w \"@\$HOME/.curl-format.txt\" -o /dev/null -s "
