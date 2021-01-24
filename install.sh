#!/bin/sh

set -eo pipefail

basedir="$HOME/.dotfiles"
source dependencies.conf

#----------------------------------------------------------------------------
# Installer Suites
#----------------------------------------------------------------------------
install_other() {
  echo "Installing other specified dependencies..."
  for (( i = 0; i < ${#other_installs[@]} ; i++ )); do
    eval "${other_installs[$i]}" || true
  done
}

insta_brew() {
  if [ $WIPE_BREW == "true" ]; then
    echo "Taking away all of the brew things..."
    sudo chown -R $(whoami) $(brew --prefix)/*
    brew cleanup
    brew doctor
    brew remove --force $(brew list --formula)
  fi
  echo "Installing homebrew and all of its things..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  brew update
  brew install ${brew_dependencies[@]}
  brew tap ${casks[@]}
  brew install --cask ${cask_dependencies[@]} --force
}

vim_please() {
  echo "Backing up + Creating Symlinked Vimrc..."
  mkdir -p backups/vimrc
  cp ~/.vimrc "backups/vimrc/.vimrc-$( date '+%F_%H:%M:%S' )" || true
  rm ~/.vimrc || true
  ln -s $(pwd)/.vimrc ~/.vimrc
}

tmux_please() {
  brew install tmux &> /dev/null
  echo "Backing up + Creating Symlinked Tmux.conf..."
  mkdir -p backups/tmux.conf
  cp ~/.tmux.conf "backups/tmux.conf/.tmux.conf-$( date '+%F_%H:%M:%S' )" || true
  rm ~/.tmux.conf || true
  ln -s $(pwd)/.tmux.conf ~/.tmux.conf
}

vsc_please() {
  echo "Backing up + Creating Symlinked Code Shell..."
  mkdir -p backups/code-shell
  cp ~/.code-shell "backups/code-shell/.code-shell-$( date '+%F_%H:%M:%S' )" || true
  rm ~/.code-shell || true
  ln -s $(pwd)/.code-shell ~/.code-shell
}

zsh_please() {
  echo "Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || true
  echo "Backing up + Creating Symlinked Zshrc..."
  mkdir -p backups/zshrc
  cp ~/.zshrc "backups/zshrc/.zshrc-$( date '+%F_%H:%M:%S' )" || true
  rm ~/.zshrc || true
  ln -s $(pwd)/.zshrc ~/.zshrc
}

#----------------------------------------------------------------------------
# Flag Handlers
#----------------------------------------------------------------------------
while test $# -gt 0; do
  case "$1" in
    --install-dependencies)
      read -p "Install Everything? Are you really sure, you know this won't be fun to revert. [yn]: ";
      if [ $REPLY != "y" ]; then
        exit 0;
      fi
      INSTALL_BREW="true"
      break
      ;;
    --clean-slate)
      read -p "Reset EVERYTHING? Are you really sure, you know this could be bad. [yn]: ";
      if [ $REPLY != "y" ]; then
        exit 0;
      fi
      INSTALL_BREW="true"
      WIPE_BREW="true"
      break
      ;;
    *)
      break
      ;;
  esac
done

#----------------------------------------------------------------------------
# Main
#----------------------------------------------------------------------------
if [[ $INSTALL_BREW == "true" ]]; then
  insta_brew
  install_other # you get the gist
fi

zsh_please
vim_please
vsc_please
tmux_please


