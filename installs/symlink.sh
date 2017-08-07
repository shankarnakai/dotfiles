#!/bin/bash
array=( "A" "B" "ElementC" "ElementE" )
symlinks=("$HOME/dotfiles/editorconfig  >  $HOME/.editorconfig"\
  "$HOME/dotfiles/.homerc  >  $HOME/.homerc"\
  "$HOME/dotfiles/.vimrc  >  $HOME/.vimrc"\
  "$HOME/dotfiles/.vimrc.plugins  >  $HOME/.vimrc.plugins"\
  "$HOME/dotfiles/.tmux.conf  >  $HOME/.tmux.conf"\
)
i=0;
while [ $i != ${#symlinks[@]} ]
do
  echo "link: "${symlinks[$i]}"."
  let "x = x +1"
done 
#if [ ! -f ~/.editorconfig ]; then
#ln -s $HOME/dotfiles/editorconfig ~/.editorconfig
#fi


#if [ ! -f ~/.homerc ]; then
#ln -s $HOME/dotfiles/.homerc ~/.homerc
#fi

#if [ ! -f ~/.vimrc ]; then
#ln -s $HOME/dotfiles/.vimrc ~/.vimrc
#fi

#if [ ! -f ~/.vimrc.plugins ]; then
#ln -s $HOME/dotfiles/.vimrc.plugins ~/.vimrc.plugins
#fi

#if [ ! -f ~/.tmux.conf ]; then
#ln -s $HOME/dotfiles/.tmux.conf ~/.tmux.conf
#fi
