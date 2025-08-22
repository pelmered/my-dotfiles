#!/usr/bin/env bash

DOTFILES_PATH=$( cd $(dirname $0) ; pwd -P );

#source ${DOTFILES_PATH}/config.cfg;

function get_dot_config()
{
  CONFIG_KEY=$1;
  DEFAULT_CONFIG_KEY=${2:-""}

  #echo "CONFIG_KEY: ${CONFIG_KEY}"
  #echo "DEFAULT_CONFIG_KEY: ${DEFAULT_CONFIG_KEY}"

  if [ -n "$DEFAULT_CONFIG_KEY" ]; then
    echo $(yq e "${CONFIG_KEY} // ${DEFAULT_CONFIG_KEY}" ${DOTFILES_PATH}/config.yaml)
  else
    echo $(yq e ${CONFIG_KEY} ${DOTFILES_PATH}/config.yaml)
  fi
}

# Export all defined paths
#for k in "${(@k)paths}"; do
#	export PATH="$PATH:${paths[$k]}";
#done

source ${DOTFILES_PATH}/aliases.sh
source ${DOTFILES_PATH}/functions.sh
source ${DOTFILES_PATH}/grebban.sh

# Fix locale settings
LANGUAGE=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Add SSH key for forward agent
ssh-add --apple-use-keychain ~/.ssh/id_rsa

#if [ -f $(brew --prefix)/etc/bash_completion ]; then source $(brew --prefix)/etc/bash_completion; fi

valet_services=($(yq -o=a -I=0 '.valet.additional_services' ${DOTFILES_PATH}/config.yaml))

# Setup SSH hosts aliases
identityMappings=($(yq -o=a -I=0 '.ssh.servers' ${DOTFILES_PATH}/config.yaml ))

cur=""
host=""
user=""
host_key=""

typeset -A ssh_servers

for k in ${identityMappings}; do

  if [[ $cur == "#" ]]; then
    host=""
    user=""
  elif [[ $cur == "host:" ]]; then
    host=$k
  elif [[ $cur == "user:" ]]; then
    user=$k
  elif ([[ -z $host_key ]] && [[ ! -z $cur ]] && [[ ${cur:(-1)} = ":" ]]); then
    host_key="${cur//:}"
  fi

  cur=$k;

  if ([[ ! -z $host ]] && [[ ! -z $user ]]); then

    alias ssh${host_key}="ssh ${user}@${host}"

    ssh_servers[${host_key}]="${user}@${host}"

    host=""
    user=""
    host_key=""
    cur=""
  fi

done

#export ssh_servers="${ssh_servers_array}"
#export ssh_servers=(${ssh_servers})


create_ssh_aliases;
