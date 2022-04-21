#!/bin/ksh

Batt() {
	ADAPTER=$(apm -a)
	BATTERY=$(apm -l)
	if [ $ADAPTER = 1 ] ; then
		echo -n " $BATTERY%"
	else
		if [ $BATTERY -ge 76 ] ; then
			echo -n " $BATTERY%"
		elif [ $BATTERY -ge 51 ] && [ $BATTERY -le 75 ] ; then
			echo -n " $BATTERY%"
		elif [ $BATTERY -ge 26 ] && [ $BATTERY -le 50 ] ; then
			echo -n " $BATTERY%"
		elif [ $BATTERY -ge 6 ] && [ $BATTERY -le 25 ] ; then
			echo -n " $BATTERY%"
		elif [ $BATTERY -ge 0 ] && [ $BATTERY -le 5 ] ; then
			echo -n " $BATTERY%"
		else
			echo -n "$BATTERY%"
		fi
	fi
}

Cal() {
	DATE1=$(date "+%a %b %d %T")
	echo -n " $DATE1"
}

Volume() {
	MUTE=$(mixerctl outputs.master.mute | awk -F '=' '{ print $2 }')
	LSPK=$(($(mixerctl outputs.master | awk -F '(=|,)' '{ print $2 }')*100/255))
	if [ "$MUTE" = "on" ] ; then
		echo -n " $LSPK%"
	else
		echo -n " $LSPK%"
	fi
}

Interface() {
	ACTIVE=$(ifconfig | pcregrep -M -o '^[^\t:]+:([^\n]|\n\t)*status: active' | awk -F ":" '/RUNNING/ { print $1 }')
	if [ "$ACTIVE" = "em0" ] ; then
		echo -n " "
	else
		echo -n " "
	fi
}


while true ; do
	xsetroot -name "$(Volume) $(Batt) $(Cal) $(Interface)"
	sleep 1
done &
