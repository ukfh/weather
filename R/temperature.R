# setup connection to Hive ----
Sys.setenv(HIVE_HOME='/opt/hadoop/hive')
Sys.setenv(HADOOP_HOME='/opt/hadoop/hadoop')
Sys.setenv(JAVA_HOME='/usr/lib/jvm/java-8-openjdk-amd64/jre')
Sys.setenv(LD_LIBRARY_PATH = "/usr/java/jdk1.8.0_65/jre/lib/amd64/server:/usr/lib64/R/lib:/usr/local/lib64")


options( java.parameters = "-Xmx8g" )
library(rJava)
library(RJDBC)
library(Rserve)
library(RHive) # why do we need that? connection fails otherwise
# follow instruction on https://github.com/nexr/RHive#loading-rhive-and-connecting-to-hive ant can live in userspace

cp = c("/opt/hadoop/hive/lib/hive-jdbc-2.3.4.jar", 
       "/opt/haddop/hadoop/share/hadoop/common/hadoop-common-2.7.3.jar")
.jinit(classpath=cp) 
drv <- JDBC("org.apache.hive.jdbc.HiveDriver",
            "/opt/hadoop/hive/lib/hive-jdbc-2.3.4.jar",
            identifier.quote="`")
conn <- dbConnect(drv, "jdbc:hive2://localhost:10000/weather", "uh")

# use connection to Hive ----

# SQLtext <- "select * from weather_processed_t  limit 10"
# dbResponse <- dbGetQuery(conn, SQLtext)


SQLtext <- paste("select dt, year, month, lat, lon, name, i, country, metric, round(avg(value),2) value
                  , cast(max(value) as double) v_max, cast(min(value) as double) v_min, count(*) f
                 from weather_processed_t where metric in -- ('dp', 'h', 'p', 's', 't', 'v', 'w')
                 ('h', 'p',  't', 'w')
                 and dt >= '2015-01-01' and dt <= '2021-08-01' -- and name in ('BENSON')
                 group by dt, year, month, lat, lon, name, i, country, metric", sep = "")
dbResponse <- dbGetQuery(conn, SQLtext)

weatherDaily.org <- dbResponse

write.csv(file = 'weatherDaily.csv', weatherDaily.org, row.names = F)

# plot the data ----

library(tidyverse)


weatherDaily <- weatherDaily.org %>% mutate(dt = as.Date(dt))

locations <- weatherDaily %>% group_by(name) %>% 
  summarise(min_dt = min(dt),
            max_dt = max(dt),
            active_days = n_distinct(dt),
            lat = paste(sort(unique(lat)), collapse = ','),
            lon = paste(sort(unique(lon)), collapse = ','),
            metrics = paste(sort(unique(metric)), collapse = ',')) %>% ungroup() %>%
  filter(active_days > 2000)

# get monthly data for those locations

where <- paste("('", paste(locations$name, collapse = "','"), "')", sep = "")


SQLtext <- paste("select concat_ws('-', cast(year as string), month, '15') dt, year, month, lat, lon, 
                  name, i, country, metric, round(avg(cast(value as double)),2) value
                  , max(cast(value as double)) v_max, min(cast(value as double)) v_min, count(*) f
                 from weather_processed_t where metric in -- ('dp', 'h', 'p', 's', 't', 'v', 'w')
                 ('h', 'p',  't', 'w')
                 and dt >= '2015-01-01' and dt <= '2021-08-01'  and name in ", where, " 
                 group by year, month, lat, lon, name, i, country, metric", sep = "")
dbResponse <- dbGetQuery(conn, SQLtext)



## end ----
ggplot(plotdata, aes(x=dt, y = value)) + geom_line(aes(colour = year))  + 
  geom_point(aes(colour = year)) + 
  facet_wrap(~metric, scales = 'free') +
  geom_line(data = plotdata, aes(x=dt, y=v_min),  lwd = 0.75)


# monthly data ---

SQLtext <- paste("select  concat_ws('-', cast(year as string), month, '15') dt, year, lat, lon, name, i, country, metric,
                  round(avg(value),2) value, max(cast(value as double)) v_max, cast(min(value) as double) v_min, count(*) f
                 from weather_processed_t where metric in -- ('dp', 'h', 'p', 's', 't', 'v', 'w')
                 ('h', 'p',  't', 'w')
                 and dt >= '2015-01-01' and dt <= '2021-08-01' and name in ('BENSON')
                 group by year, month, lat, lon, name, i, country, metric", sep = "")
dbResponse <- dbGetQuery(conn, SQLtext)

weatherMonthly <- dbResponse %>% mutate(dt = as.Date(dt))


# plot the data ----



plotdata <- weatherMonthly %>% 
  filter(metric == 't' & dt >= as.Date('2016-01-01') & dt <= as.Date('2021-08-01') & name %in% c('BENSON')) 

ggplot(plotdata, aes(x=dt, y = value)) + 
    geom_line() +
  geom_line(data = plotdata, aes(x=dt, y=v_min),  lwd = 0.75) +
  geom_line(data = plotdata, aes(x=dt, y=v_max),  lwd = 0.75) + 
    facet_wrap(~name, scales = 'free')

ggplot(plotdata, aes(x=dt, y = v_max - v_min)) + 
  geom_line() +
  facet_wrap(~name, scales = 'free')

  
# geom_line(aes(colour = year))  + 
  # geom_point(aes(colour = year)) + 
  
# metric overview ----

SQLtext <- paste("select metric, min(dt) min_dt, max(dt) max_dt, count(distinct dt) active_days, count(distinct name) locations
                 , concat_ws(',',sort_array(collect_set(value))) v from weather_processed_t  
                 where dt >= '2021-01-01' group by metric", sep = "")



dbResponse <- dbGetQuery(conn, SQLtext)




