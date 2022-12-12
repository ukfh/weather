
-- CREATE database weather;
USE weather;

ADD JAR hdfs:///code/json-serde-1.3.9-SNAPSHOT-jar-with-dependencies.jar;

ADD JAR hdfs:///code/brickhouse-0.7.1-SNAPSHOT.jar;
CREATE TEMPORARY FUNCTION json_split AS 'brickhouse.udf.json.JsonSplitUDF';
CREATE TEMPORARY FUNCTION json_map AS 'brickhouse.udf.json.JsonMapUDF';
CREATE TEMPORARY FUNCTION to_json AS 'brickhouse.udf.json.ToJsonUDF';

DROP TABLE observation_raw_t;
CREATE EXTERNAL TABLE observation_raw_t
(
SiteRep struct<DV:struct<
                 Location:array<
                                 struct<i:int
                                 , lat:string
                                 , lon:string
                                 , name:string
                                 , country:string
                                 , continent:string
                                 , elevation:string
                                 ,  Period:array<
                                         struct<
                                                 type:string
                                                 , value:string
                                                 , Rep:                                          
                                                 array<
                                                   struct<
                                                   D:string
                                                   ,H:string
                                                   ,P:string
                                                   ,S:string
                                                   ,T:string
                                                   ,V:string
                                                   ,W:string
                                                   ,Pt:string
                                                   ,Dp:string
                                                   ,offset:string
                                                   >
                                                 >
                                                 >
                                 
                                        >
                                        >
                                                >
                                 , dataDate:string
                                 , type:string>,
               Wx:string>

                    
)
PARTITIONED BY
(
year int
, month string
, day string
, dt string
)
ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe'
WITH SERDEPROPERTIES ('mapping.offset' = '$')
--LOCATION '/data/weather/tables/weather_raw'
;
