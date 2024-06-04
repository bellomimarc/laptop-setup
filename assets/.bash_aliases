#alias docker-compose='docker compose'
alias ..='cd ..'
alias ....='cd .. && cd ..'
alias ......='cd .. && cd .. && cd ..'

function ps-memory-mb() {
        ps -eo size,pid,user,command --sort -size | \
                awk '{ hr=$1/1024 ; printf("%13.2f Mb ",hr) } { for ( x=4 ; x<=NF ; x++ ) { printf("%s ",$x) } print "" }' |\
                cut -d "" -f2 | cut -d "-" -f1
}

function ngrok-get-authtoken() {
        result=$(ngrok config check)

        if [[ $result == "Valid configuration file at "* ]]; then
                result=${result:27}
                cat $result | yq .authtoken
                return
        fi

        echo "No valid configuration file found"
}

function generate-file() {
        size=${1-1}
        dd if=/dev/zero of=bigfile bs=1M count=$size

        echo "File generated called 'bigfile' with size $size MB"
}

# git
function git-echo-branch() {
        echo -e "You are building the branch \033[0;32m$(git branch --show-current)\033[0m"
}

# docker
alias docker-rmi-untagged="docker rmi $(docker images -f 'dangling=true' -q)"
alias docker-get-container-ip="docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}'"
alias docker-image-sort-size="docker images --format '{{.Size}}\t{{.Repository}}:{{.Tag}}' | sort -h"

# xclip setup
alias setclip="xclip -selection c"
alias getclip="xclip -selection c -o"

# jwt parse
alias jwtp="jq -R 'split(\".\") | .[1] | @base64d | fromjson'"
alias jwth="jq -R 'split(\".\") | .[0] | @base64d | fromjson'"

# pgadmin
alias pgadmin="/usr/pgadmin4/bin/pgadmin4"

# yq tricks
alias yq-image-props="yq -o=props - | grep 'image ='"

# network
alias port-listening="sudo netstat -tulpn | grep LISTEN"
alias my-ip="curl -s https://api.ipify.org"

# redis
function _ping_redis() { 
        local host;
        local port;
        local pass;
        while getopts "h:p:pass:" opt; do 
                case $opt in 
                        h) host=$OPTARG;; 
                        p) port=$OPTARG;;
                        pass) pass=$OPTARG;;
                esac; 
        done; 

        # use localhost if not specified
        if [ -z "$host" ]; then 
                host=localhost;
        fi;

        # use port 6379 if not specified
        if [ -z "$port" ]; then 
                port=6379;
        fi;

        # if no password is specified, ping without auth
        if [ -z "$pass" ]; then 
                (printf "PING\r\n";) | nc $host $port
                return;
        fi;

        # ping redis
        (printf "AUTH $pass\r\nPING\r\n";) | nc $host $port
};

alias ping-redis="_ping_redis -h localhost -p 6379 -pass \"\""

# git
cloneIfNotExists() {
    if [ ! -d "$2" ]; then
        git clone $1
    else
        echo -e "The repository $2 already exists!"
    fi
}