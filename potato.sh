#!/bin/bash

WORK=25
PAUSE=5
INTERACTIVE=true
MUTE=false
METRONOME=false

show_help() {
	cat <<-END
		usage: potato [-s] [-m] [-t] [-w m] [-b m] [-h]
		    -s: simple output. Intended for use in scripts
		        When enabled, potato outputs one line for each minute, and doesn't print the bell character
		        (ascii 007)

		    -m: mute -- don't play sounds when work/break is over
		    -t: enable metronome during work sessions (60 BPM)
		    -w m: let work periods last m minutes (default is 25)
		    -b m: let break periods last m minutes (default is 5)
		    -h: print this message
	END
}

play_notification() {
	paplay --volume=32768 /usr/lib/potato/notification.wav &
}

play_metronome() {
	local work_minutes=$1
	# Metronome clip is 60 seconds, loop it for work_minutes times
	# Use setsid to create a new process group so we can kill all children
	setsid bash -c "
		for ((i=0; i<$work_minutes; i++)); do
			paplay --volume=32768 /usr/lib/potato/metronome.wav
		done
	" &
	echo $! > /tmp/potato_metronome.pid
}

stop_metronome() {
	if [ -f /tmp/potato_metronome.pid ]; then
		local pid=$(cat /tmp/potato_metronome.pid)
		# Kill the entire process group (negative PID)
		kill -- -$pid 2>/dev/null
		# Also kill any remaining paplay processes playing metronome
		pkill -f "paplay.*metronome.wav" 2>/dev/null
		rm -f /tmp/potato_metronome.pid
	fi
}

while getopts :sw:b:mt opt; do
	case "$opt" in
	s)
		INTERACTIVE=false
	;;
	m)
		MUTE=true
	;;
	w)
		WORK=$OPTARG
	;;
	b)
		PAUSE=$OPTARG
	;;
	t)
		METRONOME=true
	;;
	h|\?)
		show_help
		exit 1
	;;
	esac
done

time_left="%im left of %s "

if $INTERACTIVE; then
	time_left="\r$time_left"
else
	time_left="$time_left\n"
fi

# Cleanup function for metronome process
cleanup() {
	stop_metronome
	exit 0
}

# Set trap to cleanup on script exit
trap cleanup EXIT INT TERM

while true
do
	# Start metronome if enabled
	if $METRONOME; then
		play_metronome $WORK
	fi

	for ((i=$WORK; i>0; i--))
	do
		printf "$time_left" $i "work"
		sleep 1m
	done

	# Stop metronome when work session ends
	if $METRONOME; then
		stop_metronome
	fi

	! $MUTE && play_notification
	if $INTERACTIVE; then
		read -d '' -t 0.001
		echo -e "\a"
		echo "Work over"
		read
	fi

	for ((i=$PAUSE; i>0; i--))
	do
		printf "$time_left" $i "pause"
		sleep 1m
	done

	! $MUTE && play_notification
	if $INTERACTIVE; then
		read -d '' -t 0.001
		echo -e "\a"
		echo "Pause over"
		read
	fi
done
