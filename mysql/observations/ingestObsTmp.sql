use staging;
truncate table obs_tmp;
load data local infile '/home/uh/weather/new_weather/data/observations_2025-11-10-12-05.json' into table obs_tmp;
delete from staging.observations where report_key in (select distinct report_key from staging.extract_observations)    or obs_key in (select distinct obs_key from staging.extract_observations);
insert into staging.observations select * from staging.extract_observations;
