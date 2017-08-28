#!/bin/bash
# Hanoi DB Backup Script
# Author: Chris Tan
# Date: 22/02/2017
# This script connects to mysql db and performs a mysqldump, then saves files in a tower of hanoi tape rotation scheme.

# Configuration Variables (adjust to set hanoi_home and tape rotation length)
declare -a rotation=(g a b a c a b a d a b a c a b a e a b a c a b a d a b a c a b a f a b a c a b a d a b a c a b a e a b a c a b a d a b a c a b a)

# Set these variables
# Location of this file / where you want to save backups
hanoi_home=
# Location of configuration file (please see example.conf)
conf_file=

# Other variables
count=$(cat ${hanoi_home}/${conf_file} | grep counter | cut -d "=" -f 2)
name=$(cat ${hanoi_home}/${conf_file} | grep save_name | cut -d "=" -f 2)
host=$(cat ${hanoi_home}/${conf_file} | grep db_host | cut -d "=" -f 2)
user=$(cat ${hanoi_home}/${conf_file} | grep db_user | cut -d "=" -f 2)
password=$(cat ${hanoi_home}/${conf_file} | grep db_password | cut -d "=" -f 2)
db_name=$(cat ${hanoi_home}/${conf_file} | grep db_name | cut -d "=" -f 2)
tape=${rotation[$count]}
date=$(date +"%Y-%m-%d_%H:%M:%S")

# Perform mysqldump
mysqldump -h ${host} -u ${user} -p${password} ${db_name} > ${hanoi_home}/data/${date}.sql

# For testing purposes (pg_dumps then compressing takes ages)
#touch "${hanoi_home}/data/temp_${date}"

# Check if dump is completed, only proceed if ok
if [ ! -e ${hanoi_home}/data/${date}.sql ]
then
  sed -i "s/last_log=.*/last_log=${date} ERROR: ${name} dump failed/" ${hanoi_home}/${conf_file}
  echo ${date} ERROR: ${name} dump failed >> /${hanoi_home}/${name}.log
  exit 1
else
  # Remove "old tape" depending on which letter rotation we are on
  ( cd ${hanoi_home}/data && rm *_${tape}.zip  2>/dev/null )

  # Zip backup file
  ( cd ${hanoi_home}/data && zip ${hanoi_home}/data/${date}_${tape}.zip ${date}.sql )

  # Remove temp file
  rm "${hanoi_home}/data/${date}.sql"

  #incrementing counter or restarting rotation when reaching end of rotation
  if [ ${count} -lt 63 ]
  then
    ((count++))
  else
    count=0
  fi

  sed -i "s/counter=.*/counter=${count}/" ${hanoi_home}/${conf_file}
  sed -i "s/last_log=.*/last_log=$date OK: ${name} dump complete/" ${hanoi_home}/${conf_file}
  echo ${date} OK: ${name} dump complete >> /${hanoi_home}/${name}.log

fi
