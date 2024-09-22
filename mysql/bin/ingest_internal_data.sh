#!/bin/bash


DATA=/mnt/fritz_nas/energy/newHumTem/newDataInternal

#DATA=/home/uh/weather/mysql/data/internal
DATAIN=$DATA/in
DATAPRO=$DATA/processed
TABLE="internal_temperature_tmp"

echo "Going to $DATAIN"
cd $DATAIN

echo "Enable mysql file upload (again)."
mysql -h pidata02 -u monitor --local-infile=1 -e "set global local_infile=true"


for file in *.txt
do
    echo "Found file $file"
    rm -f $TABLE.csv
    #ln -s "$file" $TABLE.csv
    grep -v '\#'  "$file" > $TABLE.csv
    echo "Truncating table $TABLE."
    mysql -h pidata02 -u monitor -e "TRUNCATE TABLE staging.$TABLE"
    echo "Importing data to mysql table $TABLE"
    mysqlimport -h pidata02 -u monitor --ignore-lines=0 --fields-terminated-by=' ' --verbose  --local staging $TABLE.csv
    #    mysqlimport -h pidata02 -u monitor -p --local staging internal_temperature.csv
    echo "Imported data to mysql table $TABLE"
    mysql -h pidata02 -u monitor -e "UPDATE staging.$TABLE SET filename = '$file', rec_load_dt = SYSDATE(), rec_load_epoch = UNIX_TIMESTAMP()"
    echo "Details for uploads added to table $TABLE."
    mysql -h pidata02 -u monitor -e "INSERT INTO staging.internal_temperature (epoch , t_i ,\
                                     h_i , mystery , dt , time , dew_point , water_content , \
                                     filename , rec_load_dt , rec_load_epoch , rec_added_dt) \
                                     SELECT \
                                     tmp.epoch \
                                   , tmp.t_i \
                                   , tmp.h_i \
                                   , tmp.mystery \
                                   , tmp.dt \
                                   , tmp.time \
                                   , tmp.dew_point \
                                   , tmp.water_content \
                                   , tmp.filename \
                                   , tmp.rec_load_dt \
                                   , tmp.rec_load_epoch \
                                   , SYSDATE() \
                                   FROM staging.internal_temperature_tmp tmp \
                                   left join staging.internal_temperature e on e.epoch = tmp.epoch \
                                   where e.epoch is null \
                                   ;"
    
    mv "$file" $DATAPRO
    echo ""$file" moved to  $DATAPRO"
#    rm -f $TABLE.csv
done

exit

# 
	    
