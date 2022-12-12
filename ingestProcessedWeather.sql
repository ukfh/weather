-- recast the day parttioning of the data to the actual observation day, not the
-- download day
USE weather;

set hive.exec.dynamic.partition.mode=nonstrict;


INSERT OVERWRITE TABLE weather_processed_t PARTITION(year, month, day, dt)
SELECT
DISTINCT
i
, name
, lat
, lon
, country
, continent
, elevation
, substr(daykey, 1,10)
--, dt
, hourkey
, metric
, value
, substr(daykey,1,4) year
, substr(daykey, 6, 2) month
, substr(daykey, 9, 2) day
, substr(daykey, 1,10) dt
FROM  weather_t
${WHERE}
--where dt >= '2021-01-02' and dt <= '2021-01-10' and substr(daykey, 1,10) >= '2021-01-05' and substr(daykey, 1,10) <= '2021-01-07'
--where dt >= '2020-12-28' and dt <= '2021-02-03' and substr(daykey, 1,10) >= '2021-01-01' and substr(daykey, 1,10) <= '2021-01-31'

--and dt = '2021-01-01'
;



