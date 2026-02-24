# SEARCH
pg() { ps -ef | grep -v grep | grep "$@"; }

## KUBERNETES
alias k="kubectl"

## GO
packages() { go list ./... | grep -v /vendor/; }

## EDITOR
alias vim="nvim"
alias vi="nvim"

## DOCKER SERVICE
docker_purge() {
  echo "This will stop all containers, remove all containers, and remove all images. Continue? [y/N] "
  read -r ans
  [[ $ans != [yY] ]] && return 0
  docker ps -a -q | xargs -r docker stop
  docker ps -a -q | xargs -r docker rm
  docker images -a -q | xargs -r docker rmi
}

## GIT
alias url_repo="git remote get-url origin | sed 's/.*@\([^:/]*\)[:/]\(.*\)\.git/https:\/\/\1\/\2/'"
alias clean_git_branches='git branch --merged | grep -v "^\*\\|main" | xargs -n 1 git branch -d'


## UTILS
alias damnit='sudo "$(fc -nl -1)"'
alias reload!='. ~/.zshrc'
alias pkill!="pkill -9 -f "
alias lj='jobs'
alias timezsh="time zsh -i -c echo"
open() { "$(universal_open)" "$@"; }

## CURL
alias curltime="curl -w \"@\$HOME/.curl-format.txt\" -o /dev/null -s "
