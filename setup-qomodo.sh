#! /bin/bash

# define colors for echo output
RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
NC='\033[0m' # No Color

# install slack
sudo snap install slack
echo -e "${GREEN}Slack installed!${NC}"