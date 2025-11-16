
use staging;

drop table if exists obs_tmp;
create table obs_tmp
(
    observations json default null
)
;


drop table observations;

create table if not exists observations
(
    report_date_str   varchar(40),
    report_date       datetime,
    station_geohash   varchar(10),
    mslp              integer,
    obs_datetime_str  varchar(40),
    obs_datetime      datetime,
    visibility        double,
    humidity          integer,
    wind_speed        double,
    temperature       double,
    weather_code      integer,
    wind_direction    varchar(10),
    pressure_tendency varchar(10),
    report_key        varchar(100),
    obs_key           varchar(100)
)
;