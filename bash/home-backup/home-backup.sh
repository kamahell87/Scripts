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
  exit 1
}

while getopts "d:u:h" OPTION; do
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
# Owner check
if [[ ! -d /home/$USER ]]; then
  echo "Oops! Apparently '$USER' doesn't have a home!"
  exit 1
fi

DIR=./$DEVICE-backups
FILE=$(find $DIR/ -name '*.bz2' -type f -mtime +60)

if [[ ! -d $DIR ]]; then
  mkdir $DIR
fi

echo ">>> Creating the tarball..."
tar -zcpf $DIR/$DEVICE-backup-$(date +%d-%m-%Y).tar /home/$USER

echo ">>> bzip-ing the tarball..."
bzip2 $DIR/$DEVICE-backup-$(date +%d-%m-%Y).tar

if [[ $FILE ]]; then
  echo ">>> Found files older than 60 days"
  for f in $FILE; do
    echo " Removing $f"
    rm -rf $f
  done
fi

echo "DONE!"
}

do_the_magic
