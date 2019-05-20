#!/bin/bash

DATA_OUT=""
EXTRA_STATS=0

WORKING=`pwd`
SCRIPTS="${HOME}/Documents/scripts/"


CLOCK="1.2e9"
DATA_SIZE="32"

for file_name in $( ls *.out )
do
   echo $file_name

   CYCLES=`grep gpu_sim_cycle ${file_name} | awk 'BEGIN{ FS="="; gsub( " ", "", $2) }{print $2 }' | tr -d "[:space:]"`

   STATS_FILE=`echo ${file_name} | awk 'BEGIN{ FS="." }{ print $1 }'`
   STATS_FILE="${STATS_FILE}.csv"
   echo $STATS_FILE

   awk -v clock=${CLOCK} -v cycles=${CYCLES} -v dataSize=${DATA_SIZE} -f parse_stats.awk ${STATS_FILE}

done




