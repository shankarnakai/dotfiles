#!/bin/bash

log() {
  echo "[go-tools] $@"
}

#Gocode
log "Downloding gocode"
go get -u -v github.com/nsf/gocode
log "Instaling gocode"
go install -v github.com/nsf/gocode


#Goimport
log "Downloding goimports"
go get -u -v golang.org/x/tools/
log "Instaling goimports"
go install -v golang.org/x/tools/cmd/goimports


#Godef
log "Downloading godef"
go get -u -v github.com/rogpeppe/godef
log "Instaling godef"
go install -v github.com/rogpeppe/godef


#Gotags
log "Downloading gotags"
go get -u -v github.com/jstemmer/gotags
log "Instaling gotags"
go install -v github.com/jstemmer/gotags

#Golint
log "Downloading lint"
go get -u -v github.com/golang/lint
log "Instaling lint"
go install -v github.com/golang/lint

#GoConvey
log "Downloading goconvey"
go get -u -v github.com/smartystreets/goconvey
log "Instaling goconvey"
go install -v github.com/smartystreets/goconvey

#GoTTy
log "Downloading gotty"
go get -u -v github.com/yudai/gotty
log "Instaling gotty"
go install github.com/yudai/gotty

#Whenchange
log "Downloading whenchange"
go get -u -v ronoaldo.gopkg.net/whenchange
log "Instaling whenchange"
go install -v ronoaldo.gopkg.net/whenchange

#Aeremote
log "Downloading aeremote"
go get -u -v ronoaldo.gopkg.net/aetools/aeremote
log "Instaling aeremote"
go install -v ronoaldo.gopkg.net/aetools/aeremote

#ytdl CLI
go get -u github.com/rylio/ytdl/...
