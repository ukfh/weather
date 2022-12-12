#!/bin/bash



DATE=date
FORMAT="%Y-%m-%d"
start=`$DATE +$FORMAT -d "2021-07-15"`
end=`$DATE +$FORMAT -d "2021-07-28"`
#end=`$DATE +$FORMAT -d "2016-01-02"`
now=`$DATE +$FORMAT -d "$start - 30 day"`
#$start

while [[ "$now" < "$end" ]] ; do
    now=`$DATE +$FORMAT -d "$now + 30 day"`
    nowL=$now
    nowR=`$DATE +$FORMAT -d "$nowL + 30 day"`
    echo "$now $nowL $nowR" 
    left=`$DATE +$FORMAT -d "$nowL - 3 day"`
    right=`$DATE +$FORMAT -d "$nowR + 3 day"`
    where=" where dt >= '"$left"' and dt <= '"$right"' and substr(daykey, 1,10) >= '"$nowL"' and substr(daykey, 1,10) <= '"$nowR"' "
    echo $left $now $right
    echo $where
    hive --hivevar WHERE="$where" -f ingestProcessedWeather.sql
done
