#!/usr/bin/env python3
import os
import requests
import datetime

from pprint import pprint

API_KEY = open(os.path.expanduser("~/.sound_transit_api_key")).read().strip()

AGENCY='40'


STOP_ID = f"{AGENCY}_99240"  # Example: UW Station. Format is "agency_stopid", usually "1_" prefix
BASE_URL = "http://api.pugetsound.onebusaway.org/api/where"
url = f"{BASE_URL}/arrivals-and-departures-for-stop/{STOP_ID}.json?key={API_KEY}"
#url = f'https://api.pugetsound.onebusaway.org/api/where/agencies-with-coverage.json?key={API_KEY}'
response = requests.get(url)
print(response)

display_time_format = '%Y-%m-%d %H:%M:%S'

if response.ok:
    arrivals = response.json()['data']['entry']['arrivalsAndDepartures']
    for arrival in arrivals[:4]:

        msg = ''
        #msg += f'{arrival["tripHeadsign"]} '
        msg += f'{arrival["routeLongName"]} '
        scheduledArrivalTime = arrival['scheduledArrivalTime']
        scheduledArrivalTimeParsed = datetime.datetime.fromtimestamp(scheduledArrivalTime // 1000)
        if arrival.get('predicted'):
            predictedArrivalTime = arrival['predictedArrivalTime']
            predictedArrivalTimeParsed = datetime.datetime.fromtimestamp(predictedArrivalTime / 1000)
            msg += 'ETA: ' + predictedArrivalTimeParsed.strftime(display_time_format) + ' '
        msg += 'Scheduled arrival: ' + scheduledArrivalTimeParsed.strftime(display_time_format)
        print(msg)
