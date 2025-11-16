#!/bin/bash

DIR=/home/uh/weather/new_weather/

DATE=`date +%Y-%m-%d-%H-%M`
DATEZ=`date +%Y-%m-%dT%H:%M:%SZ`
DT=`date +%Y-%m-%d`
DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`

thisdir=$DIR"data/"

cd $thisdir

file=$1

echo $file

TMPSQL="../ingestObsTmp.sql"

rm -f $TMPSQL

echo "use staging;" > $TMPSQL
echo "truncate table obs_tmp;" >> $TMPSQL
echo "load data local infile '/home/uh/weather/new_weather/data/"$file"' into table obs_tmp;" >> $TMPSQL
echo "delete from staging.observations where report_key in (select distinct report_key from staging.extract_observations)    or obs_key in (select distinct obs_key from staging.extract_observations);" >> $TMPSQL
echo "insert into staging.observations select * from staging.extract_observations;" >> $TMPSQL

mysql -h pidata02 -u monitor --local-infile < $TMPSQL


exit


