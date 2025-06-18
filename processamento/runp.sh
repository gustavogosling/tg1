#!/bin/bash
## ## ## ##

##
# Run Parallel is a SHELL script able to split a list of
# comands into many cores and chunks.
#
# Bianchi @ 2018 / v. 1.0 (2019-11-8)
##

function cleanup() {
	echo ""
	echo "Clearing All!"
	echo ""
	killall $pidlist > /dev/null 2>&1
	if [ -d "$tmp" -a $KEEP -eq 1 ];then
		(
		for f in $(ls -1 2> /dev/null $tmp/LOG.CHUNKS.* | sort)
		do
			echo "-- LOG From: $f"
			cat $f
			echo "-- End"
		done
		) | gzip > LOG-RUN-$(date +%Y-%m-%dT%H:%M:%S).runplog.gz
	fi
	rm -rf "$tmp"
	echo ""
	
	exit
}

#
## Prepare traps
#

trap cleanup SIGINT
trap cleanup SIGSTOP

#
## Create a temporary folder and accumulate lines of code
#

export tmp=$(mktemp -d)
[ -z "$tmp" ] && cleanup
cat > $tmp/ALL
TF=$(cat $tmp/ALL | wc -l)

#
## Prepare cores and files
#
NCORE=$(grep "processor" /proc/cpuinfo | wc -l)
NCHUNKS=$(grep "processor" /proc/cpuinfo | wc -l)
KEEP=1

if [ "$1" == "-h" ]; then
	cat  << EOF
Usage: cat CMDS | runp.sh [-h|-nk] [NCHUNKS] [NCORE]
	
	-nk :: dont create the gziped log file in current dir.
	
	NCHUNKS is number of chunks split (>NCORE)
	NCORE   is number of cores to use
EOF

	cleanup
fi

[ "$1" == "-nk" ] && KEEP=0 && shift
[ ! -z "$1" ] && NCHUNKS=$1 && shift
[ ! -z "$1" ] && NCORE=$1 && shift

export KEEP

#
## Split into chunks the list of files
#
split -n r/$NCHUNKS $tmp/ALL $tmp/CHUNKS.

echo ""
echo "Debug :: NCORE=$NCORE, NCHUNKS=$NCHUNKS"
wc -l $tmp/CHUNKS.* | awk '{print " "$0}'
echo ""
echo -n "Ctrl-c to stop (5s):"
for i in $(seq 5); do sleep 1; echo -n "."; done
echo ""

#
## Run in paralel every NCORE parallel commands
#
echo "Starting @ $(date)"
t0=$(date +"%s.%3N")
while :
do
	ct=0
	export pidlist=""
	for f in $tmp/CHUNKS.*
	do
		n=$(basename $f)
		[ -f $tmp/LOG.$n ] && continue
		[ $ct -eq $NCORE ] && break
		echo "Running $f"
		bash $f > $tmp/LOG.$n 2>&1 &
		export pidlist="$pidlist $!"
		ct=$(( ct + 1 ))
	done
	[ -z "$pidlist" ] && break

	#
	## Wait
	#
	echo "Waiting for ... $pidlist"
	wait $pidlist
done
t1=$(date +"%s.%3N")
echo "End @ $(date)"
echo "Output is @ $tmp"
echo "$t0 $t1" | awk '{print "Total time was",$2-$1}'

cleanup
