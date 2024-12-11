import lldb

def ptype(debugger, command, result, internal_dict):
    print(command)
    print(lldb.target)
    for f in lldb.target.FindFirstType(command).fields:
        print("offset %d bytesize %d name %s" % (f.GetOffsetInBytes(), f.GetType().GetByteSize(), f.GetName()))

if __name__ == '__main__':
    pass
elif lldb.debugger:
    lldb.debugger.HandleCommand('command script add -f ptype.ptype ptype')
