import lldb

def find_padded_structs(debugger, command, result, internal_dict):
    import pdb;pdb.set_trace()
    result.PutCString("Searching for structs and classes with padding...\n")

    target = debugger.GetSelectedTarget()
    if not target.IsValid():
        result.PutCString("Error: Invalid target")
        return

    padded_types = []

    # Use FindFirstType without the index and name to iterate through types
    index = 0
    while True:
        struct_type = target.FindFirstType(None)

        # If no more types, exit the loop
        if not struct_type.IsValid():
            break
        name = struct_type.GetName()
        result.PutCString(f"found type {name} ")

        # We only care about structs or classes
        if struct_type.GetTypeClass() in (lldb.eTypeClassStruct, lldb.eTypeClassClass):
            padding = calculate_padding(struct_type)

            if padding > 0:
                padded_types.append((struct_type.GetName(), padding))

        # Move to the next type
        index += 1

    # Report padded structs/classes
    if padded_types:
        result.PutCString(f"Found {len(padded_types)} structs/classes with padding:\n")
        for type_name, padding in padded_types:
            result.PutCString(f"  - {type_name}: {padding} bytes of padding\n")
    else:
        result.PutCString("No structs or classes with padding found.\n")

def calculate_padding(struct_type):
    total_padding = 0
    last_offset = 0
    struct_size = struct_type.GetByteSize()

    # Iterate through each field of the struct/class
    for idx in range(struct_type.GetNumberOfFields()):
        field = struct_type.GetFieldAtIndex(idx)
        offset = field.GetOffsetInBytes()
        size = field.GetType().GetByteSize()

        # Calculate padding between fields
        if offset > last_offset:
            padding = offset - last_offset
            total_padding += padding

        # Update last_offset to current field's end
        last_offset = offset + size

    # Check for padding at the end of the struct/class
    if last_offset < struct_size:
        total_padding += struct_size - last_offset

    return total_padding

def __lldb_init_module(debugger, internal_dict):
    debugger.HandleCommand('command script add -f find_padded_structs.find_padded_structs find_padded_structs')
    print("The 'find_padded_structs' command has been installed.")

