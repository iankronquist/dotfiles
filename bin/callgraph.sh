#!/bin/bash
# Call graph generator for Mach-O binaries
# Currently uses radare2, but designed to be easily replaced

set -e

usage() {
    cat <<EOF
Usage: $0 [OPTIONS] <binary>

Generate call graph from a Mach-O binary.

OPTIONS:
    -o <basename>   Output basename (default: callgraph)
    -f <function>   Focus on specific function
    -h              Show this help

OUTPUTS:
    <basename>.dot   Graphviz DOT format
    <basename>.json  JSON format
    <basename>.svg   SVG image (requires graphviz)

EXAMPLES:
    $0 ./binary
    $0 -o myapp_graph ./myapp
    $0 -f "ANENetworkInfo::ANENetworkInfo" ./binary

EOF
    exit 1
}

# Default values
OUTPUT_BASE="callgraph"
FOCUS_FUNC=""

# Parse arguments
while getopts "o:f:h" opt; do
    case $opt in
        o) OUTPUT_BASE="$OPTARG" ;;
        f) FOCUS_FUNC="$OPTARG" ;;
        h) usage ;;
        *) usage ;;
    esac
done
shift $((OPTIND-1))

if [ $# -ne 1 ]; then
    echo "Error: Binary path required"
    usage
fi

BINARY="$1"

if [ ! -f "$BINARY" ]; then
    echo "Error: Binary not found: $BINARY"
    exit 1
fi

echo "[*] Analyzing binary: $BINARY"

# Check if r2 is available
if ! command -v r2 &> /dev/null; then
    echo "Error: radare2 (r2) not found. Install with: brew install radare2"
    exit 1
fi

# Generate call graph using radare2
# This section can be replaced with another tool (ghidra, ida, etc.)
generate_callgraph_r2() {
    local binary="$1"
    local output_base="$2"
    local focus_func="$3"

    if [ -z "$focus_func" ]; then
        # Full call graph
        echo "[*] Generating full call graph..."
        r2 -q -c 'aaa; agCd' "$binary" > "${output_base}.dot"
        r2 -q -c 'aaa; agCj' "$binary" > "${output_base}.json"
    else
        # Specific function
        echo "[*] Generating call graph for: $focus_func"
        r2 -q -c "aaa; s sym.${focus_func}; agfd" "$binary" > "${output_base}.dot"
        r2 -q -c "aaa; s sym.${focus_func}; agfj" "$binary" > "${output_base}.json"
    fi
}

# Main execution
generate_callgraph_r2 "$BINARY" "$OUTPUT_BASE" "$FOCUS_FUNC"

echo "[+] Generated: ${OUTPUT_BASE}.dot"
echo "[+] Generated: ${OUTPUT_BASE}.json"

# Generate SVG if graphviz is available
if command -v dot &> /dev/null; then
    echo "[*] Generating SVG..."
    dot -Tsvg "${OUTPUT_BASE}.dot" -o "${OUTPUT_BASE}.svg"
    echo "[+] Generated: ${OUTPUT_BASE}.svg"
else
    echo "[-] graphviz not found, skipping SVG generation (install with: brew install graphviz)"
fi

# Show some stats
echo ""
echo "[*] Statistics:"
echo -n "Functions: "
r2 -q -c 'aaa; afl~?' "$BINARY"
echo -n "Imports: "
r2 -q -c 'ii~?' "$BINARY"
echo -n "Exports: "
r2 -q -c 'iE~?' "$BINARY"

echo ""
echo "[*] Done!"
