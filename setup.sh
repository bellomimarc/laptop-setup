#! /bin/bash

# define colors for echo output
RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
NC='\033[0m' # No Color

# copy and reload the bash aliases
cp ~/repos/laptop-setup/assets/.bash_aliases ~/.bash_aliases
source ~/.bash_aliases
echo -e "${GREEN}Bash aliases copied!${NC}"

# append some configuration to /etc/sysctl.conf if not present
# echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf
# echo fs.aio-max-nr=1048576 | sudo tee -a /etc/sysctl.conf
# sudo sysctl -p

# clone all the repositories where I have write access
# cloneIfNotExists git@bitbucket.org:ooo/xxx.git ~/repos/xxx

# install the basic tools
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
sudo apt-get install -y xclip
sudo apt install -y plocate
sudo apt-get install -y htop
sudo apt install ncdu
sudo apt-get install -y net-tools # ifconfig
sudo apt install icdiff           # diff tool
echo -e "${GREEN}Basic tools installed!${NC}"

# install ipcalc (help in subnetting)
sudo apt-get install -y ipcalc

# install startup disk creator
sudo apt-get install -y usb-creator-gtk

# install vscode
if [ ! -d "/usr/share/code" ]; then
    curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >microsoft.gpg
    sudo install -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/microsoft-archive-keyring.gpg
    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/usr/share/keyrings/microsoft-archive-keyring.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'

    sudo apt-get install -y apt-transport-https
    sudo apt-get update
    sudo apt-get install -y code
    echo -e "${GREEN}VSCode installed!${NC}"
else
    echo -e "${GREEN}VSCode already installed!${NC}"
fi

# install pgadmin
curl -fsS https://www.pgadmin.org/static/packages_pgadmin_org.pub | sudo gpg --dearmor -o /usr/share/keyrings/packages-pgadmin-org.gpg
sudo sh -c 'echo "deb [signed-by=/usr/share/keyrings/packages-pgadmin-org.gpg] https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main" > /etc/apt/sources.list.d/pgadmin4.list && apt update'
sudo apt install -y pgadmin4-desktop
echo -e "${GREEN}PgAdmin installed!${NC}"

# install chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
echo -e "${GREEN}Chrome installed!${NC}"

# install postman
sudo snap install postman
echo -e "${GREEN}Postman installed!${NC}"

# install vlc
sudo snap install vlc
echo -e "${GREEN}VLC installed!${NC}"

# install pinta image editor
sudo snap install pinta
echo -e "${GREEN}Pinta installed!${NC}"

# install vim
sudo apt-get install -y vim
echo -e "${GREEN}Vim installed!${NC}"

# install terminator
sudo add-apt-repository ppa:gnome-terminator
sudo apt-get update
sudo apt-get install terminator
echo -e "${GREEN}Terminator installed!${NC}"

# install semver
sudo wget -O /usr/local/bin/semver \
    https://raw.githubusercontent.com/fsaintjacques/semver-tool/master/src/semver
sudo chmod +x /usr/local/bin/semver

# install rclone
sudo -v
curl https://rclone.org/install.sh | sudo bash
echo -e "${GREEN}Rclone installed!${NC}"

# Install docker - from repository
sudo apt-get update
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
sudo mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo addgroup --system docker
sudo adduser $USER docker
newgrp docker
echo -e "${GREEN}Docker installed!${NC}"

# install docker-compose
sudo curl -SL https://github.com/docker/compose/releases/download/v2.15.1/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
echo -e "${GREEN}Docker Compose installed!${NC}"

# install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
echo -e "${GREEN}NVM installed!${NC}"

# create a symbolic link to nodejs (so I can run "sudo npx")
sudo ln -s "$NVM_DIR/versions/node/$(nvm version)/bin/node" "/usr/local/bin/node"
sudo ln -s "$NVM_DIR/versions/node/$(nvm version)/bin/npm" "/usr/local/bin/npm"
sudo ln -s "$NVM_DIR/versions/node/$(nvm version)/bin/npx" "/usr/local/bin/npx"
echo -e "${GREEN}NodeJS symbolic link created!${NC}"

