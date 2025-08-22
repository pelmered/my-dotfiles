#!/usr/bin/env bash

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

for tap in "caskroom/cask" \
	"caskroom/fonts" \
	"homebrew/core" \
	"homebrew/php" \
	"homebrew/versions" ; do
	brew tap ${tap}
done

# Install GNU core utilities (those that come with macOS are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils

# Install some other useful utilities like `sponge`.
brew install moreutils
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
brew install findutils
# Install GNU `sed`, overwriting the built-in `sed`.
brew install gnu-sed --with-default-names
# Install Bash 4.
# Note: don’t forget to add `/usr/local/bin/bash` to `/etc/shells` before
# running `chsh`.
brew install bash
brew install bash-completion2

# Switch to using brew-installed bash as default shell
if ! fgrep -q '/usr/local/bin/bash' /etc/shells; then
  echo '/usr/local/bin/bash' | sudo tee -a /etc/shells;
  chsh -s /usr/local/bin/bash;
fi;

# Install `wget` with IRI support.
brew install wget --with-iri

# Install GnuPG to enable PGP-signing commits.
brew install gnupg


brew install autoconf
brew install boost
brew install composer
brew install curl
brew install diff-so-fancy
brew install dnsmasq
brew install docker
brew install docker-compose
brew install docker-machine
brew install fdupes
brew install freetype
brew install gdbm
brew install gettext
brew install git
brew install git-extras
brew install git-flow
brew install git-fresh
brew install grc
brew install highlight
brew install htop-osx
brew install httpie
brew install icu4c
brew install jpeg
brew install kubernetes-cli
brew install libpng
brew install libtool
brew install libxml2
brew install lua
brew install mariadb
brew install mcrypt
brew install mhash
brew install mobile-shell
brew install nginx
brew install node
brew install ntfs-3g
brew install openssl
brew install openssl@1.1
brew install pcre
# Install latest version manually
#brew install php71
#brew install php71-mcrypt
#brew install php71-xdebug
brew install phpmd
brew install phpunit
brew install pkg-config
brew install protobuf
brew install pv
brew install python
brew install python3
brew install rbenv
brew install rbenv-default-gems
brew install readline
brew install reattach-to-user-namespace
brew install ruby-build
brew install spark
brew install sqlite
brew install thefuck
brew install tree
brew install youtube-dl
brew install unixodbc
brew install unrar
#brew install vv
brew install wget
brew install xz
brew install yarn
brew install zsh
brew install zsh-completions
brew install zoxide


# Remove outdated versions from the cellar.
brew cleanup
