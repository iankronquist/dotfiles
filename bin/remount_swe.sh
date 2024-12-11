#!/bin/bash
set -o xtrace

sudo killall -9 diskarbitrationd
sudo odutil reset cache
sudo killall -9 autofsd opendirectoryd
#appleconnect signOut
#appleconnect authenticate
sudo killall -9 automountd automount
sudo automount -vc
