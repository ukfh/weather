MAILTO="uliharder@gmail.com"
MAILFROM="uliharder@gmail.com"
# covid
#30 16,17,18 * * 1-5 /home/uh/R/covid/gov.sh
#30 9 * * *  /home/uh/R/covid/owid.sh
#30 11 * * *    /home/uh/R/covid/google.sh

# weather data
15 1,5,9,13,17,21 * * * /home/uh/weather/weather/pipeline.sh

30 0,12 * * * ~/bin/get-all-forecast.sh
0  0,12 * * * ~/bin/get-all-observation.sh
5  0,12 * * * /home/uh/weather/new_weather/getObs.sh

# urls data
0 0,2,4,6,8,10,12,14,16,18,20,22 * * * /home/uh/urls/bin/getUrl.sh
0 0 * * * ~/torData/bin/getTor.sh

#duckdns
#*/5 * * * * ~/duckdns/duck.sh >/dev/null 2>&1
