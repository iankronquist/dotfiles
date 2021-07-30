import requests
import pprint
import argparse

PARSER = argparse.ArgumentParser()
PARSER.add_argument('path')
args = PARSER.parse_args()

path = args.path

if path[0] == '\\' and len(path) > 1:
    path = path[1:]

print(path)
url=r'https://compcentralwebapi.net/Files/BySourcePath?sourcePath={}'.format(path)
print(url)
r=requests.get(url)
pprint.pprint(r.json())

