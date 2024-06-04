#! /bin/bash

# define colors for echo output
RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
NC='\033[0m' # No Color

sudo apt-get update -y
sudo apt-get upgrade -y

# create the folder where to clone the repos
cd ~
mkdir repos && cd repos/
cd -

# install git
sudo apt-get install git -y
git config --global user.name "Marcello Bellomi"
git config --global user.email "marcello.bellomi@gmail.com"
# git config --global pull.rebase false  # merge (the default strategy)
# git config --global pull.rebase true   # rebase
# git config --global pull.ff only       # fast-forward only
git config --global credential.helper store

# check if git has keys
if [ -f ~/.ssh/id_rsa ] && [ -f ~/.ssh/id_rsa.pub ]; then
    echo -e "${GREEN}Git keys already exist.${NC}"
    # clone this repository
    cd ~/repos/
    git clone git@bitbucket.org:marcellobellomi/laptop-setup.git
else
    echo -e "${ORANGE}Git keys do not exist.${NC}"

    # generate private key
    ssh-keygen -t rsa -b 4096 -C "marcello.bellomi@gmail.com"
    # generate public key from private key, load it on bitbucket!
    ssh-keygen -y -f ~/.ssh/id_rsa >~/.ssh/id_rsa.pub
    echo "Public key:"
    cat ~/.ssh/id_rsa.pub

    echo "MANUALLY: load the public key on bitbucket!"
    exit 0
fi
