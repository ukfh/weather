#!/usr/bin/python3
import requests
import sys

station = sys.argv[1]
date = sys.argv[2]
apikey = sys.argv[3]

url = "https://data.hub.api.metoffice.gov.uk/observation-land/1/" + station


payload = {}
headers = { 'Apikey': apikey }

response = requests.request("GET", url, headers=headers, data=payload)

observation = response.text

json = '{"report_date":"' + date + '", "station_geohash":"' + station + '", "observation":' + observation + '}'


print(json)
