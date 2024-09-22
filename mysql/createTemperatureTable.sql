

;
select count(*) from staging.internal_temperature limit 10
-- where EPOCH != 0 and T_I is not NULL
-- order by epoch
;

select * from staging.internal_temperature limit 10
-- where EPOCH != 0 and T_I is not NULL
-- order by epoch
;
 UPDATE staging.internal_temperature SET filename = "this file", rec_load_dt = SYSDATE(), rec_load_epoch = UNIX_TIMESTAMP()
;

select 'thisfile' filename, SYSDATE() rec_load_dt, UNIX_TIMESTAMP() rec_load_epoch ;

with dates as
(select 'thisfile' filename, SYSDATE() rec_load_dt, UNIX_TIMESTAMP() rec_load_epoch)
select i.*, d.* from staging.internal_temperature i
, dates d
limit 10
;

from dates;

select i.*, d.* from staging.internal_temperature i
LEFT JOIN  d
;

TRUNCATE TABLE staging.internal_temperature;


with epochs as (
select distinct epoch from staging.internal_temperature
)
SELECT
tmp.epoch
, e.epoch
, t_i
, h_i
, mystery
, dt
, time
, dew_point
, water_content
, filename
, rec_load_dt
, rec_load_epoch
, SYSDATE()
FROM staging.internal_temperature_tmp tmp
left join epochs e on e.epoch = tmp.epoch
where e.epoch is null
limit 10;




INSERT INTO staging.internal_temperature (epoch , t_i , h_i , mystery , dt , time , dew_point , water_content , filename , rec_load_dt , rec_load_epoch , rec_added_dt)
SELECT
tmp.epoch
, tmp.t_i
, tmp.h_i
, tmp.mystery
, tmp.dt
, tmp.time
, tmp.dew_point
, tmp.water_content
, tmp.filename
, tmp.rec_load_dt
, tmp.rec_load_epoch
, SYSDATE()
FROM staging.internal_temperature_tmp tmp
left join staging.internal_temperature e on e.epoch = tmp.epoch
where e.epoch is null
;

select * from staging.internal_temperature
where dt = '06.01.2023'
;
select count(*) all_rows from staging.internal_temperature where dt = '06.01.2023';
