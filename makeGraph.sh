#!/bin/bash

# -- HADOOP ENVIRONMENT VARIABLES START -- #
export HADOOP_HOME=/opt/hadoop/hadoop
export PATH=$PATH:$HADOOP_HOME/bin
export PATH=$PATH:$HADOOP_HOME/sbin
export HADOOP_MAPRED_HOME=$HADOOP_HOME
export HADOOP_COMMON_HOME=$HADOOP_HOME
export HADOOP_HDFS_HOME=$HADOOP_HOME
export YARN_HOME=$HADOOP_HOME
export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
export HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib"
export HADOOP_OPTS="$HADOOP_OPTS -Djava.library.path=$HADOOP_HOME/lib/native"
# -- HADOOP ENVIRONMENT VARIABLES END -- #
#export JAVA_HOME=/usr/lib/jvm/jdk-8-oracle-arm32-vfp-hflt/jre
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-arm64/jre

# hive

export HIVE_HOME="/opt/hadoop/hive"
export PATH=$PATH:$HIVE_HOME/bin:$JAVA_HOME/bin
export CLASSPATH=$CLASSPATH:$HIVE_HOME/lib:$HADOOP_HOME/share/hadoop/common/lib:/usr/share/java
export LD_LIBRARY_PATH=/usr/lib/jni
# tez
#export TEZ_HOME=/opt/hadoop/tez
#export TEZ_CONF_DIR=$TEZ_HOME/conf
#export TEZ_JARS=$TEZ_HOME

# For enabling hive to use the Tez engine
#if [ -z "$HIVE_AUX_JARS_PATH" ]; then
#export HIVE_AUX_JARS_PATH="$TEZ_JARS"
#else
#export HIVE_AUX_JARS_PATH="$HIVE_AUX_JARS_PATH:$TEZ_JARS"
#fi

#export HADOOP_CLASSPATH=${TEZ_CONF_DIR}:${TEZ_JARS}/*:${TEZ_JARS}/lib/*

# spark
#export SPARK_HOME=/opt/hadoop/spark
#export PATH=$PATH:$SPARK_HOME/bin



# the directory we want to be in
ROOT=/home/uh/weather
DIR=$ROOT/weather

# where the data lives
DATA=$ROOT/observations/new/

# the file name
FILE=All-observation-UK

# go to working directory

echo "Going to $DIR"
cd $DIR

# record day and time

DATE=`date +%Y-%m-%d-%H-%M`
DT=`date +%Y-%m-%d`
DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`



# make a plot
DATECMD=date
FORMAT="%Y-%m-%d"

LASTWEEK=`$DATECMD +$FORMAT -d "$DT - 7 day"`
where=" where dt >= '"$LASTWEEK"' " 
hive --hivevar WHERE="$where" -f query_odiham.sql > R/latest_weather.csv

cd R

/usr/local/bin/Rscript makeGraph.R

cd ..

git add R/benson.png
git add R/latest_weather.csv
DATE=`date +%Y-%m-%d-%H-%M`
git commit -m "plot update on $DATE"
git push origin main




exit
