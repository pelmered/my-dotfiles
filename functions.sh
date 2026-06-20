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

#function watch() {
#
#  command=$1;
#  sleep=$2;
#
#  while :;
#  do
#  clear;
#    echo "$(date)"
#
#    echo "Running command: \"${command}\"";
#    eval $command;
#    echo "Sleeping for ${sleep} seconds";
#    sleep $sleep;
#  done
#}


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
#function vim() {
#	if [ $# -eq 0 ]; then
#		vim .;
#	else
#		vim "$@";
#	fi;
#}


# `p` with no arguments opens the current directory in PHPStorm, otherwise opens the given location
# For this to work you need to create a launcher in you PATH: "Tools -> Create Command-line Launcher..."
function phpstorm() {
	if [ $# -eq 0 ]; then
		open -a /Applications/PhpStorm.app .;
	else
		open -a /Applications/PhpStorm.app "$@";
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


function commit() {
   commitMessage="$*"

   #git add .

   if [ "$commitMessage" = "" ]; then
      aicommits
      return
   fi

   eval "git commit -m '${commitMessage}'"
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
    TARGET_BRANCH=$(get_dot_config ".git.${PWD}.branches.main" ".git.default.branches.main");
	fi

	if [[ -z $TARGET_BRANCH ]] || [[ "${TARGET_BRANCH}" = "" ]]; then
		TARGET_BRANCH="master";
	fi

	if [[ -z $CURRENT_BRANCH ]] || [[ "${CURRENT_BRANCH}" = "master" ]]; then
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
# Will create a new branch from main.
#
# Specify name for new branch. Source will be main
# git_new_branch <new branch name>
#
# Specify source and target branch for merge
# git_new_branch <new branch name> <source branch>
#
###############
function git_new_branch() {
	SOURCE_BRANCH=$2;
	NEW_BRANCH_NAME=$1;

  if [[ -z $CURRENT_BRANCH ]]; then
    CURRENT_BRANCH=$(git_current_branch);
  fi

	if [[ -z $SOURCE_BRANCH ]]; then
    SOURCE_BRANCH=$(get_dot_config ".git.${PWD}.branches.main" ".git.default.branches.main");
	fi

	if [[ -z $CURRENT_BRANCH ]] || [[ "${CURRENT_BRANCH}" = "${SOURCE_BRANCH}" ]]; then
      "Already on source branch (${SOURCE_BRANCH})"
      git pull origin ${SOURCE_BRANCH}
      gco -b ${NEW_BRANCH_NAME}
    else
      gco ${SOURCE_BRANCH}
      git pull origin ${SOURCE_BRANCH}
      gco -b ${NEW_BRANCH_NAME}
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



function valet_start() {
  echo "Starting valet services...";
  valet start;

  echo "Starting additional services...";

  for valet_service in ${valet_services[@]}; do
    brew services start $valet_service;
  done
}

function valet_stop() {
  echo "Stopping valet services...";
  valet stop;

  echo "Stopping additional services...";

  for valet_service in ${valet_services[@]}; do
    brew services stop $valet_service;
  done
}

function valet_restart() {
  valet_stop;
  valet_start;
}

function herd_start() {
  echo "Starting valet services...";
  herd start;

  echo "Starting additional services...";

  serviceList=($(yq -o=a -I=0 '.herd.additional_services' ${DOTFILES_PATH}/config.yaml ))

  for herd_service in ${serviceList};
  do
    brew services start $herd_service;
  done
}

function herd_stop() {
  echo "Stopping valet services...";
  herd stop;

  echo "Stopping additional services...";

  serviceList=($(yq -o=a -I=0 '.herd.additional_services' ${DOTFILES_PATH}/config.yaml ))



  for herd_service in ${serviceList};
  do
    brew services stop $herd_service;
  done
}

function herd_restart() {
  herd_stop;
  herd_start;
}


function gitpullall() {

	for branch in $(git branch)
	do
		echo $branch
		echo "git pull origin ${branch}"
		git pull origin ${branch}
	done
}

function gitpushall() {

	for branch in $(git branch)
	do
		echo $branch

		echo "SKIP_POST_CHECKOUT=1 git checkout ${branch}"

		SKIP_POST_CHECKOUT=1 git checkout ${branch}

		echo "git pull origin ${branch}"
		echo "git push origin ${branch}"

		git pull origin ${branch} --no-verify
		git push origin ${branch} --no-verify

		sleep 5;
	done
}


function create_ssh_aliases() {
  serverList=($(yq -o=a -I=0 '.ssh.servers' ${DOTFILES_PATH}/config.yaml ))

  #echo $identityMappings;

  cur=""
  host=""
  user=""
  host_key=""

  # declare -A ssh_servers_array
  typeset -A ssh_servers

  for k in ${serverList}; do

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


}

function list_ssh_servers() {

  echo "---------------"
  echo "| SSH Servers | "
  echo "---------------"

	pad=$(printf '%0.1s' "."{1..60})

	padlen=0;

	# Get length of longest key
	for k in ${(@k)ssh_servers}; do
		if [ ${#k} -gt $padlen ]; then
			padlen=${#k}
		fi
	done

	# Add 3 padding to longest key
	padlen=$padlen+3;

	for k in ${(@k)ssh_servers}; do
		printf '%s' "ssh${k} "
		printf '%*.*s' 0 $((padlen - ${#k} )) "$pad"
		printf '%s\n' "${ssh_servers[$k]}"
		#${vagrant_boxes[$k]}=${${vagrant_boxes[$k]}:1}
	done

}

function git_resign_commits() {
  COMMIT_HASH=$1;

	if [[ -z COMMIT_HASH ]]; then
	  echo "You need to provide a commit hash"
	  return;
	fi

  #gpg --list-secret-keys --keyid-format=long
  #git config --global user.signingkey <your key>
  git rebase --exec 'git commit --amend --no-edit -n -S' -i ${COMMIT_HASH}

}

function mysql_import() {

  # Usage: mysql_import <path_to_sql_file.sql> "mysql -u <username> -p <database_name> -h <host>"

  pv cat ${DOTFILES_PATH}/scripts/pre-mysql-import.sql \
      $1 \
      ${DOTFILES_PATH}/scripts/post-mysql-import.sql \
  | mysql "${*:2}"

  echo ""
  echo "Import complete!"
  echo ""
}

# Git worktree function to create new feature branches and open in Windsurf
wt() {
    # Parse arguments: first positional is the feature name; flags are order-independent.
    local feature_name=""
    local open_editor=true
    local run_install=true
    local run_build=true
    local do_herd=true
    local setup_errors=()
    for arg in "$@"; do
        case "$arg" in
            --no-open|--no-editor|-n) open_editor=false ;;
            --no-install|--no-deps)   run_install=false; run_build=false ;;
            --no-build)               run_build=false ;;
            --no-herd|--no-link)      do_herd=false ;;
            -*) echo "Unknown option: $arg"; return 1 ;;
            *)  [ -z "$feature_name" ] && feature_name="$arg" ;;
        esac
    done

    if [ -z "$feature_name" ]; then
        echo "Usage: wt <feature-name> [--no-open] [--no-install] [--no-build] [--no-herd]"
        echo "  wt my-feature            # worktree + deps + 'herd link --secure' + open editor"
        echo "  wt my-feature --no-open  # same, but don't open the editor (scripts/agents)"
        echo "  Editor override: WT_EDITOR=cursor wt my-feature"
        return 1
    fi

    # Check if we're in a git worktree
    if git rev-parse --is-inside-work-tree &>/dev/null && git worktree list &>/dev/null; then
        # Get the main worktree path (first line of git worktree list)
        local main_worktree=$(git worktree list | head -n 1 | awk '{print $1}')
        local current_project=$(basename "$main_worktree")
        local parent_dir=$(dirname "$main_worktree")
    else
        # Fallback to current directory name and parent directory if not in git or not a worktree
        local current_project=$(basename "$PWD")
        local parent_dir=$(dirname "$PWD")
    fi

    local project_path="${parent_dir}/${current_project}"

    # Create the worktrees folder name by appending '-worktrees' to current project name
    local worktrees_folder="${current_project}-worktrees"

    # Create the full path to the worktrees folder (adjacent to current project)
    local worktrees_path="${parent_dir}/${worktrees_folder}"

    # Create the worktrees folder if it doesn't exist
    if [ ! -d "$worktrees_path" ]; then
        echo "Creating worktrees folder: $worktrees_path"
        mkdir -p "$worktrees_path"
    fi

    # Create the full path for the new feature worktree
    local feature_path="${worktrees_path}/${feature_name}"

    # Git stores branches as files under refs/heads, so a branch named
    # 'feature' cannot coexist with 'feature/...'. Detect that collision up
    # front and explain it instead of failing deep inside 'git worktree add'.
    if git rev-parse --is-inside-work-tree &>/dev/null; then
        local nested_branches=$(git for-each-ref --format='%(refname:short)' "refs/heads/${feature_name}/" 2>/dev/null)
        if [ -n "$nested_branches" ]; then
            echo "Error: can't create branch '$feature_name' — these branches already live under '$feature_name/':"
            echo "$nested_branches" | sed 's/^/  /'
            echo "Pick a different name (git can't have both a branch '$feature_name' and '$feature_name/...')."
            return 1
        fi
    fi

    # Check if the feature worktree already exists
    if [ -d "$feature_path" ]; then
        echo "Worktree for '$feature_name' already exists at: $feature_path"
        echo "Re-running setup for existing worktree..."
    else
        # Check if branch already exists
        if git show-ref --verify --quiet "refs/heads/$feature_name"; then
            # Branch exists, create worktree from existing branch
            echo "Creating worktree from existing branch: $feature_name"
            git worktree add "$feature_path" "$feature_name" --no-checkout
        else
            # Branch doesn't exist, create new branch and worktree
            echo "Creating new worktree and branch: $feature_name"
            git worktree add -b "$feature_name" "$feature_path" --no-checkout
        fi

        # Abort if 'git worktree add' failed (e.g. branch-name conflict) so we
        # don't cascade into a failed cd/checkout in the wrong directory.
        if [ ! -d "$feature_path" ]; then
            echo "Failed to create worktree. Make sure you're in a git repository."
            return 1
        fi
    fi

    # Checkout the branch without running hooks
    cd "$feature_path"
    git -c core.hooksPath=/dev/null checkout "$feature_name"
    cd - > /dev/null

    echo "Successfully created worktree: $feature_path"

    # Symlink shared directories from main worktree (if they exist)
    # Directories without git-tracked files are symlinked entirely.
    # Directories with tracked files: only untracked items are symlinked
    # so git can manage tracked files independently per branch.
    local shared_dirs=(".ai" ".chief" ".claude" "docs/features" "docs/prototypes" "storage/app")
    for dir in "${shared_dirs[@]}"; do
        if [ -d "$project_path/$dir" ]; then
            mkdir -p "$feature_path/$(dirname "$dir")"
            local tracked_files=$(cd "$project_path" && git ls-files "$dir" 2>/dev/null)
            if [ -z "$tracked_files" ]; then
                # No tracked files - symlink the entire directory
                rm -rf "$feature_path/$dir"
                ln -s "$project_path/$dir" "$feature_path/$dir"
                echo "Symlinked $dir/"
            else
                # Has tracked files - only symlink untracked items
                mkdir -p "$feature_path/$dir"
                for item in "$project_path/$dir"/*(N) "$project_path/$dir"/.*(N); do
                    [ -e "$item" ] || continue
                    local item_name=$(basename "$item")
                    [[ "$item_name" == "." || "$item_name" == ".." ]] && continue
                    local item_tracked=$(cd "$project_path" && git ls-files "$dir/$item_name" 2>/dev/null)
                    if [ -z "$item_tracked" ]; then
                        rm -rf "$feature_path/$dir/$item_name"
                        ln -s "$item" "$feature_path/$dir/$item_name"
                        echo "Symlinked $dir/$item_name"
                    fi
                done
            fi
        fi
    done

    # Copy .env file if it exists
    if [ -f "$project_path/.env" ]; then
      cp "$project_path/.env" "$feature_path/.env"
      echo "Copied .env into workspace"

      cp "$feature_path/.env" "$feature_path/.env.backup"
      sed -i.bak "s|^APP_URL=.*|APP_URL=http://${feature_name}.test|" "$feature_path/.env"
      sed -i.bak "s|^APP_DOMAIN=.*|APP_DOMAIN=${feature_name}.test|" "$feature_path/.env"
    else
      echo "No .env found in workspace"
      echo $project_path
    fi

    cd $feature_path

    # Run composer install if there is a composer.json file
    if [ "$run_install" = true ] && [ -f "$feature_path/composer.json" ]; then
      echo "Installing composer dependencies..."
      if composer install -q; then
        echo "Composer Dependencies installed!"
      else
        echo "⚠ composer install FAILED"
        setup_errors+=("composer install — fix: (cd $feature_path && composer install)")
      fi
    elif [ "$run_install" = false ]; then
      echo "Skipped composer install (--no-install)"
    else
      echo "No composer.json found in workspace"
    fi

    if [ "$run_install" = true ] && [ -f "$feature_path/package.json" ]; then
      echo "Installing NPM dependencies..."
      if npm install --silent; then
        if [ "$run_build" = true ]; then
          echo "Building..."
          if npm run --silent build &> '/dev/null'; then
            echo "NPM Dependencies installed & built!"
          else
            echo "⚠ npm run build FAILED"
            setup_errors+=("npm build — fix: (cd $feature_path && npm run build)")
          fi
        else
          echo "NPM Dependencies installed (skipped build, --no-build)"
        fi
      else
        echo "⚠ npm install FAILED"
        setup_errors+=("npm install — fix: (cd $feature_path && npm install && npm run build)")
      fi
    elif [ "$run_install" = false ]; then
      echo "Skipped npm install/build (--no-install)"
    else
      echo "No package.json found in workspace"
    fi

   mkdir -p $feature_path/storage/framework/cache


    # Link + secure the site in Herd. The wildcard cert/server_name (*.{name}.test)
    # this creates covers every subdomain (wellness., advisor., admin., ...) in one shot.
    if [ "$do_herd" = true ]; then
        if command -v herd &>/dev/null; then
            echo "Linking site in Herd (herd link $feature_name --secure)..."
            if herd link "$feature_name" --secure; then
                echo "Site secured at https://${feature_name}.test (and *.${feature_name}.test)"
            else
                echo "⚠ herd link FAILED"
                setup_errors+=("herd link — fix: (cd $feature_path && herd link $feature_name --secure)")
            fi
        else
            echo "Note: 'herd' not found in PATH — skipping site link"
        fi
    else
        echo "Skipped Herd link (--no-herd)"
    fi

    # Open the worktree in the editor (default phpstorm; override with $WT_EDITOR). Skip with --no-open.
    if [ "$open_editor" = true ]; then
        local editor_cmd="${WT_EDITOR:-phpstorm}"
        echo "Opening $feature_path in ${editor_cmd}..."
        if "$editor_cmd" "$feature_path"; then
            echo "Editor opened successfully!"
        else
            echo "Note: couldn't open '$editor_cmd'. Open manually: $feature_path"
        fi
    else
        echo "Skipped opening editor (--no-open)"
    fi

    echo "Access the branch at http://${feature_name}.test"

    # Worktree is fully wired even if a dependency step failed — report the recoverable
    # bits (idempotent re-runs) at the end and exit non-zero so callers can detect it.
    if [ ${#setup_errors[@]} -gt 0 ]; then
        echo ""
        echo "⚠ Worktree created, but ${#setup_errors[@]} setup step(s) failed — worktree is usable, just re-run:"
        for e in "${setup_errors[@]}"; do
            echo "  • $e"
        done
        return 1
    fi
}

wtr() {
    # Check if we're in a git repository
    if ! git rev-parse --is-inside-work-tree &>/dev/null; then
        echo "Error: Not in a git repository"
        return 1
    fi

    local target_name="$1"

    # Get the main worktree path (first line of git worktree list)
    local main_worktree=$(git worktree list | head -n 1 | awk '{print $1}')
    local worktree_path

    if [ -n "$target_name" ]; then
        # Named mode: resolve the worktree path under the worktrees folder used by 'wt'
        local current_project=$(basename "$main_worktree")
        local parent_dir=$(dirname "$main_worktree")
        local worktrees_path="${parent_dir}/${current_project}-worktrees"
        worktree_path="${worktrees_path}/${target_name}"

        if [ ! -d "$worktree_path" ]; then
            echo "Error: Worktree '$target_name' not found at: $worktree_path"
            return 1
        fi
    else
        # Current-worktree mode: must not be the main worktree
        local current_path=$(pwd)
        if [ "$current_path" = "$main_worktree" ]; then
            echo "Error: You are in the main worktree, not a feature worktree"
            echo "Use this command from within a worktree created by 'wt'"
            echo "Or specify a worktree name: wtr <name>"
            return 1
        fi
        worktree_path=$(git rev-parse --show-toplevel)
    fi

    local worktree_name=$(basename "$worktree_path")
    local current_branch=$(git -C "$worktree_path" rev-parse --abbrev-ref HEAD)
    local has_warnings=false

    echo "Removing worktree: $worktree_name"
    echo "Path: $worktree_path"
    echo ""

    # Check for uncommitted changes
    local uncommitted_files=$(git -C "$worktree_path" status --porcelain)
    if [ -n "$uncommitted_files" ]; then
        has_warnings=true
        echo "WARNING: You have uncommitted changes:"
        echo "─────────────────────────────────────"
        git -C "$worktree_path" status --short
        echo ""
    fi

    # Prompt for confirmation if there are uncommitted changes
    if [ "$has_warnings" = true ]; then
        echo "These changes will be LOST if you continue!"
        echo -n "Are you sure you want to remove this worktree? [y/N] "
        read -k 1 REPLY
        echo ""
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "Aborted."
            return 1
        fi
    fi

    # Push any commits before removing
    echo "Pushing '$current_branch' to remote..."
    git -C "$worktree_path" push -u origin "$current_branch" 2>/dev/null || git -C "$worktree_path" push origin "$current_branch"

    # Change to main worktree first (required before removing if we were inside the target)
    cd "$main_worktree"

    # Remove the worktree (--force to remove even with changes)
    if git worktree remove "$worktree_path" --force; then
        echo "Successfully removed worktree: $worktree_name"

        # Prune any stale worktree references
        git worktree prune

        echo "Returned to main project: $main_worktree"
    else
        echo "Error: Failed to remove worktree"
        return 1
    fi
}

git_fetch_and_checkout() {
  BRANCH_NAME=$1;

  if [[ -z $BRANCH_NAME ]]; then
    echo "You need to provide a branch name"
    return;
  fi

  git fetch origin ${BRANCH_NAME} && git checkout ${BRANCH_NAME} && git pull origin ${BRANCH_NAME};
}
