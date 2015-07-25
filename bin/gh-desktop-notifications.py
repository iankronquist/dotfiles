import json
from os import path
import subprocess
import shlex

import requests

api_endpoint = 'https://api.github.com/notifications'
auth_param_name = 'access_token'
config_path = '~/.gh-desktop-notifications.json'
title = 'GitHub Notifications'



def main():
    config_file = path.expanduser(config_path)
    with open(config_file, 'r') as f:
        config = json.load(f)
    auth_param = '{}={}'.format(auth_param_name, config.get('oauth_token'))
    url = '{}?{}'.format(api_endpoint, auth_param)
    r = requests.get(url)
    notifications = r.json()
    if notifications != []:
        text = map(lambda s: shlex.quote(s), notifications)
        text = ' '.join(text)
        full_command = config.get('script').format(title=title, text=text)
        full_command = shlex.split(full_command)
        subprocess.call(full_command)



if __name__ == '__main__':
    main()
