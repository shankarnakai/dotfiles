# FUNCTIONS

# Source standalone function files
_fn_dir="$HOME/.dotfiles/roles/zsh/functions"
for _fn in "$_fn_dir"/[^_]*; do
  [ -f "$_fn" ] && source "$_fn"
done
unset _fn _fn_dir

# universal_open is used to open files in mac or linux
# it is used on the git alias to open the repository in your default browser
universal_open() {
  if [ "$(uname -s)" = "Darwin" ]; then
    command open "$@"
  else
    command xdg-open "$@"
  fi
}

# docker_purge will clean up all the container, and image
docker_purge() {
  echo "This will stop all containers, remove all containers, and remove all images. Continue? [y/N] "
  read -r ans
  [[ $ans != [yY] ]] && return 0
  docker ps -a -q | xargs -r docker stop
  docker ps -a -q | xargs -r docker rm
  docker images -a -q | xargs -r docker rmi
}


# forever will continually run a command forever
# you can set an interval in seconds between executions
#   N - number representing interval in seconds
#   COMMAND - any shell command
# Example:
#   forever 1 echo "Hello World"
forever() {
  if [[ -z "$1" ]] || ! [[ "$1" =~ ^[0-9]+$ ]]; then
    echo "Usage: forever <seconds> <command...>" >&2; return 1
  fi
  local n=$1
  shift
  while true; do
    "$@"
    sleep "$n"
    clear
  done
}

# replace will replace a string in all the files that match with the pattern passed as argument
#  ext - string represent file extension
#  find - string to be found
#  newStr - string to be used
#  dry - boolean Dry run, without replacing string in the files
# Example:
#  replace "*.go" "some string" "new string" # it will replace string in all the files in the current directory
#  replace "*.go" "some string" "new string" true # the same but it will not really replace, just dry run
function replace() {
  local ext="$1"
  local find="$2"
  local newStr="$3"
  local dry="$4"

  local files

  if [[ "$dry" == "true" ]]; then
    files=$(find ./ \( -type d -name "node_modules" \) -prune -o -type f -iname "$ext" -exec grep -n "$find" {} \+;)
  else
    files=$(find ./ \( -type d -name "node_modules" \) -prune -o -type f -iname "$ext" -exec grep -l "$find" {} \+;)
  fi

  if [[ -z "$files" ]]; then
    echo "No results found"
    return 0
  fi

  if [[ "$dry" == "true" ]]; then
    echo "$files"
    return 0
  fi

  local escaped_find escaped_new
  escaped_find="$(printf '%s\n' "$find" | sed 's|[/\\&]|\\&|g')"
  escaped_new="$(printf '%s\n' "$newStr" | sed 's|[/\\&]|\\&|g')"
  local pattern="s/$escaped_find/$escaped_new/g"
  while IFS= read -r file; do
    sed -i '' -e "$pattern" "$file"
  done <<< "$files"
}

# kill-port will kill all the processes running on the specified ports
# Example:
#  kill-port 8080 3000
kill-port() {
  if [[ $# -eq 0 ]]; then
    echo "Usage: kill-port <port1> [port2 ...]" >&2
    return 1
  fi

  for port in "$@"; do
    # Get PIDs for the port (TCP/UDP, IPv4/IPv6)
    # -t: terse output (only PIDs)
    # -i: internet files on specified port
    local pids=$(lsof -t -i :"$port" 2>/dev/null)

    if [[ -n "$pids" ]]; then
      echo "\nProcesses on port $port:"
      lsof -i :"$port"
      
      # Try graceful kill first (SIGTERM)
      echo "$pids" | xargs kill 2>/dev/null
      
      # Wait a moment and check if they are gone
      sleep 0.5
      if lsof -t -i :"$port" >/dev/null 2>&1; then
        echo "Some processes still alive on port $port. Forcing (SIGKILL)..."
        echo "$pids" | xargs kill -9 2>/dev/null
      else
        echo "Successfully killed processes on port $port."
      fi
    else
      echo "No processes found on port $port."
    fi
  done
}

# bkp_git_changes copies new/modified files from git status to /tmp/backup
# used when unsure if `git rebase` will be ok or when slicing a PR
bkp_git_changes() {
  pbpaste | sed 's/new file/new-file/' | awk '{ print $2 }' | awk -F'/' '{$NF=""; print "/tmp/backup/"$0 }' | sed 's/ /\//g' | xargs mkdir -p --
  pbpaste | sed 's/new file/new-file/' | awk '{ print $2 }' | awk -F'/' '{print $0 }' | sed 's/ /\//g' | xargs -I '{}' cp '{}' '/tmp/backup/{}'
}

gi() {
  curl -sLw "\n" "https://www.toptal.com/developers/gitignore/api/$*"
}

# cover runs go test with coverage and opens the result in a browser
cover() {
  local t="/tmp/go-cover.$$.tmp"
  go test -coverprofile="$t" "$@" && go tool cover -html="$t"
  rm -f "$t"
}

## ARCHIVED
# This area will hold the functions that I don't think it is useful, but they are nice tricks
# These will be move to a code snipt repository that I can store and search for when I can use it for inspiration or utility


# extract_emails 
extract_emails() {
  if [ -f "$1" ]; then
    grep -o '[[:alnum:]_.+-]*@[[:alnum:]_.+-]*' "$1" | sort | uniq -i
  else
    echo "Expected a file at $1, but it doesn't exist." >&2
    return 1
  fi
}

