#!/bin/bash

# Documentation
# TODO WIP
function dotcomands() {
	echo "watch - "
	echo "watch_sync - "
}

# Utilities

# Watch command for Mac
# usage: watch <your_command> <sleep_duration>
# function watch() {
#
# 	command=$1;
# 	sleep=$2;
#
# 	while :;
# 		do
# 		clear;
# 		echo "$(date)"
#
# 		echo "Running command: \"${command}\"";
# 		eval $command;
# 		echo "Sleeping for ${sleep} seconds";
# 		sleep $sleep;
# 	done
# }

# Sync folder every X seconds
# usage: watch_sync <sync from> <sync to> <interval in seconds>
function watchsync() {
	while :;
		do
		cleargit_merge;
		echo "$(date)"
		#echo $1;
		rsync -azv $1 $2;
		sleep $3;
	done
}

# Ups vagrant box and ask if you want to suspend running boxes
function vagrantup() {

	echo "";
	echo "";
	vagrantrunning
	echo "";
	echo "Suspend all running VMs? (y/N) ";
	echo "";

	read REPLY;

	if [[ "$REPLY" = "y" ]]; then

		vagrantsuspendall;
	fi

	echo "Starting ${1}...";
	cd ${vagrant_boxes[$1]}
	#cd ${vagrant_boxes[$1]}/site
	#cd $1;
	#sleep 1;
	vagrant up;

}

# Start gulp in default location
function gulpstart() {

	cd ${vagrant_boxes[$1]}/site && gulp
}

#
function isyes() {

	if [ ${$1} = "yes" ]; then

		return 1

	fi

	return 0;
}

# SSH functions

