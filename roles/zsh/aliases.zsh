# SEARCH
alias pg='ps -ef | grep'

# KUBERNETES
alias k="kubectl"

# GO
alias packages='$(go list ./... | grep -v /vendor/)'

# EDITOR
alias vim="nvim"
alias vi="nvim"

# DOCKER SERVICE
alias dralli='docker rmi $(docker images -a -q)'
alias drallc='docker rm $(docker ps -a -q)'
alias dstopall='docker stop $(docker ps -a -q)'

# UTILS
alias damnit='sudo $(fc -nl -1)'
alias reload!='. ~/.zshrc'
alias pkill!="pkill -9 -f "
alias lj='jobs'
alias timezsh="time zsh -i -c echo"


# GIT
alias url_repo="git remote get-url origin | sed 's/.*@\([^:/]*\)[:/]\(.*\)\.git/https:\/\/\1\/\2/'"
alias open_repo='if [ $(uname -s) = "Darwin" ]; then browser="open"; else browser="xdg-open"; fi; $browser $(url_repo)' 