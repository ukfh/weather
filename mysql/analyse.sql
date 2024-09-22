use stagging;

SELECT * FROM internal_temperature limit 10;


use staging;

select * from internal_temperature limit 10;


select from_unixtime(epoch), date_format(from_unixtime(epoch) ,'%Y-%m-%d') mydate
, date_format(from_unixtime(epoch) ,'%H') myhour
, dt, time from internal_temperature
where 1 = 1
and date_format(from_unixtime(epoch) ,'%Y-%m-%d') = '2024-01-01'
order by epoch
limit 10;

with internal_measurements as
(
SELECT
date_format(from_unixtime(epoch) ,'%Y-%m-%d') dt
, date_format(from_unixtime(epoch) ,'%H') hour
, t_i
, water_content
from internal_temperature
)
, internal_measurements_hourly as (
select
dt
, HOUR
, round(AVG(t_i), 1) t_i
, round(AVG(water_content), 1) water_content
from  internal_measurements
GROUP BY dt
, HOUR
)
, internal_measurements_hourly_long as (
select
dt
, HOUR
,  t_i metricvalue
, 't_i' metricname
from  internal_measurements_hourly
union all
select
dt
, HOUR
,  water_content metricvalue
, 'water_content' metricname
from  internal_measurements_hourly
)
, internal_measurements_daily_long as(
select
dt
, round(avg(metricvalue), 1)  metricvalue
, metricname
, count(*) measurementpoints
from internal_measurements_hourly_long
GROUP BY dt, metricname
)


select * from internal_measurements_daily_long
where metricname = 't_i'
order by dt desc

limit 1000
;

select * from smartmeter_tmp;
select * from smartmeter;
select count(*) from smartmeter;

with smartmeter_long as (
select
date_format(STR_TO_DATE(dt, '%d/%m/%Y') ,'%Y-%m-%d')  dt
, electricity_kwh metricvalue
, 'electricity_kwh' metricname
from staging.smartmeter
union all
select
date_format(STR_TO_DATE(dt, '%d/%m/%Y') ,'%Y-%m-%d')  dt
, electricity_gbp metricvalue
, 'electricity_gbp' metricname
from staging.smartmeter
union all
select
date_format(STR_TO_DATE(dt, '%d/%m/%Y') ,'%Y-%m-%d')  dt
, gas_kwh metricvalue
, 'gas_kwh' metricname
from staging.smartmeter
union all
select
date_format(STR_TO_DATE(dt, '%d/%m/%Y') ,'%Y-%m-%d')  dt
, gas_gbp metricvalue
, 'gas_gbp' metricname
from staging.smartmeter
)

select * from smartmeter_long where metricname = 'gas_kwh'
and metricvalue > 0
;

select * from  staging.smartmeter;


--DELETE from smartmeter_tmp where dt in ('01/11/2023');