# Lists all registered (in config.cfg) servers
function listservers() {
	pad=$(printf '%0.1s' "."{1..60})

	padlen=0;

	# Get length of longest key
	for k in "${(@k)ssh_servers}"; do
		if [ ${#k} -gt $padlen ]; then
			padlen=${#k}
		fi
	done

	# Add 3 padding to longest key
	padlen=$padlen+3;

	for k in "${(@k)ssh_servers}"; do
		printf '%s' "ssh${k} "
		printf '%*.*s' 0 $((padlen - ${#k} )) "$pad"
		printf '%s\n' "${ssh_servers[$k]}"
		#${vagrant_boxes[$k]}=${${vagrant_boxes[$k]}:1}
	done
}

# Vagrant functions

# Suspend all running vagrant boxes
function vagrantsuspendall() {
	echo "Suspending all running VMs:"
	VBoxManage list runningvms

	VBoxManage list runningvms | sed -E 's/.*\{(.*)\}/\1/' | xargs -L1 -I {} VBoxManage controlvm {} savestate
}

# List all running vagrant boxes
function vagrantrunning() {
	echo "List of all running VMs:"
	VBoxManage list runningvms
}

function listboxes() {
	pad=$(printf '%0.1s' " "{1..60})

	padlen=0;

	# Get length of longest key
	for k in "${(@k)vagrant_boxes}"; do
		if [ ${#k} > $padlen ]; then
			padlen=${#k}
		fi
	done

	# Add 5 padding to longest key
	padlen=$padlen+5;

	for k in "${(@k)vagrant_boxes}"; do
	     printf '%s' "${k}"
	     printf '%*.*s' 0 $((padlen - ${#k} )) "$pad"
	     printf '%s\n' "${vagrant_boxes[$k]}"
	     #${vagrant_boxes[$k]}=${${vagrant_boxes[$k]}:1}
	done
}

function getsitename() {

	SITE_NAME=$1

	if [[ "$SITE_NAME" = "" ]]; then
		echo -n "Site name (domain_tld): ";
		read SITE_NAME
	fi

	if [[ "$SITE_NAME" = "" ]]; then
		echo "No site name"
		return 1;
	fi
}

# Create new VVV site wizard
function vvvcreate() {

	getsitename;

	echo "Creating site: ${SITE_NAME}"

	echo "Proceed? (Y/n) ";
	echo "";

	read REPLY;

	if [[ "$REPLY" != "n" ]]; then
		#mkdir -p ~/projekt/vvv/www/${SITE_NAME}/repo/site/public
		vv create --webroot repo/site/public --debug --images --remove-defaults --path ~/projekt/vvv -n ${SITE_NAME}
	else
		echo "Aborted"
	fi

}

# Create new VVV site without proxy wizard
function vvvcreatenoproxy() {

	getsitename;

	echo "Creating site: ${SITE_NAME}"
	return 1;

	#mkdir -p ~/projekt/vvv/www/${SITE_NAME}/repo/site/public

	vv create --webroot repo/site/public --debug --remove-defaults --path ~/projekt/vvv -n ${SITE_NAME}
}

function homestead() {
    ( cd ~/Homestead && vagrant $* )
}

# Clean all files from repo that should be ignored
function cleangitignore() {
	git rm --cached `git ls-files -i --exclude-from=.gitignore`
}

function updatewpcli() {
	curl -L https://raw.github.com/wp-cli/builds/gh-pages/phar/wp-cli.phar > wp-cli.phar;
	chmod +x wp-cli.phar;
	which wp | xargs -I {} cp ./wp-cli.phar {};
	wp --version --allow-root;
	rm wp-cli.phar
}

# Update all homebrew casks packages (use with caution)
function upgradeallcasks() {
	#rm -rf "$(brew --cache)"

	brew cask cleanup
	brew update

	#for app in $(brew cask list); do
	for app in $(brew cask outdated); do
		#echo "${app}";
	    brew cask install --force "${app}"
	done
}

# Upload and add ssh key to remote server for key auth
function addmysshkey() {

	REMOTE_HOST=$1

	if [ -z ${REMOTE_HOST} ]; then

		echo "Need to must specify remote host";
		echo "addmysshkey username@remotehost.com";

	else

		cat ~/.ssh/id_rsa.pub | ssh ${REMOTE_HOST} "mkdir -p ~/.ssh; touch ~/.ssh/authorized_keys; cat - >> ~/.ssh/authorized_keys";
		echo "Added!";

	fi
}

# Rsync wizzard (If you can't remember the parameters)
function rsyncw() {

	echo "";
	echo "";
	echo "Rsync step by step Wizzard";
	echo "";

	echo "";
	echo "Specify source. Should end with / if folder (Leave empty for current dir)";
	echo "";

	echo -n "Source:";
	read SOURCE

	if [[ "$SOURCE" = "" ]]; then
		SOURCE="./"
	fi

	echo "";
	echo "Specify destination (Leave empty for current dir)";
	echo "";

	echo -n "Source:";
	read -e DESTINATION

	if [[ "$DESTINATION" = "" ]]; then
		DESTINATION="."
	fi

	echo "";
	echo "Specify options without - (Leave empty for -azP)";
	echo "";

	echo -n "Options:";
	read -e OPTIONS

	if [[ "$OPTIONS" = "" ]]; then
		OPTIONS="azP"
	fi

	echo "";
	echo "";
	echo "rsync -${OPTIONS} \"${SOURCE}\" \"${DESTINATION}\"";
	echo "";
	echo "Proceed? (Y/n) ";
	echo "";

	read REPLY;

	if [[ "$REPLY" != "n" ]]; then

		rsync -${OPTIONS} "${SOURCE}" "${DESTINATION}"

	fi

}

# Work In Progress - Run VMWare box in headless mode
function vmwareheadless() {

	VMRUN_CMD="/Applications/VMware\\ Fusion.app/Contents/Library/vmrun";
	VMX_PATH="/Users/pelmered/projekt/DevEnv/DevEnv.vmx";

	CMD=$1;

	case "$CMD" in
		start)

			echo "${VMRUN_CMD} -T start ${VMX_PATH} nogui";
			${VMRUN_CMD} -T start ${VMX_PATH} nogui

            ;;

		*)

			echo "${VMRUN_CMD} -T ${CMD}  ${VMX_PATH}";
			${VMRUN_CMD} -T ${CMD} ${VMX_PATH}

	esac
}


function composer_require_wpackagist() {

	SLUG=$1;

	composer require wpackagist-plugin/${SLUG}
}

function composer_require_satis_pelmered() {

	SLUG=$1;

	composer require elmered/${SLUG}
}

# Require
function composer_require_premium_components() {

	PACKAGE=$1; # vendor/package-name
	URL=$3;     # https://base-repo-url.com


	composer config repositories.${SLUG} git ${URL}/${PACKAGE}.git

	composer require ${PACKAGE}
}


function composer_update_package() {

	PACKAGE=$1;
	VERSION=$2;

	#if [ -z "$VERSION" ]; then
	#	VERSION="*";
	#fi

	composer remove ${PACKAGE};
	composer require "${PACKAGE}";
	#composer require "${PACKAGE}:${VERSION}";
}


function composer_update_project() {

	echo "";
	echo "!WARNING!";
	echo "!WARNING!";
	echo "";
	echo "This will overwrite you existing version constraints in your composer.json. Please back up your composer.json file before proceeding";
	echo "";
	echo "Proceed? (y/N) ";
	echo "";

	read REPLY;

	if [[ "$REPLY" != "y" ]]; then
		echo "Aborted";
		return 1;
	fi

	composer outdated --direct

	echo "";
	echo "";
	echo "Proceed? (y/N) ";
	echo "";

	read REPLY;

	if [[ "$REPLY" != "y" ]]; then
		echo "Aborted";
		return 1;
	fi

	composer outdated --direct > outdated.txt;

	php ${DOTFILES_PATH}/update-composer-json-version-numbers-to-latest-version.php;

	composer update;
}




function wppluginperformancecheck() {

	SITEURL=$1;

	for p in $(wp plugin list --fields=name --status=active --allow-root)
	do
		echo $p
		wp plugin deactivate $p --allow-root
		for i in {1..5}
		do
			curl -so /dev/null -w "%{time_total}\n" \
			-H "Pragma: no-cache" SITEURL
		done
		wp plugin activate $p --allow-root
	done
}


# Create a new directory and enter it
function mkd() {
	mkdir -p "$@" && cd "$_";
}

# Change working directory to the top-most Finder window location
function cdf() { # short for `cdfinder`
	cd "$(osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)')";
}

# Extract many types of compressed packages
# Credit: http://nparikh.org/notes/zshrc.txt
extract() {
  if [ -f "$1" ]; then
    case "$1" in
      *.tar.bz2)  tar -jxvf "$1"                        ;;
      *.tar.gz)   tar -zxvf "$1"                        ;;
      *.bz2)      bunzip2 "$1"                          ;;
      *.dmg)      hdiutil mount "$1"                    ;;
      *.gz)       gunzip "$1"                           ;;
      *.tar)      tar -xvf "$1"                         ;;
      *.tbz2)     tar -jxvf "$1"                        ;;
      *.tgz)      tar -zxvf "$1"                        ;;
      *.zip)      unzip "$1"                            ;;
      *.ZIP)      unzip "$1"                            ;;
      *.pax)      cat "$1" | pax -r                     ;;
      *.pax.Z)    uncompress "$1" --stdout | pax -r     ;;
      *.Z)        uncompress "$1"                       ;;
      *) echo "'$1' cannot be extracted/mounted via extract()" ;;
    esac
  else
     echo "'$1' is not a valid file to extract"
  fi
}

