#!/bin/bash

DIR=/home/uh/weather/new_weather/
APIKEY=`cat $DIR/api_key`
#STATIONS=`head -2 $DIR/geohash_only.csv`
STATIONS=`cat $DIR/geohash_only.csv`
BASEURL="https://data.hub.api.metoffice.gov.uk/observation-land/1/"

DATE=`date +%Y-%m-%d-%H-%M`
DATEZ=`date +%Y-%m-%dT%H:%M:%SZ`
DT=`date +%Y-%m-%d`
DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`

cd $DIR

thisdir=$DIR"data/"

thisfile=$thisdir"observations_"$DATE".json"

# make sure the file is empty
rm -f $thisfile



for station in $STATIONS
do
    echo $station
    file=$thisfile
    ./getStation.py $station $DATEZ  $APIKEY | grep -v "Not Found" >> $file
done


exit


