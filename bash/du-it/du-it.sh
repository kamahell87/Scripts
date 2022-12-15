#! /bin/bash

set -e

while getopts "d:u:" OPTION; do
  case $OPTION in
  d)
    DELETE=$OPTARG
    ;;
  u)
    UPDATE=$OPTARG
    ;;
  esac
done

if [[ $UPDATE != "" ]]; then
  for c in $UPDATE; do
  echo ">>> Navigating into $c/"
  builtin cd "/home/administrator/$c/"
  echo ">>> Pulling the latest image"
  sudo docker-compose pull
  echo ">>> Recreating the container(s)"
  sudo docker-compose up -d
  done
elif [[ $DELETE != "" ]]; then
  for d in $DELETE; do
  echo ">>> Navigating into $d/"
  builtin cd "/home/administrator/$d/"
  echo ">>> Stopping and removing the container(s)"
  sudo docker-compose down
  done
fi
