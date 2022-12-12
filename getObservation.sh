#!/bin/bash
# This scripts pulls all available weather observation from the MetOffice
# datapoint service
#Prepare the current date and time as part of the filename
#echo -n "Getting new data"


DATE=$1
# where the data lives
DATA=$2
FILE=$3
APIKEY=$4
#MINDATA=2

#echo -n "$DATE $DATA $FILE $APIKEY"

# bits for the URL

BASEURL=http://datapoint.metoffice.gov.uk/public/data/val/wxobs/all/
TYPE=json # this can be json or xml
WHAT="/all?res=hourly&key="

thisurl=$BASEURL$TYPE$WHAT$APIKEY
#echo $thisurl
thisfile=$DATA$FILE-$DATE.$TYPE
echo $thisfile

wget $thisurl -O $thisfile



exit
