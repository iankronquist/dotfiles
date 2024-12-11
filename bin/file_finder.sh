#!/bin/bash

dwarfdump $@  | grep DW_AT_decl_file | sort | uniq | sed 's/.*DW_AT_decl_file.*"\(.*\)\")/\1/'
