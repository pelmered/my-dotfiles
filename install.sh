
echo "Before installing you install, you need:";
echo " - Latest/desired version of PHP";
echo " - Homebrew";
echo "";
echo "";
echo "Proceed? (y/N) ";
echo "";

read REPLY;

if [[ "$REPLY" != "y" ]]; then
	echo "Aborted";
	return 1;
fi

echo "Installing dotfiles..."

DOTFILES_PATH=$( cd $(dirname $0) ; pwd -P );
SHELL_TYPE=$1;

#xcode-select --install

#/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

#${DOTFILES_PATH}/iTerm2/import-colors.sh;


#${DOTFILES_PATH}/brew.sh

ln -s ${DOTFILES_PATH}/gitignore .gitignore

# Symlink Sublime text 2 to local bin so we can use "subl [file]" to open file from terminal
ls -s /Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl /usr/local/bin/subl

# Hide OS X Dock and remove show/hide delay
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0
killall Dock

# Show/hide hidden files in Finder
defaults write com.apple.finder AppleShowAllFiles -bool true
killall Finder
