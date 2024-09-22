create database staging;

use staging;


drop table if exists staging.internal_temperature_tmp ;

CREATE table staging.internal_temperature_tmp
( epoch integer
, t_i double
, h_i double
, mystery VARCHAR ( 20 )
, dt VARCHAR ( 20 )
, time VARCHAR ( 20 )
, dew_point double
, water_content double
, filename varchar(200)
, rec_load_dt datetime
, rec_load_epoch integer
)
;

drop table if exists staging.internal_temperature ;

CREATE table staging.internal_temperature
( epoch integer
, t_i double
, h_i double
, mystery VARCHAR ( 20 )
, dt VARCHAR ( 20 )
, time VARCHAR ( 20 )
, dew_point double
, water_content double
, filename varchar(200)
, rec_load_dt datetime
, rec_load_epoch integer
, rec_added_dt datetime
);

drop table if exists staging.smartmeter_tmp ;

CREATE table staging.smartmeter_tmp
( dt VARCHAR ( 20 )
, electricity_kwh double
, electricity_gbp double
, gas_kwh double
, gas_gbp double
, filename varchar(200)
, rec_load_dt datetime
, rec_load_epoch integer
)
;

drop table if exists staging.smartmeter ;

CREATE table staging.smartmeter
( dt VARCHAR ( 20 )
, electricity_kwh double
, electricity_gbp double
, gas_kwh double
, gas_gbp double
, filename varchar(200)
, rec_load_dt datetime
, rec_load_epoch integer
, rec_added_dt datetime
)
;

