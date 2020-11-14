#!/bin/bash

###############################################
# Machine and dotfiles Management             #
###############################################
alias dotupdate="cd ~/.dotfiles && git pull && reload"
alias dots="${DOTFILES_EDITOR} ~/.dotfiles"
alias reload='source ~/.dotfiles/loader.sh && echo "sourced ~/.dotfiles/loader.sh"'

alias hosts="${DOTFILES_EDITOR} /etc/hosts"
alias khosts="knownhosts"
alias knownhosts="${DOTFILES_EDITOR} ~/.ssh/known_hosts"

alias dotconf="${DOTFILES_EDITOR} ~/.dotfiles/config.cfg"
alias .conf=dotconf

# Get macOS Software Updates, and update installed Ruby gems, Homebrew, npm, and their installed packages
alias update='sudo softwareupdate -i -a; brew update; brew upgrade; brew cleanup; npm install npm -g; npm update -g; sudo gem update --system; sudo gem update; sudo gem cleanup; updatewpcli; upgradeallcasks'

###############################################
# Formatting & Colors                         #
###############################################
# Portable ls with colors
alias ls='ls -G'

# Always enable colored `grep` output
# Note: `GREP_OPTIONS="--color=auto"` is deprecated, hence the alias usage.
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

###############################################
# Shortcuts                                   #
###############################################
alias d="cd ~/Documents/Dropbox"
alias dl="cd ~/Downloads"
alias dt="cd ~/Desktop"
alias p="cd ~/projects"
alias g="git"

###############################################
# Shell                                       #
###############################################

alias la='ls -alhF' # List in long format, include dotfiles
alias l="ls"
alias ld="ls -ld */"   # List in long format, only directories
alias cdd='cd -'  # back to last directory
alias pg='ps aux | head -n1; ps aux | grep -i'
alias tf='tail -F -n200'
alias top='top -ocpu'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias .......='cd ../../../../../..'
alias ipp="ifconfig|grep broadcast"  # List IPs

alias ip="dig +short myip.opendns.com @resolver1.opendns.com"


###############################################
# Applications                                #
###############################################
alias s='sublime'
alias p='phpstorm'
alias v='vim'
alias n='nano'

# Airport CLI alias
alias airport='/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport'

# Disable Spotlight
alias spotoff="sudo mdutil -a -i off"
# Enable Spotlight
alias spoton="sudo mdutil -a -i on"

# Google Chrome
alias chrome='/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome'
alias canary='/Applications/Google\ Chrome\ Canary.app/Contents/MacOS/Google\ Chrome\ Canary'

###############################################
# Utilities                                   #
###############################################

# Enable aliases to be sudo’ed
alias sudo='sudo '

# Get week number
alias week='date +%V'

# Lock the screen (when going AFK)
alias afk="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"

# Print each PATH entry on a separate line
alias path='echo -e ${PATH//:/\\n}'

# Recursively remove .DS_Store files
alias cleanupds="find . -type f -name '*.DS_Store' -ls -delete"

# https://github.com/Fykec/sl-mac
alias sl='/usr/local/bin/sl'

alias tailf="tail -f -n 50 "

#alias npm=gifi

# TheFuck :)
# https://github.com/nvbn/thefuck
#eval "$(thefuck --alias kuk)"
#alias kuken="thefuck"

# Canonical hex dump; some systems have this symlinked
command -v hd > /dev/null || alias hd="hexdump -C"

# macOS has no `md5sum`, so use `md5` as a fallback
command -v md5sum > /dev/null || alias md5sum="md5"

# macOS has no `sha1sum`, so use `shasum` as a fallback
command -v sha1sum > /dev/null || alias sha1sum="shasum"

# Merge PDF files
# Usage: `mergepdf -o output.pdf input{1,2,3}.pdf`
alias mergepdf='/System/Library/Automator/Combine\ PDF\ Pages.action/Contents/Resources/join.py'

