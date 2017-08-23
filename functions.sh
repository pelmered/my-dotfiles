#!/bin/bash


function dotcomands() {

	echo "watch - "
	echo "watch_sync - "

}


# Utilities

# Watch command for Mac
# usage: watch <your_command> <sleep_duration>
function watch() {
	while :;
		do
		clear;
		echo "$(date)"

		echo $1;
		eval $1;
		sleep $2;
	done
}

# Sync folder every X seconds
# usage: watch_sync <sync from> <sync to> <interval in seconds>
function watch_sync() {
	while :;
		do
		clear;
		echo "$(date)"
		#echo $1;
		rsync -azv $1 $2;
		sleep $3;
	done
}

# Ups vagrant box and ask if you want to suspend running boxes
function vagrant_up() {

	echo "";
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
function is_yes() {

	if [ ${$1} = "yes" ]; then

		return 1

	fi

	return 0;
}

# SSH functions

# Lists all registered (in config.cfg) servers
function list_servers() {
	pad=$(printf '%0.1s' " "{1..60})

	padlen=0;

	# Get length of longest key
	for k in "${(@k)ssh_servers}"; do
		if [ ${#k} > $padlen ]; then
			padlen=${#k}
		fi
	done

	# Add 5 padding to longest key
	padlen=$padlen+5;

	for k in "${(@k)ssh_servers}"; do
		printf '%s' "ssh${k}"
		printf '%*.*s' 0 $((padlen - ${#k} )) "$pad"
		printf '%s\n' "${ssh_servers[$k]}"
		#${vagrant_boxes[$k]}=${${vagrant_boxes[$k]}:1}
	done
}

# Vagrant functions

# Suspend all running vagrant boxes
function vagrantsuspendall() {
	echo "Suspending all running VMs:"
	vboxmanage list runningvms

	vboxmanage list runningvms | sed -E 's/.*\{(.*)\}/\1/' | xargs -L1 -I {} VBoxManage controlvm {} savestate
}

# List all running vagrant boxes
function vagrantrunning() {
	echo "List of all running VMs:"
	vboxmanage list runningvms
}

function list_boxes() {
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
function clean_gitignore() {
	git rm --cached `git ls-files -i --exclude-from=.gitignore`
}

function update_wpcli() {
	curl -L https://raw.github.com/wp-cli/builds/gh-pages/phar/wp-cli.phar > wp-cli.phar;
	chmod +x wp-cli.phar;
	which wp | xargs -I {} cp ./wp-cli.phar {};
	wp --version --allow-root;
	rm wp-cli.phar
}

# Update all homebrew casks packages (use with caution)
function upgrade_all_casks() {
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

# Require
function composer_require_ac_premium_components() {

	SLUG=$1;

	composer config repositories.${SLUG} git https://git.synotio.se/ac-premiumcomponents/${SLUG}.git

	composer require ac-premiumcomponents/${SLUG}
}


function composer_update_package() {

	PACKAGE=$1;
	VERSION=$2;

	if [ -z "$VERSION" ]; then
		VERSION="*";
	fi

	composer remove ${PACKAGE};
	composer require "${PACKAGE}:${VERSION}";
}

function wp_plugin_performance_check() {

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