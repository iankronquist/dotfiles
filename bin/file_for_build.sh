#!/bin/zsh
echo "not finished yet"
exit -1
BUILD=SydneyB20B101
LOCATION=$(xbs bootstrap $BUILD | jq -r ".$BUILD.location")
# FIXME this is wrong
PROJECT=$(xbs mastering inspect files -u SydneyB20B101 --filename  remoted  --json | jq -r ".project")
echo "Found location $LOCATION"
