#!/usr/bin/env bash

sudo apt install zsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
chsh -s $(which zsh)

if [ -f $HOME/.homerc ]; then
cat <<- EOF >> $HOME/.zshrc
if [ -f $HOME/.homerc ]; then
        source $HOME/.homerc
fi
EOF
fi
