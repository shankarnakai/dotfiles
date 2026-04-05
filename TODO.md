
## Get Latest NVIM version 
It is require because the Lazyvim require the nvim >= v0.11.2
```bash
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt update
sudo apt install neovim
```



## We need to update the installaction script of Node
For some reason Ubuntu doesn't install teh latest node by default, we need to adde the node srouces to be able to get the latest version
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -


## More issues installing Node
https://stackoverflow.com/questions/55938030/error-eacces-permission-denied-mkdir-when-installing-sth-with-npm
https://docs.npmjs.com/resolving-eacces-permissions-errors-when-installing-packages-globally

There is also a similar problem with permissions when trying to install packages globally with --global or -g. I know it's not your current problem, but I want to add it here because people googling the EACCESS when doing a global install might reach this question as well.

Some people change the system folder privileges allowing non-root users writing in system folder, however here is what they recommend in the documentation:

https://docs.npmjs.com/resolving-eacces-permissions-errors-when-installing-packages-globally/

Back up your computer (including it here because documentation mentions is too, but it feels to me overly cautious)

Then execute:

mkdir ~/.npm-global
npm config set prefix '~/.npm-global'

Edit your ~/.profile:

export PATH=~/.npm-global/bin:$PATH

Then invoke it with

source ~/.profile

To test your new configuration, install a package globally without using sudo:

npm install -g jshint

Or instead of modifying ~/.profile just use the corresponding ENV variable (but to make it pernament you would have to modify the profile file anyway)

NPM_CONFIG_PREFIX=~/.npm-global


## Paths installation

Java and Postgree are being configured only for MAC OS, we need to be able to easy make it portable to Linux Ubuntu

## Alacrity
Alacrity configuration, the correct configuration is what is in the ~/.config/alacritty/alacritty.toml
