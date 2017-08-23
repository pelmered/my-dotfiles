
#chsh -s /usr/local/bin/bash

source ~/.dotfiles/config.cfg;

source ~/.dotfiles/zsh/zsh.sh

#if [ -n "$ZSH_VERSION" ]; then
#   # assume Zsh shell
#   source ~/.dotfiles/zsh/zsh.sh
#
#elif [ -n "$BASH_VERSION" ]; then
#   # assume Bash shell
#   source ~/.dotfiles/bash/bash.sh
#else
#   # asume something else
#   echo "Unkown shell";
#fi

source ~/.dotfiles/functions.sh
source ~/.dotfiles/aliases.sh

# Fix locale settings
LANGUAGE=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8


#if [ -f $(brew --prefix)/etc/bash_completion ]; then source $(brew --prefix)/etc/bash_completion; fi
