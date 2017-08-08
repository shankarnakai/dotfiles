#!/bin/bash

log() {
	echo "[gaesdk] $@"
}

has=$(dpkg -l | grep "google-cloud-sdk")

if [ -n "$has" ];
then
	log "gae sdk already installed, abort..."
else
  CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"
  echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list

	log "Downloading $CLOUD_SDK_REPO"
  curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
	log "installation done"

  sudo apt update && sudo apt install google-cloud-sdk google-cloud-sdk-app-engine-go
  gcloud init
fi

if ! grep -q -1 "go_appengine" $HOME/.customrc 
then
	log "configuring .customrc"
	echo 'export PATH="$PATH:$HOME/lib/go_appengine"' >> $HOME/.customrc
else
	log "skip .customrc configuration"
fi

exit 0
