#************************************************
# ZSH
#************************************************
export PATH="$PATH:$ZSH/bin"
export PATH="$PATH:$HOME/.dotfiles/bin"


#************************************************
# GO
#************************************************
export PATH="$PATH:/usr/local/go/bin"
export PATH="$PATH:$HOME/go/bin"

#************************************************
# PROJECTS
#************************************************
export PROJECTS="$HOME/projects"
export pj="$PROJECTS"

#************************************************
# JAVA
#************************************************
export PATH="$HOME/Library/Java/JavaVirtualMachines/openjdk-21.0.1/Contents/Home:$PATH"
if command -v brew &>/dev/null; then
  _tomcat_prefix="$(brew --prefix tomcat@9 2>/dev/null)"
  [ -d "$_tomcat_prefix/bin" ] && export PATH="$_tomcat_prefix/bin:$PATH"
  unset _tomcat_prefix
fi

#************************************************
# POSTGRESQL
#************************************************
if command -v brew &>/dev/null; then
  _pg_prefix="$(brew --prefix postgresql@16 2>/dev/null)"
  [ -d "$_pg_prefix/bin" ] && export PATH="$_pg_prefix/bin:$PATH"
  unset _pg_prefix
fi

#************************************************
# MISC
#************************************************
export PATH="$HOME/.bin:$PATH"
[ -d "$HOME/.bin/apache-maven" ] && export PATH="$HOME/.bin/apache-maven/bin:$PATH"
