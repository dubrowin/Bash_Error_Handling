#!/bin/bash

## Error file
ERROR="/tmp/$( basename "$0" ).$$.error"

## Capture any errors and execute Error Handler Function
trap 'error_handler $? $LINENO' ERR

## Functions

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
	  # Capture important variables
	  local lc="$BASH_COMMAND" rc=$? ERRLINE="$2"

	  # Add useful details to error codes
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

	## Enable Debugging
	  DEBUG="Y"

	## 2 Forms of error reporting, with an output file and without
	  if [ ! -s $ERROR ]; then
		# The below is set to echo, but in a "real" script, we could use Debug
	    	Debug "Error1: Command [$lc], line $ERRLINE:, exited [code $rc, $BIGERROR]"
	  else
	  	Debug "Error2: Command [$lc] `cat $ERROR`"
	  fi
	  exit 1
  }

## Sample Commands
bad_command ABC XYZ 
bad_command ABC XYZ 2> $ERROR
echo "foo" 
