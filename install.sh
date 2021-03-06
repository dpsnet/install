#!/bin/bash

#
## Colors
#

GREEN="\033[0;32m"
YELLOW="\033[0;33m"
RED="\033[0;31m"
NEUTRAL="\033[0m"

#
## Displaying functions
#

function already {
  echo -e "${YELLOW}[-]$1 is already installed${NEUTRAL}"
}

function installing {
  echo -e "${GREEN}[~]Installing $1...${NEUTRAL}"
}

function success {
  echo -e "${GREEN}[+]$1 successfully installed${NEUTRAL}"
}

function success {
  echo -e "${GREEN}[+]$1 successfully installed${NEUTRAL}"
}

function exitBanner {
    echo "#"
    echo "#"
    echo "#  Node.js and PM2 is now installed"
    echo "#  It is also linked to Keymetrics!"
    echo "#"
    echo "#  Now exit the shell and login back to be able to use the PM2 CLI"
    echo "#"
    echo "#"
}

#
## Logic
#

function install_nvm {
  if [ -a $HOME/.nvm ]; then
    already nvm
  else
    installing nvm
    wget -qO- https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
    . ~/.nvm/nvm.sh
    success nvm
  fi
}

function install_node {
  node -v &>/dev/null
  if [ $? == "0" ]; then
    already node
  else
    installing node
    nvm install stable
    nvm use stable
    nvm alias default stable
    success node
  fi
}

function install_pm2 {
  pm2 &>/dev/null
  if [ $? == "1" ]; then
    already PM2
  else
    installing PM2
    npm install -g pm2@latest
    . ~/.nvm/nvm.sh
    pm2 update
    success PM2
  fi
}

function link_pm2 {
  echo -e "${GREEN}[~]Checking connectivity with Keymetrics servers...${NEUTRAL}"

  echo -en "${GREEN}[~]Checking port 80 connectivity...${NEUTRAL}"
  nc -z app.keymetrics.io 80 &>/dev/null
  if [ $? == "1" ]; then
    echo -e "${RED}[KO]${NEUTRAL}"
    echo -e "${RED}[!]Connectivity issues when trying to connect to alphacentauri.keymetrics.io:80${NEUTRAL}"
    exit
  fi
  echo -e "${GREEN}[OK]${NEUTRAL}"

  # echo -en "${GREEN}[~]Checking port 43554 connectivity...${NEUTRAL}"
  # nc -z app.keymetrics.io 43554 &>/dev/null
  # if [ $? == "1" ]; then
  #   echo -e "${RED}[KO]${NEUTRAL}"
  #   echo -e "${RED}[!]Connectivity issues when trying to connect to alphacentauri.keymetrics.io:43554${NEUTRAL}"
  #   exit
  # fi
  # echo -e "${GREEN}[OK]${NEUTRAL}"

  pm2 link $SECRET_ID $PUBLIC_ID
}

#
## Main
#

install_nvm
install_node
install_pm2
link_pm2
exitBanner

echo
echo -e "${GREEN}[+]Done.${NEUTRAL}"
