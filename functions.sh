
# Utilities

# Watch command for Mac
# usage: watch <your_command> <sleep_duration>
function watch() {
	while :;
		do
		clear;
		echo "$(date)"
		$1;
		sleep $2;
	done
}

function gulpstart() {

	cd ${vagrant_boxes[$1]}/site && gulp

}

# Vagrant functions

function vagrantsuspendall() {

	echo "Suspending all running VMs:"
	vboxmanage list runningvms

	vboxmanage list runningvms | sed -E 's/.*\{(.*)\}/\1/' | xargs -L1 -I {} VBoxManage controlvm {} savestate
}



