#!/bin/bash

# Written by Marco D'Aleo

usage()
{
cat << EOF

Script to take backup of /home directory.

ARGUMENTS:
  -d    The device name. e.g. tank, personal
  -u    The /home owner.
  -h    This help message.

Syntax: home-backup.sh -d [tank, personal] -u [dominus, kamahell87]

EOF
}

while getopts "d:u:h"; do
  case $OPTION in
    h)
      usage
      exit 0
      ;;
    u)
      USER=$OPTARG
      ;;
    d)
      DEVICE=$OPTARG
      ;;
    *)
      usage
      exit 1
      ;;
  esac
done

# Syntax check
if [[ $# -eq 0 ]]; then
  usage
  exit 1
fi

do_the_magic()
{
DIR=./$DEVICE-backups
mkdir $DIR

echo ">>> Creating the tarball..."
tar -zcpf $DIR/$DEVICE-backup-$(date +%d-%m-%Y).tar /home/$USER

echo ">>> bzip-ing the tarball..."
bzip2 $DIR/$DEVICE-backup-$(date +%d-%m-%Y).tar

echo ">>> The following backup files have been removed (older than 60 days)."
find $DIR/$DEVICE-backups/ -name '*.bz2' -type f -mtime +60 -delete -print
}

