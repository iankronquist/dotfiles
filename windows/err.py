from __future__ import print_function
import re
import sys
import urllib2
import json
import os
import time
from difflib import SequenceMatcher

ERROR_MSGS_DB='http://errors/errmsgs.js'
ERROR_MSGS_DIR=os.path.expanduser('~\AppData\Local\errors')
ERROR_MSGS_FILE=os.path.join(ERROR_MSGS_DIR, 'errmsgs.json')
ERROR_MSGS_REFRESH_PERIOD= 60 * 60 * 24 * 30 # 30 days in seconds.
SEQUENCE_MATCHER_RATIO_CUTOFF=0.9

def download_error_msgs():
    print('downloading')
    try:
        response = urllib2.urlopen(ERROR_MSGS_DB, None, 1)
        if response.code != 200:
            print("Couldn't download error message DB from {}. Got http error code {}".format(ERROR_MSGS_DB, response.code))
            return None
        return response.read()
    except urllib2.URLError:
        return None


# It's a javascript file. Munge it until it looks like json :O
def format_msgs_db_as_json(content):
    # Remove first line with variable declaration.
    jsonish = content[content.index('\n'):]
    # Remove trailing commas.
    jsonish = re.sub(",[ \t\r\n]+\]", "]", jsonish)
    # Remove everything after 'var facilities'
    facilities_index = jsonish.find('var facilities')
    # if it's not found then it's -1 and we get the same string :)
    jsonish = jsonish[:facilities_index]

    # Remove trailing semicolons & witespace
    jsonish = jsonish.strip()
    if jsonish[-1] == ';':
        jsonish = jsonish[:-1]

    # Hopefully it's valid JSON now.
    try:
        json.loads(jsonish)
    except ValueError:
        print('DB is not valid json. Did the format change?')
        raise
    return jsonish

def get_db():
    # If the db file exists and is not too old, read it directly.
    if os.path.exists(ERROR_MSGS_FILE) and time.time() - os.path.getmtime(ERROR_MSGS_FILE)  < ERROR_MSGS_REFRESH_PERIOD:
        with open(ERROR_MSGS_FILE, 'r') as errdbfile:
            return errdbfile.read()
    # Refresh the db.
    content = download_error_msgs()
    if not content:
        if os.path.exists(ERROR_MSGS_FILE):
            print('Falling back to local database')
            with open(ERROR_MSGS_FILE, 'r') as errdbfile:
                return errdbfile.read()
        else:
            return None
    db = format_msgs_db_as_json(content)
    if not os.path.exists(ERROR_MSGS_DIR):
        os.makedirs(ERROR_MSGS_DIR)
    with open(ERROR_MSGS_FILE, 'w') as errdbfile:
        errdbfile.write(db)
    return db

# Fuzzy searching with SequenceMatcher. This is better for approximate matches but is slow.
def search(n):
    search16 = hex(n)
    print('searching for', search16)

    dbjson = get_db()
    db = json.loads(dbjson)
    results_count = 0
    results = []
    print('searching')
    for b10, b16, sym, text, header in db:
        if SequenceMatcher(None, search16, b16).ratio() > SEQUENCE_MATCHER_RATIO_CUTOFF:
            row_format ="{:<12} {:<40} {:<12} {:<50}"
            row = row_format.format(b16, sym, header, text)
            # If it's in an important header, surface it in the results first.
            if header in ['ntstatus.h', 'winbase.h', 'winerror.h']:
                results.insert(0, row)
            else:
                results.append(row)
            results_count += 1
    if not results_count:
        print('No results?')
    else:
        print('\n'.join(results))

n = int(sys.argv[1], 0)
search(n)
