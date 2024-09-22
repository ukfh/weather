
select * , json_extract(observations, '$.SiteRep.DV.Location')  from staging.weather;



select w.* , json_extract(w.observations, '$.SiteRep.DV.Location'), thislocation.*  from staging.weather w,
json_table(
w.observations, '$.SiteRep.DV.Location[*]' COLUMNS(
        i integer PATH '$.i',
        name VARCHAR(100) PATH '$.name',
--        lat double PATH '$.lat',
--        lon double PATH '$.lon',
--        country VARCHAR(100) PATH '$.country',
--        continent VARCHAR(100) PATH '$.continent',
--        elevation double PATH '$.elevation',
--        period JSON PATH '$.Period',
        type VARCHAR(100) PATH '$.Period[0].type',
        value VARCHAR(100) PATH '$.Period[0].value',
        rep json PATH '$.Period[0].Rep[0]',
        d varchar(100) PATH '$.Period[0].Rep[0].D',
        dollar varchar(100) PATH '$.Period[0].Rep[0].$'

      )
) thislocation

limit 10
;

with observations as (
select w.* , json_extract(w.observations, '$.SiteRep.DV.Location'), thislocation.*  from staging.weather w,
json_table(
w.observations, '$.SiteRep.DV.Location[*]' COLUMNS(
        i integer PATH '$.i',
        name VARCHAR(100) PATH '$.name',
--        lat double PATH '$.lat',
--        lon double PATH '$.lon',
--        country VARCHAR(100) PATH '$.country',
--        continent VARCHAR(100) PATH '$.continent',
--        elevation double PATH '$.elevation',
        period JSON PATH '$.Period',
--        type VARCHAR(100) PATH '$.Period[0].type',
--        value VARCHAR(100) PATH '$.Period[0].value',
--        rep json PATH '$.Period[0].Rep[0]',
--        d varchar(100) PATH '$.Period[0].Rep[0].D',
--        dollar varchar(100) PATH '$.Period[0].Rep[0].$',
        NESTED PATH '$.Period[*]' COLUMNS (
--        rep json PATH '$.Rep',
        nested path '$.Rep[*]' columns (
        d varchar(100) path '$.D',
        dollar varchar(100) path '$.$'
        ),
        value varchar(100) path '$.value',
        type varchar(100) path '$.type'
        )
      )
) thislocation
)

select o.* from observations o

limit 10;




--


SELECT people.*
FROM t1,
     JSON_TABLE(json_col, '$.people[*]' COLUMNS (
                -- name VARCHAR(40)  PATH '$.name',
                address VARCHAR(100) PATH '$.address')
     ) people;


-- mysql
select
  n.visit_id,
  h.*
from
  demo_nested_data n,
  JSON_TABLE(
    n.hits,
    '$[*]' COLUMNS(
      time INT PATH '$.time',
      isInteraction bool PATH '$.isInteraction',
      NESTED PATH '$.page' COLUMNS(
        pageTitle VARCHAR(100) PATH '$.pageTitle',
        pagePath VARCHAR(40) PATH '$.pagePath'
      )
    )
  ) as h

-- hive ---
SELECT
thislocation.i
, thislocation.name
, thislocation.lat
, thislocation.lon
, thislocation.country
, thislocation.continent
, thislocation.elevation
, thisperiod.value day
, thisrep.offset / 60
, metric
, value
, year
, month
, day
, dt
FROM  observation_raw_t
LATERAL VIEW EXPLODE(siterep.dv.location) loc AS thislocation
LATERAL VIEW EXPLODE(thislocation.period) per AS thisperiod
LATERAL VIEW EXPLODE(thisperiod.rep) rep AS thisrep
LATERAL VIEW EXPLODE(JSON_MAP(TO_JSON(thisrep),'string,string')) x AS metric, value
${WHERE} AND  metric != 'offset'
--and dt = '2021-01-01'





-- test

use staging;
CREATE TABLE t1(json_col JSON);

INSERT INTO t1 VALUES (
    '{ "people": [
        { "name":"John Smith",  "address":"780 Mission St, San Francisco, CA 94103"},
        { "name":"Sally Brown",  "address":"75 37th Ave S, St Cloud, MN 94103"},
        { "name":"John Johnson",  "address":"1262 Roosevelt Trail, Raymond, ME 04071"}
     ] }'
);

select * from t1;


SELECT t.*, people.*
FROM t1 t,
     JSON_TABLE(json_col, '$.people[*]' COLUMNS (
                name VARCHAR(40)  PATH '$.name',
                address VARCHAR(100) PATH '$.address')
     ) people;