# install nodejs
nvm install --lts
echo -e "${GREEN}NodeJS installed!${NC}"

# install ncu
npm install -g npm-check-updates
echo -e "${GREEN}NCU installed!${NC}"

# install draw.io
sudo snap install drawio

# install arkade
curl -sLS https://get.arkade.dev | sudo sh
echo 'export PATH=$PATH:$HOME/.arkade/bin/' >>~/.bashrc
source ~/.bashrc
echo -e "${GREEN}Arkade installed!${NC}"

# install kubectl
arkade get kubectl
echo "source <(kubectl completion bash)" >>~/.bashrc
echo -e "${GREEN}Kubectl installed!${NC}"

# install krew
(
  set -x; cd "$(mktemp -d)" &&
  OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
  ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
  KREW="krew-${OS}_${ARCH}" &&
  curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" &&
  tar zxvf "${KREW}.tar.gz" &&
  ./"${KREW}" install krew
)
echo "export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"" >>~/.bashrc
source ~/.bashrc
echo -e "${GREEN}Krew installed!${NC}"

# install kubectl view utilisation
kubectl krew install view-utilization
echo -e "${GREEN}Kubectl view utilisation installed!${NC}"

# install kubectl resource capactiy
kubectl krew install resource-capacity
echo -e "${GREEN}Kubectl resource capacity installed!${NC}"

# install kubectl stern
kubectl krew install stern
echo -e "${GREEN}Kubectl stern installed!${NC}"

# install helm
arkade get helm
echo -e "${GREEN}Helm installed!${NC}"
helm plugin install https://github.com/databus23/helm-diff

# install helmfile
arkade get helmfile
echo -e "${GREEN}Helmfile installed!${NC}"

# install k9s
arkade get k9s
echo -e "${GREEN}K9s installed!${NC}"

# install kubectx
arkade get kubectx
echo -e "${GREEN}Kubectx installed!${NC}"

# install kubens
arkade get kubens
echo -e "${GREEN}Kubens installed!${NC}"

# install popeye
arkade get popeye
echo -e "${GREEN}Popeye installed!${NC}"

# install jq
arkade get jq
echo -e "${GREEN}Jq installed!${NC}"

# install yq
arkade get yq
echo -e "${GREEN}Yq installed!${NC}"

# install minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
sudo usermod -aG docker $USER && newgrp docker
echo -e "${GREEN}Minikube installed!${NC}"

# # install google cloud sdk (https://cloud.google.com/sdk/docs/install?hl=it)
# sudo apt-get install apt-transport-https ca-certificates gnupg
# echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
# curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
# sudo apt autoremove
# sudo apt --fix-broken -y install
# sudo apt-get update
# sudo apt-get install google-cloud-cli
# sudo apt-get install google-cloud-sdk-gke-gcloud-auth-plugin
# gcloud init
# echo -e "${GREEN}Google Cloud SDK installed!${NC}"

# # retrieve the credentials for the kubernetes clusters
# gcloud container clusters get-credentials corvina-internal --zone europe-west1-b --project corvina-internal
# gcloud container clusters get-credentials corvina-internal-qa --zone europe-west1-b --project corvina-internal-qa
# echo -e "${GREEN}Kubernetes clusters credentials retrieved!${NC}"

# # install heroku CLI
# curl https://cli-assets.heroku.com/install-ubuntu.sh | sh
# echo -e "${GREEN}Heroku CLI installed!${NC}"

# install trivy
sudo apt-get install wget apt-transport-https gnupg lsb-release
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor | sudo tee /usr/share/keyrings/trivy.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo apt-get update
sudo apt-get install trivy
echo -e "${GREEN}Trivy installed!${NC}"
