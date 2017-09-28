su -c "echo 'deb http://ppa.launchpad.net/numix/ppa/ubuntu trusty main' > /etc/apt/sources.list.d/numix.list"
su -c "echo 'deb-src http://ppa.launchpad.net/numix/ppa/ubuntu trusty main' >> /etc/apt/sources.list.d/numix.list"
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 52B709720F164EEB
sudo apt-get update
sudo apt-get install numix-icon-theme-circle
