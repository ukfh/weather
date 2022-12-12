-- import that works after August 2015
USE weather;
DROP TABLE weather_processed_t;
CREATE TABLE weather_processed_t
(
i STRING
, name STRING
, lat STRING
, lon STRING
, country STRING
, continent STRING
, elevation STRING
, daykey STRING
--, fileday STRING
, hourkey STRING
, metric STRING
, value STRING
)
PARTITIONED BY
(
year int
, month string
, day string
, dt string
)
STORED AS ORC
;