# Create a .tar.gz archive, using `zopfli`, `pigz` or `gzip` for compression
function targz() {
	local tmpFile="${@%/}.tar";
	tar -cvf "${tmpFile}" --exclude=".DS_Store" "${@}" || return 1;

	size=$(
		stat -f"%z" "${tmpFile}" 2> /dev/null; # macOS `stat`
		stat -c"%s" "${tmpFile}" 2> /dev/null;  # GNU `stat`
	);

	local cmd="";
	if (( size < 52428800 )) && hash zopfli 2> /dev/null; then
		# the .tar file is smaller than 50 MB and Zopfli is available; use it
		cmd="zopfli";
	else
		if hash pigz 2> /dev/null; then
			cmd="pigz";
		else
			cmd="gzip";
		fi;
	fi;

	echo "Compressing .tar ($((size / 1000)) kB) using \`${cmd}\`…";
	"${cmd}" -v "${tmpFile}" || return 1;
	[ -f "${tmpFile}" ] && rm "${tmpFile}";

	zippedSize=$(
		stat -f"%z" "${tmpFile}.gz" 2> /dev/null; # macOS `stat`
		stat -c"%s" "${tmpFile}.gz" 2> /dev/null; # GNU `stat`
	);

	echo "${tmpFile}.gz ($((zippedSize / 1000)) kB) created successfully.";
}

