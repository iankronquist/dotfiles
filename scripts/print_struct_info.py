
import lldb

def print_struct_info(debugger, command, result, internal_dict):
    result.PutCString("print_struct_info called with argument: " + command)

    target = debugger.GetSelectedTarget()
    if not target.IsValid():
        result.PutCString("Error: Invalid target")
        return

    if not command:
        result.PutCString("Usage: print_struct_info <type or variable>")
        return

    struct_type = None
    frame = target.GetProcess().GetSelectedThread().GetSelectedFrame()
    if not frame.IsValid():
        result.PutCString("Error: Invalid frame")
        var = frame.FindVariable(command)
        if var.IsValid():
            struct_type = var.GetType()
            result.PutCString(f"Variable '{command}' found with type: {struct_type.GetName()}")

    if not struct_type:
        struct_type = target.FindFirstType(command)
        if struct_type.IsValid():
            result.PutCString(f"Type '{command}' found.")
        else:
            result.PutCString(f"Error: Could not find variable or type '{command}'")
            return

    # Check if the type is a struct
    if struct_type.GetTypeClass() != lldb.eTypeClassStruct:
        result.PutCString(f"Error: '{command}' is not a struct.")
        return

    # Dereference pointer types to get the actual struct type
    if struct_type.IsPointerType():
        struct_type = struct_type.GetPointeeType()

    print_info(struct_type, result)

def print_info(struct_type, result):
    result.PutCString("Struct: " + struct_type.GetName())
    struct_size = struct_type.GetByteSize()
    result.PutCString(f"Size: 0x{struct_size:x}")

    result.PutCString("Member details:")
    total_padding = 0
    last_offset = 0

    for idx in range(struct_type.GetNumberOfFields()):
        field = struct_type.GetFieldAtIndex(idx)
        offset = field.GetOffsetInBytes()
        ft = field.GetType()
        size = ft.GetByteSize()

        # Calculate and report padding between fields
        if offset > last_offset:
            padding = offset - last_offset
            if padding > 0:
                result.PutCString(f"  - Padding: 0x{padding:x} bytes")
                total_padding += padding

        # Print field details
        result.PutCString(f"  - {field.GetName()}:")
        result.PutCString(f"    Offset: 0x{offset:x}")
        result.PutCString(f"    Size: 0x{size:x}")

        # Update last_offset to current field's end
        last_offset = offset + size

    # Report padding after the last member
    if last_offset < struct_size:
        padding = struct_size - last_offset
        result.PutCString(f"  - Padding at end: 0x{padding:x} bytes")
        total_padding += padding

    result.PutCString(f"Total padding: 0x{total_padding:x} bytes")

def __lldb_init_module(debugger, internal_dict):
    debugger.HandleCommand('command script add -f print_struct_info.print_struct_info print_struct_info')
    print("The 'print_struct_info' command has been installed.")  # Confirmation message

