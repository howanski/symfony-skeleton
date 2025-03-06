#!/bin/bash
########
# usage: ./service_shell.sh $service $user $command
# services: php,web,db
########
serviceName=php
shellCommand=bash
########

shellUserExpression=""

optionalServiceNameLength=$(echo $1 | wc -m)
if [ $optionalServiceNameLength -gt 1 ]; then
    serviceName=$1
fi

optionalShellUserLength=$(echo $2 | wc -m)
if [ $optionalShellUserLength -gt 1 ]; then
    shellUser=$2
    shellUserExpression="--user $shellUser"
fi

source .env
clear
containerName=$(echo "$APP_NAME-$serviceName-1")
echo "Connecting to service $serviceName"
echo "Command: $shellCommand"
echo "----------------------"
docker exec $shellUserExpression -it $containerName $shellCommand
