#!/bin/sh

echo "$@" | mail -s "$1 $2 $3" kronquii@onid.orst.edu