# Stuff I never really use but cannot delete either because of http://xkcd.com/530/
alias stfu="osascript -e 'set volume output muted true'"
alias pumpitup="osascript -e 'set volume output volume 100'"

# Kill all the tabs in Chrome to free up memory
# [C] explained: http://www.commandlinefu.com/commands/view/402/exclude-grep-from-your-grepped-output-of-ps-alias-included-in-description
alias chromekill="ps ux | grep '[C]hrome Helper --type=renderer' | grep -v extension-process | tr -s ' ' | cut -d ' ' -f2 | xargs kill"


###############################################
# SSH                                         #
###############################################

# Setup aliases for all SSH connections loaded from config
for k in "${(@k)ssh_servers}"; do

	alias ssh${k}="${ssh_servers[$k]}"
	alias ${k}="${ssh_servers[$k]}"

done

alias servers="listservers"

###############################################
# Docker                                      #
###############################################

alias dup="docker-compose up -d"
alias ddown="docker-compose down"
alias dd="ddown"
alias dcu="docker-compose up"
alias dcub="docker-compose up --build"
alias dcubd="docker-compose up --build -d"
alias dph="docker-compose push"
alias dpl="docker-compose pull"
alias dre="docker-compose restart"
alias dssh="docker-compose exec workspace bash"

alias dcbuild="docker-compose up -d --force-recreate --build"

alias dcbash='docker-compose exec --user root phpfpm bash'


###############################################
# MySQL                                     #
###############################################

alias cpdb="copy_database"

###############################################
# Vagrant                                     #
###############################################

# Generic. Can be run on any vagrant box.
# Must to be run from Vagrant folder (the folder that contains the Vagrantfile)
alias vup="vagrant up"
alias vssh="vagrant ssh"
alias vreload="vagrant reload"
alias vreloadpro="vagrant reload --provision"
alias vre="vreload"
alias vpre="vreloadpro"
alias vreprov="vreloadpro"
alias vprov="vagrant provision"
alias vsus="vagrant suspend"
alias vst="vagrant status"
alias vbu="vagrant box update"

alias vlist="listboxes"
alias .list="listboxes"
alias boxes="listboxes"

# Specific boxes. Loaded from config
for k in "${(@k)vagrant_boxes}"; do

	alias ${k}up="vagrantup ${k}"
	alias ${k}upg="vagrantup ${k} gulpstart ${k}"
	#alias ${k}upg="vagrantsuspendall && cd ${vagrant_boxes[$k]} && sleep 1 && vagrant up && gulpstart ${k}"
	alias ${k}ssh="cd ${vagrant_boxes[$k]} && vagrant ssh"
	alias ${k}reload="cd ${vagrant_boxes[$k]} && vagrant reload"
	alias ${k}reprov="cd ${vagrant_boxes[$k]} && vagrant reload --provision"
	alias ${k}sus="cd ${vagrant_boxes[$k]} && vagrant suspend"
	alias ${k}cd="cd ${vagrant_boxes[$k]}"

done


# I always forget the common options.
alias rsync2="echo 'rsync -azP server:/path/ path (Slashes are significant.)'"

# Ruby on Rails
alias sc="[ -f script/console ] && script/console || bundle exec rails console"
alias sx="[ -f script/console ] && script/console --sandbox || bundle exec rails console --sandbox"
alias sdb="[ -f script/dbconsole ] && script/console --include-password || bundle exec rails dbconsole --include-password"
alias ss="[ -f script/server ] && script/server || rails server"
alias mig="rake db:migrate"
alias f="script/foreman_turbux"

alias be="bundle exec"

# Tests
alias rsua="bundle exec rake spec:unit:all"
alias rsp="rake testbot:spec"



###############################################
# NPM                                         #
###############################################
alias nin="npm install && say -v Fiona 'WoooHoo, Great success'"
alias nup="npm update"

