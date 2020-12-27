source ~/.vimrc.common

" Load plugins
if filereadable(expand("~/.vimrc.plugins"))
  source ~/.vimrc.plugins
endif

source ~/.vimrc.mapping
