#!/bin/bash

# Utilities

# Watch command for Mac
# usage: watch <your_command> <sleep_duration>
function watch() {
	while :;
		do
		clear;
		echo "$(date)"

		echo $1;
		#$1;
		sleep $2;
	done
}
function watch_sync() {
	while :;
		do
		clear;
		echo "$(date)"
		#echo $1;
		rsync -azv $1 $2;
		sleep 5;
	done
}


vagrant_up() {

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
function gulpstart() {

	cd ${vagrant_boxes[$1]}/site && gulp

}

function is_yes() {


	if [ ${$1} = "yes" ]; then

		return 1

	fi

	return 0;
}

# SSH functions


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

function vagrantsuspendall() {
	echo "Suspending all running VMs:"
	vboxmanage list runningvms

	vboxmanage list runningvms | sed -E 's/.*\{(.*)\}/\1/' | xargs -L1 -I {} VBoxManage controlvm {} savestate
}

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

function clean_gitignore() {
	git rm --cached `git ls-files -i --exclude-from=.gitignore`
}

