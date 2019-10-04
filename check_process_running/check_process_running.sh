#!/bin/bash
# PRTG script to check a process is running
# requires the following params
# #1 Name of process
# #2 Expected number of times process should be running

#check parameters set ok as both user and svc_prtg
if [ "$#" -ne 2 ]
then
  if [ `whoami` = 'svc_prtg' ]
  then
    echo "2:0:Parameters not passed.  Needs both Name of Process & expected number of times process should be running"
  else
    echo "Illegal number of parameters"
    echo "Usage: check_process_running.sh Name_of_process Expected_number_of_processes"
  fi
  exit 2
fi

# Set things up
process_name=$1
expected_number=$2

# check current number of processes
active_processes=$(pgrep -c $process_name)

# PRTG Logic
# if count of up processes is = expected count of processes alert as OK
# if count of up processes is less than expected count of processes alert as DOWN
# if count of up processes is greater than expected count of processes alert as WARNING

if [ $active_processes -lt $expected_number ]
then
  down_count=$((expected_number-active_processes))
  echo "2:$active_processes:$down_count $process_name processes(s) are DOWN"
  exit 2
elif [ $active_processes -gt $expected_number ]
then
  over_count=$((active_processes-expected_number))
  echo "1:$active_processes:$over_count $process_name processes(s) are runing more than the expected $expected_number"
  exit 1
elif [ $active_processes -eq $expected_number ]
then
  echo "0:$active_processes:$active_processes $process_name processes(s) are running"
  exit 0
else
  echo "2:0:An unknown error has occured check pgrep $process_name)"
  exit 2
fi
exit 0