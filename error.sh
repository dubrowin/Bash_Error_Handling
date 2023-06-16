#!/bin/bash

ERROR="/tmp/$( basename "$0" ).$$.error"

trap 'error_handler $? $LINENO' ERR

Debug () {
        if [ "$DEBUG" == "Y" ]; then
                if [ ! -z "$CRON" ]; then
                        # Cron, output only to log
                        #echo -e "$( date +"%b %d %H:%M:%S" ) $1" >> $LOCKLOG
                        logger -t $( basename "$0") "$$ $1"
                else
                        # Not Cron, output to CLI and log
                        echo -e "$( date +"%b %d %H:%M:%S" ) $1" # | tee -a $LOCKLOG
                        logger -t $( basename "$0") "$$ $1"
                fi
        fi
}

error_handler() {
	  #echo "Error: ($1) occurred on $2"
	  #printf "%d\n" $1
	  #local lc="$BASH_COMMAND" rc=`cat $ERROR`
	    #echo "Command [$lc] exited with code [$rc]"
	  # https://www.howtogeek.com/821320/how-to-trap-errors-in-bash-scripts-on-linux/
	  local lc="$BASH_COMMAND" rc=$? ERRLINE="$2"

	  case $rc in
		1)
			 BIGERROR="Catchall for general errors"
			 ;;

		 2) 
			BIGERROR="Misuse of shell built-ins"
			;;

		126)
		       	BIGERROR="Command invoked, cannot execute; possible permission issue"
			;;

		127) 
			BIGERROR="Command not found"
			;;

		128) 
			BIGERROR="Invalid argument to exit"
			;;

		128+n)
		       
			BIGERROR="Fatal error signal “n”"
			;;

		130)
		       	BIGERROR="Script terminated by Control-C"
			;;

		255\*)
		       	BIGERROR="Exit status out of range"
			;;
		*)
			BIGERROR="Unknown error code"
			;;
	esac

	  DEBUG="Y"
	  if [ ! -s $ERROR ]; then
		# The below is set to echo, but in a "real" script, we could use Debug
	    	Debug "Error1: Command [$lc], line $ERRLINE:, exited [code $rc, $BIGERROR]"
	  else
	  	Debug "Error2: Command [$lc] `cat $ERROR`"
	  fi
	  #exit 1
  }

#function error_handler {
	#echo "Error: ($?) $( cat $ERROR )"
	  #exit 1
#}

bad_command ABC XYZ 
bad_command ABC XYZ 2> $ERROR
echo "foo" 
