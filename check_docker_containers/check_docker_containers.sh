#!/bin/bash
# PRTG script to check containers up and healthy
# requires the following params
# #1 Location of docker-compose.yml
# #2 Number of expected up and active containers

#check parameters set ok as both user and svc_prtg
if [ "$#" -ne 2 ]
then
  if [ `whoami` = 'svc_prtg' ]
  then
    echo "2:0:Parameters not passed.  Needs both directory of docker-compose.yml & expected number of containers"
  else
    echo "Illegal number of parameters"
    echo "Usage: check_docker_containers.sh Dir_of_docker-compose.yml Expected_number_of_containers"
  fi
  exit 2
fi

# Set things up
docker_compose_dir=$1
active_containers=$2

cd $docker_compose_dir

# check current number of up containers
up_containers=$(docker-compose ps | grep "Up" -c)
# check current number of healthy containers
healthy_containers=$(docker-compose ps | grep "healthy" | grep -v "unhealthy" -c)

# PRTG Logic
# if count of up containers is <> expected alert as down
# if count of up containers eq expected but count of healthy <> expected alert as warning
# if count of up containers and count of healthy containers = expected alert as OK

if [ $up_containers -ne $active_containers ]
then
  down_count=$((active_containers-up_containers))
  echo "2:$up_containers:$down_count Docker container(s) are DOWN"
  exit 2
elif [ $healthy_containers -ne $active_containers ]
then
  down_count=$((active_containers-healthy_containers))
  echo "1:$healthy_containers:$down_count Docker container(s) are unhealthy"
  exit 1
elif [ $healthy_containers -eq $active_containers ]
then
  echo "0:$healthy_containers:$active_containers Docker container(s) are up and healthy"
  exit 0
else
  echo "2:0:An unknown error has occured check docker-compose ps as $(whoami)"
  exit 2
fi
exit 0