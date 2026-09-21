import sys
import importlib
from google.protobuf.json_format import MessageToJson

def dump_protobuf(module_name, message_name, file_path):
    try:
        # Dynamically import the specified protobuf module
        proto_module = importlib.import_module(module_name)

        # Get the message class by name
        message_class = getattr(proto_module, message_name)
        message_instance = message_class()

        # Read and parse the serialized protobuf file
        with open(file_path, "rb") as f:
            message_instance.ParseFromString(f.read())

        # Print the message as a JSON string
        print(MessageToJson(message_instance, indent=2))

    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    if len(sys.argv) != 4:
        print(f"Usage: {sys.argv[0]} <protobuf_module> <message_name> <path_to_protobuf_file>")
        sys.exit(1)

    proto_module = sys.argv[1]
    message_name = sys.argv[2]
    file_path = sys.argv[3]

    dump_protobuf(proto_module, message_name, file_path)

