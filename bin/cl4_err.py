#!/usr/bin/env python3
import sys

cl4_error_names = {
    0: "L4_ErrorSuccess",
    1: "L4_ErrorPreempted",
    2: "L4_ErrorCanceled",
    3: "L4_ErrorTruncated",
    4: "L4_ErrorCapInvalid",
    5: "L4_ErrorSlotInvalid",
    6: "L4_ErrorMethodInvalid",
    7: "L4_ErrorArgumentInvalid",
    8: "L4_ErrorOperationInvalid",
    9: "L4_ErrorPermissionInvalid",
    }

if __name__ == '__main__':
    n = int(sys.argv[1], 0)
    error_type = n & 0xff
    error_name = cl4_error_names[error_type]
    error_sub = n >> 8
    if error_sub:
        print("cL4 Error {}: {} {}".format(n, error_name, error_sub))
    else:
        print("cL4 Error {}: {}".format(n, error_name))
