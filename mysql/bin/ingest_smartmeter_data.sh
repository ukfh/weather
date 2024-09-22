#!/bin/bash

DATA=/mnt/fritz_nas/energy/newHumTem/smartmeter
#DATA=/home/uh/weather/mysql/data/smartmeter
DATAIN=$DATA/in
DATAPRO=$DATA/processed
TABLE="smartmeter_tmp"

echo "Going to $DATAIN"
cd $DATAIN

echo "Enable mysql file upload (again)."
mysql -h pidata02 -u monitor --local-infile=1 -e "set global local_infile=true"

for file in combined-consumption*.csv
do
    echo "Found file $file"
    rm -f $TABLE.csv
    cp "$file" $TABLE.csv
    #grep -v '\#'  "$file" > $TABLE.csv
    echo "Truncating table $TABLE."
    mysql -h pidata02 -u monitor -e "TRUNCATE TABLE staging.$TABLE"
    echo "Importing data to mysql table $TABLE"
    mysqlimport -h pidata02 -u monitor --ignore-lines=1 --fields-terminated-by=',' --verbose  --local staging $TABLE.csv
    #    mysqlimport -h pidata02 -u monitor -p --local staging internal_temperature.csv
    echo "Imported data to mysql table $TABLE"
    mysql -h pidata02 -u monitor -e "UPDATE staging.$TABLE SET filename = '$file', rec_load_dt = SYSDATE(), rec_load_epoch = UNIX_TIMESTAMP()"
    echo "Details for uploads added to table $TABLE."
    mysql -h pidata02 -u monitor -e "DELETE FROM staging.smartmeter WHERE dt in \
                                     (select distinct dt from staging.smartmeter_tmp);"

    mysql -h pidata02 -u monitor -e "INSERT INTO staging.smartmeter (dt \
                                    , electricity_kwh \
                                    , electricity_gbp \
                                    , gas_kwh \
                                    , gas_gbp \
                                    , filename \
                                    , rec_load_dt \
                                    , rec_load_epoch \
                                    , rec_added_dt) \
                                    SELECT \
                                    dt \
                                    , electricity_kwh \
                                    , electricity_gbp \
                                    , gas_kwh \
                                    , gas_gbp \
                                    , filename \
                                    , rec_load_dt \
                                    , rec_load_epoch \
                                    , SYSDATE() \
                                    FROM staging.smartmeter_tmp;"
    
    mv "$file" $DATAPRO
    echo ""$file" moved to  $DATAPRO"
#    rm -f $TABLE.csv
done

exit

# 