###############################################
# Composer                                    #
###############################################
alias composer="COMPOSER_MEMORY_LIMIT=-1 composer"
alias cin="composer install"
alias cup="composer update"
alias cupd="composer update --dry-run"
alias crq="composer require "
alias crm="composer remove "
alias cda="composer dumpautoload "
alias cdump="cda"
alias crqwpackagist="composer_require_wpackagist "
alias crqp="crqwpackagist "
alias crqwp="crqwpackagist "
alias crqstatispelmered="composer_require_satis_pelmered "
alias crqel="crqstatispelmered "
alias crqpremium="composer_require_premium_components "
alias cupdatepackage="composer_update_package "
alias cuppkg="cupdatepackage "
alias cupp="cupdatepackage "
alias cupproject="composer_update_project "
alias coutdated="composer outdated -D "
alias cout="composer outdated -D "


alias wptocomposer="wget https://raw.githubusercontent.com/pelmered/wp-to-composer/master/wp-to-composer.php && php wp-to-composer.php"

###############################################
# Laravel                                     #
###############################################

alias art="php artisan"
alias a="art"

###############################################
# Git                                         #
###############################################
alias g="git"
alias gl="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias ga="git add"
alias gap="git add -p"
alias gc="git commit -m"
alias gca="git commit -am"
alias gs="git status"
# Recursive git status (checks all subfolders)
alias gsr="find . -maxdepth 1 -mindepth 1 -type d -exec sh -c '(echo {} && cd {} && git status -s && echo)' \;"
alias gw="git show"
alias gw^="git show HEAD^"
alias gw^^="git show HEAD^^"
alias gd="git diff HEAD"  # What's changed? Both staged and unstaged.
alias gds="git diff --staged"  # What's changed? Only staged (added) changes.
alias gdo="git diff --cached"  # What's changed? Only staged (added) changes.
alias gdst="git diff --stat" # Summary of modified files
alias gdss="git diff --cached --stat" # Summary of added files
# for gco ("git commit only") and gca ("git commit all"), see functions.sh.
alias gcaf="git add --all && gcof"
alias gcof="git commit --no-verify -m"
alias gcac="gca Cleanup."
alias gcoc="gco Cleanup."
alias gcaw="gca Whitespace."
alias gpl='git pull'
alias gph='git push origin $(git_current_branch)'
alias gpp='git pull --rebase && git push'
alias gpps='git stash && git pull --rebase && git push && git stash apply'
alias gplh='git pull && git push origin $(git_current_branch)   '
alias gppp="git push -u"  # Can't pull because you forgot to track? Run this.
alias gps='(git stash --include-untracked | grep -v "No local changes to save") && gpp && git stash pop || echo "Fail!"'
#alias go="git checkout"
alias gco="git checkout"
alias gb="git branch"
alias gcb="git checkout -b"
alias got="git checkout -"
alias gom="git checkout master"
alias god="git checkout develop"
alias gr="git branch -d"
alias grr="git branch -D"
alias gcp="git cherry-pick"
alias gam="git commit --amend"
alias gamm="git add --all && git commit --amend -C HEAD"
alias gammf="gamm --no-verify"
alias gba="git rebase --abort"
alias gbc="git add -A && git rebase --continue"
alias gbm="git fetch origin master && git rebase origin/master"
alias gcleanignore=""
alias grlc="git reset HEAD~" # Remove last commit
alias gundo="grlc"

#Merge current branch to master
alias gmb="git_merge_branch"
alias grb="git_rebase_branch"


# tmux
alias ta="tmux attach"
# With tmux mouse mode on, just select text in a pane to copy.
# Then run tcopy to put it in the OS X clipboard (assuming reattach-to-user-namespace).
alias tcopy="tmux show-buffer | pbcopy"

# Servers
alias rst="touch tmp/restart.txt && echo touched tmp/restart.txt"  # Passenger

# Straight into console-in-screen.
# Assumes there is only one screen running.
alias prodc="ssh anpa -t screen -RD"
