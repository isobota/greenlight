#!/bin/bash

STATUS="Status: Downloaded newer image for isobota/meeting_web:v2"

new_status=$(sudo docker pull isobota/meeting_web:v2 | grep Status:)

echo $new_status

if [ "$STATUS" == "$new_status" ]
then
  cd /opt/meeting_web
  sudo docker-compose down
  sudo docker rmi $(sudo docker images -f dangling=true -q)
  sudo docker-compose up -d
fi

exit 0
