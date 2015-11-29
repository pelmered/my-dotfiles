
echo "Installing dotfiles..."

SHELL_TYPE=$1;

brew install thefuck
brew install bash

ln -s ~/.dotfiles/shuttle.json .shuttle.json 
ln -s ~/.dotfiles/gitignore .gitignore 

#echo $SHELL_TYPE;
#echo $ZSH_VERSION;
#echo $BASH_VERSION;

if [ -n "$ZSH_VERSION" ]; then
#if [ $SHELL_TYPE = 'zsh' ]; then
   # assume Zsh shell
   echo "ZSH"
   cat ~/.dotfiles/bash/zshrc >> ~/.zshrc
   source ~/.dotfiles/bash/zsh-install.sh

elif [ -n "$BASH_VERSION" ]; then
#elif [ $SHELL_TYPE = 'bash' ]; then
   # assume Bash shell
   echo "bash"
   source ~/.dotfiles/bash/bash-install.sh

else
   # asume something else

   echo "Unkown shell";
fi

