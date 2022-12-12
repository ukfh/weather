#!/bin/bash

FILE=$1

echo $FILE

file=`basename $FILE`

file="${file%.*}"

echo $file

arrIN=(${file//-/ })

year=${arrIN[3]}
month=${arrIN[4]}
day=${arrIN[5]}
dt=$year-$month-$day

echo $year $month $day $dt

hdfsfile="/data/staging/weather/observation_raw/$year/$month/$day/$dt"

command="ALTER TABLE weather.observation_raw_t  ADD IF NOT EXISTS  PARTITION (year = $year, month = '"$month"', day = '"$day"', dt = '"$dt"') LOCATION '"$hdfsfile"';"

echo $command

hive -e "$command"

hdfs dfs -copyFromLocal $FILE $hdfsfile

exit

#  ../observations/2021/All-observation-UK-2021-01-01-00-00.json
