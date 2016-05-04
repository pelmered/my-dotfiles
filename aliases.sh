#!/bin/bash




# Management
alias dotupdate="cd ~/.dotfiles && git pull"
#alias dots="cd ~/.dotfiles && vim"
alias reload='source ~/.bash_profile && echo "sourced ~/.bash_profile"'
alias redot='cd ~/.dotfiles && gpp && rake install; cd -'

alias hosts="sublime /etc/hosts"
alias khosts="knownhosts"
alias knownhosts="sublime ~/.ssh/known_hosts"
alias vrb='vim -c "setf ruby"'

alias dotconf="sublime ~/.dotfiles/config.cfg"
alias .conf=dotconf

# Shell
alias la='ls -alh'
alias cdd='cd -'  # back to last directory
alias pg='ps aux | head -n1; ps aux | grep -i'
alias tf='tail -F -n200'
alias top='top -ocpu'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ip="ifconfig|grep broadcast"  # List IPs

alias tailf="tail -f -n 50 "

# https://github.com/Fykec/sl-mac
alias sl='/usr/local/bin/sl'

#alias npm=gifi

# TheFuck :)
# https://github.com/nvbn/thefuck
eval "$(thefuck --alias kuk)"
alias kuken="thefuck"
alias kk="thefuck"

# SSH
# Specific boxes. Loaded from config
for k in "${(@k)ssh_servers}"; do

	alias ssh${k}="${ssh_servers[$k]}"

done


# Vagrant

# Generic
alias vup="vagrant up"
alias vssh="vagrant ssh"
alias vreload="vagrant --provision reload"
alias vre="vreload"
alias vprov="vagrant provision"
alias vsus="vagrant suspend"
alias vst="vagrant status"

alias vlist="list_boxes"
alias .list="list_boxes"

# Specific boxes. Loaded from config
for k in "${(@k)vagrant_boxes}"; do

	alias ${k}up="vagrant_up ${k}"
	alias ${k}upg="vagrant_up ${k} gulpstart ${k}"
	#alias ${k}upg="vagrantsuspendall && cd ${vagrant_boxes[$k]} && sleep 1 && vagrant up && gulpstart ${k}"
	alias ${k}ssh="cd ${vagrant_boxes[$k]} && vagrant ssh"
	alias ${k}reload="cd ${vagrant_boxes[$k]} && vagrant reload"
	alias ${k}reprov="cd ${vagrant_boxes[$k]} && vagrant --provision reload"
	alias ${k}sus="cd ${vagrant_boxes[$k]} && vagrant suspend"
	alias ${k}cd="cd ${vagrant_boxes[$k]}"

done


# Portable ls with colors
if ls --color -d . >/dev/null 2>&1; then
  alias ls='ls --color=auto'  # Linux
elif ls -G -d . >/dev/null 2>&1; then
  alias ls='ls -G'  # BSD/OS X
fi

# I always forget the common options.
alias rsync2="echo 'rsync -az --progress server:/path/ path (Slashes are significant.)'"

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

# Git
alias g="git"
alias gs="git status"
alias gw="git show"
alias gw^="git show HEAD^"
alias gw^^="git show HEAD^^"
alias gd="git diff HEAD"  # What's changed? Both staged and unstaged.
alias gdo="git diff --cached"  # What's changed? Only staged (added) changes.
# for gco ("git commit only") and gca ("git commit all"), see functions.sh.
alias gcaf="git add --all && gcof"
alias gcof="git commit --no-verify -m"
alias gcac="gca Cleanup."
alias gcoc="gco Cleanup."
alias gcaw="gca Whitespace."
alias gpp='git pull --rebase && git push'
alias gppp="git push -u"  # Can't pull because you forgot to track? Run this.
alias gps='(git stash --include-untracked | grep -v "No local changes to save") && gpp && git stash pop || echo "Fail!"'
alias go="git checkout"
alias gb="git checkout -b"
alias got="git checkout -"
alias gom="git checkout master"
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

# tmux
alias ta="tmux attach"
# With tmux mouse mode on, just select text in a pane to copy.
# Then run tcopy to put it in the OS X clipboard (assuming reattach-to-user-namespace).
alias tcopy="tmux show-buffer | pbcopy"

# Servers
alias rst="touch tmp/restart.txt && echo touched tmp/restart.txt"  # Passenger

# Work

# Straight into console-in-screen.
# Assumes there is only one screen running.
alias prodc="ssh anpa -t screen -RD"


