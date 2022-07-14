# FUNCTIONS


# getEmail 
getEmail() {
  if [ -f "$1" ]; then
    grep -o '[[:alnum:]+\.\_\-]*@[[:alnum:]+\.\_\-]*' "$1" | sort | uniq -i
  else
    echo "Expected a file at $1, but it doesn't exist." >&2
    exit 1
  fi
}

# forever will continually run a command forever 
# you can set a internal in seconds that the command can be execute
#   N - number representing internal in seconds
#   COMMAND - any shell command 
# Example:
#   forever 1 echo "Hello World"
forever() {
n=$1
shift
while true; do
   "$@"
   sleep $n
   clear
done
}

# replace will replace a string in all the files that match with the pattern passed as argument
#  ext - string represent file extension
#  find - string to be find
#  newStr - string to be used 
#  dry - boolean Dry run, without replace string in the files
# Example:
#  replace "*.go" "some string" "new string" # it will replace string in all the files in the current directory
#  replace "*.go" "some string" "new string" true # the same but it will not really replace, just dry run 
replace() {
ext=$1
find=$2
newStr=$3
dry=$4

files=

if [ "$dry" != "true" ]; then 
	files=$(find ./ \( -type d -name "node_modules" \) -prune -o -type f -iname "$ext" -exec grep -n "$find" {} \+;)
else
	files=$(find ./ \( -type d -name "node_modules" \) -prune -o -type f -iname "$ext" -exec grep -l "$find" {} \+;)
fi

if [ -z "$files" ]; then
  echo "No results found"
  return 0
fi


if [ "$dry" != "true" ]; then 
	echo "$files"
	return 0
fi

pattern="s/$find/$newStr/g"
while IFS= read -r file; do
  sed -i '' -e "$pattern"  $file 
  truncate -s -1 $file
  #sed -i '' -e '$d'  $file
done <<< $files
}

# kill-port will kill all the process running in the specified port
# Example:
#  kill-port 8080
kill-port() {
  lsof -n -i4TCP:$1 | grep LISTEN | awk '{ print $2 }' | xargs kill
}

# bkp_git_changes helpful comamnd that get all the new files and copy to the /tmp/backup 
# used when unsure if `git rebase` will be ok or when slicing a PR
bkp_git_changes() {
 #create folders
 pbpaste | sed 's/new file/new-file/' | awk '{ print $2 }' | awk -F'/' '{$NF=""; print "/tmp/backup/"$0 }' | sed 's/ /\//g' | xargs mkdir -p --
 pbpaste | sed 's/new file/new-file/' | awk '{ print $2 }' | awk -F'/' '{print $0 }' | sed 's/ /\//g' | xargs -I '{}' cp '{}' '/tmp/backup/{}'
}
