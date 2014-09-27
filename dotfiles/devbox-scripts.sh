#!/bin/sh

DOCKERSOCK=/var/run/docker.sock
DOCKERPATH=$(which docker)
SSHAUTHSOCKDIR=$(dirname $SSH_AUTH_SOCK)

devbox() {
  docker run -it --rm \
    -v $DOCKERSOCK:$DOCKERSOCK -v $DOCKERPATH:$DOCKERPATH \
    -v $SSHAUTHSOCKDIR:$SSHAUTHSOCKDIR -e SSH_AUTH_SOCK=$SSH_AUTH_SOCK \
    --volumes-from dotfiles --volumes-from data -P -w /home/devuser/data $@
}

nodebox() {
  devbox --name nodebox $@ bobpace/nodebox
}

scalabox() {
  devbox --volumes-from sbtcache --name scalabox $@ bobpace/scalabox
}

samba() {
  docker run --rm \
    -v $DOCKERSOCK:/docker.sock -v $DOCKERPATH:/docker \
    svendowideit/samba $@
}

runactivator() {
  if [ -f ~/bin/activator ];
  then
    activator ui -Dhttp.address=0.0.0.0
  fi
}

rmiuntagged() {
  docker rmi $(docker images -q --filter "dangling=true")
}

rmlast() {
  docker rm $(docker ps -lq)
}