# Determine size of a file or total size of a directory
function fs() {
	if du -b /dev/null > /dev/null 2>&1; then
		local arg=-sbh;
	else
		local arg=-sh;
	fi
	if [[ -n "$@" ]]; then
		du $arg -- "$@";
	else
		du $arg .[^.]* ./*;
	fi;
}

# Use Git’s colored diff when available
hash git &>/dev/null;
if [ $? -eq 0 ]; then
	function diff() {
		git diff --no-index --color-words "$@";
	}
fi;

# Create a data URL from a file
function dataurl() {
	local mimeType=$(file -b --mime-type "$1");
	if [[ $mimeType == text/* ]]; then
		mimeType="${mimeType};charset=utf-8";
	fi
	echo "data:${mimeType};base64,$(openssl base64 -in "$1" | tr -d '\n')";
}

# Start an HTTP server from a directory, optionally specifying the port
function server() {
	local port="${1:-8000}";
	sleep 1 && open "http://localhost:${port}/" &
	# Set the default Content-Type to `text/plain` instead of `application/octet-stream`
	# And serve everything as UTF-8 (although not technically correct, this doesn’t break anything for binary files)
	python -c $'import SimpleHTTPServer;\nmap = SimpleHTTPServer.SimpleHTTPRequestHandler.extensions_map;\nmap[""] = "text/plain";\nfor key, value in map.items():\n\tmap[key] = value + ";charset=UTF-8";\nSimpleHTTPServer.test();' "$port";
}

# Start a PHP server from a directory, optionally specifying the port
# (Requires PHP 5.4.0+.)
function phpserver() {
	local port="${1:-4000}";
	local ip=$(ipconfig getifaddr en1);
	sleep 1 && open "http://${ip}:${port}/" &
	php -S "${ip}:${port}";
}

# Compare original and gzipped file size
function gz() {
	local origsize=$(wc -c < "$1");
	local gzipsize=$(gzip -c "$1" | wc -c);
	local ratio=$(echo "$gzipsize * 100 / $origsize" | bc -l);
	printf "orig: %d bytes\n" "$origsize";
	printf "gzip: %d bytes (%2.2f%%)\n" "$gzipsize" "$ratio";
}

# Syntax-highlight JSON strings or files
# Usage: `json '{"foo":42}'` or `echo '{"foo":42}' | json`
function json() {
	if [ -t 0 ]; then # argument
		python -mjson.tool <<< "$*" | pygmentize -l javascript;
	else # pipe
		python -mjson.tool | pygmentize -l javascript;
	fi;
}

# Run `dig` and display the most useful info
function digga() {
	dig +nocmd "$1" any +multiline +noall +answer;
}

# UTF-8-encode a string of Unicode symbols
function escape() {
	printf "\\\x%s" $(printf "$@" | xxd -p -c1 -u);
	# print a newline unless we’re piping the output to another program
	if [ -t 1 ]; then
		echo ""; # newline
	fi;
}

# Show all the names (CNs and SANs) listed in the SSL certificate
# for a given domain
function getcertnames() {
	if [ -z "${1}" ]; then
		echo "ERROR: No domain specified.";
		return 1;
	fi;

	local domain="${1}";
	echo "Testing ${domain}…";
	echo ""; # newline

	local tmp=$(echo -e "GET / HTTP/1.0\nEOT" \
		| openssl s_client -connect "${domain}:443" -servername "${domain}" 2>&1);

	if [[ "${tmp}" = *"-----BEGIN CERTIFICATE-----"* ]]; then
		local certText=$(echo "${tmp}" \
			| openssl x509 -text -certopt "no_aux, no_header, no_issuer, no_pubkey, \
			no_serial, no_sigdump, no_signame, no_validity, no_version");
		echo "Common Name:";
		echo ""; # newline
		echo "${certText}" | grep "Subject:" | sed -e "s/^.*CN=//" | sed -e "s/\/emailAddress=.*//";
		echo ""; # newline
		echo "Subject Alternative Name(s):";
		echo ""; # newline
		echo "${certText}" | grep -A 1 "Subject Alternative Name:" \
			| sed -e "2s/DNS://g" -e "s/ //g" | tr "," "\n" | tail -n +2;
		return 0;
	else
		echo "ERROR: Certificate not found.";
		return 1;
	fi;
}

