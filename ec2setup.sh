#!/bin/bash
yum update -y
yum install -y git irssi emacs zsh tmux
sudo adduser adlr
mkdir -p /home/adlr/.ssh
wget -O /home/adlr/.ssh/authorized_keys 'https://drive.google.com/uc?export=download&id=0BxSD5KoZoFD4LUJSOVZkYWo2bVU'
chmod 0700 /home/adlr/.ssh
chmod 0600 /home/adlr/.ssh/authorized_keys
chown adlr /home/adlr/.ssh
