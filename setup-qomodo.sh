#! /bin/bash

# define colors for echo output
RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
NC='\033[0m' # No Color

# install slack
sudo snap install slack
echo -e "${GREEN}Slack installed!${NC}"

# install aws cli
sudo apt install -y curl unzip
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm -rf awscliv2.zip aws
echo -e "${GREEN}AWS CLI installed!${NC}"