use staging;

create or replace view extract_observations as
with observations as (select json_extract(o.observations, '$.report_date')     report_date
                           , json_extract(o.observations, '$.station_geohash') station_geohash
                           , oi.mslp
                           , oi.datetime
                           , oi.visibility
                           , oi.humidity
                           , oi.wind_speed
                           , oi.temperature
                           , oi.weather_code
                           , oi.wind_direction
                           , oi.pressure_tendency
                      from staging.obs_tmp o,
                           json_table(json_extract(o.observations, '$.observation'),
                                      '$[*]' columns (mslp JSON PATH "$.mslp"
                                          , datetime JSON PATH "$.datetime"
                                          , humidity JSON PATH "$.humidity"
                                          , visibility JSON PATH "$.visibility"
                                          , wind_speed JSON PATH "$.wind_speed"
                                          , temperature JSON PATH "$.temperature"
                                          , weather_code JSON PATH "$.weather_code"
                                          , wind_direction JSON PATH "$.wind_direction"
                                          , pressure_tendency JSON PATH "$.pressure_tendency"
                                          )) oi)
   , input_for_table as (select trim(BOTH '"' from report_date)       report_date,
                                trim(BOTH '"' from station_geohash)   station_geohash,
                                mslp,
                                trim(BOTH '"' from datetime)          datetime,
                                visibility,
                                humidity,
                                wind_speed,
                                temperature,
                                weather_code,
                                trim(BOTH '"' from wind_direction)    wind_direction,
                                trim(BOTH '"' from pressure_tendency) pressure_tendency
                         from observations)
select report_date                               report_date_str,
       str_to_date(report_date, '%Y-%m-%dT%TZ')  reoport_date,
       station_geohash,
       mslp,
       datetime                                  obs_datetime_str,
       str_to_date(datetime, '%Y-%m-%dT%TZ')     obs_datetime,
       visibility,
       humidity,
       wind_speed,
       temperature,
       weather_code,
       wind_direction,
       pressure_tendency,
       concat(report_date, '-', station_geohash) report_key,
       concat(datetime, '-', station_geohash)    obs_key
from input_for_table
;