# `s` with no arguments opens the current directory in Sublime Text, otherwise
# opens the given location
function sublime() {
	if [ $# -eq 0 ]; then
		subl .;
	else
		subl "$@";
	fi;
}

# `v` with no arguments opens the current directory in Vim, otherwise opens the
# given location
function vim() {
	if [ $# -eq 0 ]; then
		vim .;
	else
		vim "$@";
	fi;
}

# `p` with no arguments opens the current directory in PHPStorm, otherwise opens the given location
# For this to work you need to create a launcher in you PATH: "Tools -> Create Command-line Launcher..."
function phpstorm() {
	if [ $# -eq 0 ]; then
		open -a pstorm .;
	else
		open -a pstorm "$@";
	fi;
}

# `o` with no arguments opens the current directory, otherwise opens the given
# location
function o() {
	if [ $# -eq 0 ]; then
		open .;
	else
		open "$@";
	fi;
}

# `tre` is a shorthand for `tree` with hidden files and color enabled, ignoring
# the `.git` directory, listing directories first. The output gets piped into
# `less` with options to preserve color and line numbers, unless the output is
# small enough for one screen.
function tre() {
	tree -aC -I '.git|node_modules|bower_components' --dirsfirst "$@" | less -FRNX;
}


###############
#
# USAGE:
#
# Will merge current branch into master. If you are in master it will ask for branch to merge into master
# git_merge_branch
#
# Specify source branch for merge. Target will be master
# git_rebase_branch <source branch>
#
# Specify source and target branch for merge
# git_merge_branch <source branch> <target branch>
#
###############
function git_merge_branch() {

	CURRENT_BRANCH=$2;
	TARGET_BRANCH=$1;

	#if (( ! ${+CURRENT_BRANCH} )); then
	if [[ -z $CURRENT_BRANCH ]]; then
		CURRENT_BRANCH=$(git_current_branch);
	fi

	#if (( ! ${+TARGET_BRANCH} )); then
	if [[ -z $TARGET_BRANCH ]]; then
		TARGET_BRANCH="master";
	fi

	if [[ -z $CURRENT_BRANCH ]] || [[ "${CURRENT_BRANCH}" = "master" ]]; then
		#echo $CURRENT_BRANCH;
		echo -n "Specify Git branch to merge: ";
		read CURRENT_BRANCH
	fi

	echo "";
	echo "Merging ${CURRENT_BRANCH} into ${TARGET_BRANCH}"
	echo "Proceed? (Y/n) ";
	echo "";

	read REPLY;

	if [[ "$REPLY" != "n" ]]; then
		git checkout ${TARGET_BRANCH} && git pull origin ${TARGET_BRANCH} && git merge --no-ff ${CURRENT_BRANCH} && echo "Merge done"
	else
		echo "Aborted"
	fi

}

###############
#
# USAGE:
#
# Will rebase master into current branch. If you are in master it will ask for branch to rebase to
# git_rebase_branch
#
# Specify source branch for rebase. Target will be master
# git_rebase_branch <source branch>
#
# Specify source and target branch for rebase
# git_rebase_branch <source branch> <target branch>
#
###############
function git_rebase_branch() {

	CURRENT_BRANCH=$1;
	TARGET_BRANCH=$2;

	if [[ -z $CURRENT_BRANCH ]]; then
		CURRENT_BRANCH=$(git_current_branch);
	fi
	if [[ -z $TARGET_BRANCH ]]; then
		TARGET_BRANCH="master";
	fi

	if [[ -z $CURRENT_BRANCH ]] || [[ "${CURRENT_BRANCH}" = "master" ]]; then
		#echo $CURRENT_BRANCH;
		echo -n "Specify Git branch to rebase: ";
		read CURRENT_BRANCH
	fi

	echo "";
	echo "Rebasing ${CURRENT_BRANCH} from ${TARGET_BRANCH}"
	echo "Proceed? (Y/n) ";
	echo "";
	read -p "Proceed? (y/N) " yn

	echo "reply"
	echo $REPLY;

	if [[ "$REPLY" != "n" ]]; then
		git checkout ${TARGET_BRANCH} && git pull origin ${TARGET_BRANCH} && git checkout ${CURRENT_BRANCH} && git rebase ${TARGET_BRANCH} && echo "Rebase done"
	else
		echo "Aborted"
	fi
}


function copy_database() {
	mysql --execute="CREATE DATABASE $2" && mysqldump $1 | mysql $2
}
