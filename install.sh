#!/bin/bash

FILES="emacs gitconfig zshrc emacs.d tmux.conf irssi"
DOTFILES_DIR=$(cd $(dirname "$0") && pwd)

#read -p "adlr's Freenode password:" freenodepass

#echo "Freenode	adlr	$freenodepass	PLAIN" > ~/dotfiles/irssi/sasl.auth

echo updating dot file symlinks

for i in $FILES
do
  if [ -e ~/.$i ]
  then
    echo ~/.$i exists. not overwriting.
  else
    echo ln -s $DOTFILES_DIR/$i ~/.$i
    ln -s $DOTFILES_DIR/$i ~/.$i
  fi
done

if [ $(uname) != "Darwin" ]
then
  echo updating termcap
  tic xterm-color-leopard.termcap
fi

# set up textmate bundles
if [ $(uname) = "Darwin" ] && \
   [ ! -h ~/Library/Application\ Support/TextMate/Bundles ]
then
  echo Setting up TextMate bundles symlink
  mkdir -p ~/Library/Application\ Support/TextMate
  if [ -d ~/Library/Application\ Support/TextMate/Bundles ]
  then
    mv -f ~/Library/Application\ Support/TextMate/Bundles \
        ~/Library/Application\ Support/TextMate/Bundles_old
  fi
  ln -s ~/dotfiles/TextmateBundles \
      ~/Library/Application\ Support/TextMate/Bundles
fi

# Set up ghostty

ln -s $HOME/dotfiles/ghostty $HOME/.config/ghostty

echo "put this in your crontab:"
echo "10 4 * * * /home/adlr/dotfiles/clear_dead_mosh_sessions.sh"

echo "All done. Use chsh to change shell."
