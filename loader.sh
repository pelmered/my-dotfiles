#!/usr/bin/env bash

DOTFILES_PATH=$( cd $(dirname $0) ; pwd -P );

source ${DOTFILES_PATH}/config.cfg;

# Export all defined paths
#for k in "${(@k)paths}"; do
#	export PATH="$PATH:${paths[$k]}";
#done

source ${DOTFILES_PATH}/functions.sh
source ${DOTFILES_PATH}/aliases.sh

# Fix locale settings
LANGUAGE=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Add SSH key for forward agent
ssh-add -K ~/.ssh/id_rsa


#if [ -f $(brew --prefix)/etc/bash_completion ]; then source $(brew --prefix)/etc/bash_completion; fi
