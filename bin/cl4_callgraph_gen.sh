#!/bin/sh
set -ex

# $@  means to pass along source files and arguments
 # -S means emit human readable asm and not llvm bitcode I think
/opt/homebrew/opt/llvm/bin/clang \
	$@ \
     -S -emit-llvm \
    -I ./kernel/include -I ./kernel/src -I ./kernel/src/plat \
    -include "kernel/src/plat/qemu/config/qva64.h" -D \
    "CONFIG_KERNEL_BASE=0xffffffff00000000" -D__L4_FILE__='"blah blah"' \
    -o - \
    | /opt/homebrew/opt/llvm/bin/opt -analyze -dot-callgraph  -enable-new-pm=0

# Use opt to analyze with the dot-callgraph pass. Disable the new pass manager

# It gets a shitty name
cp '<stdin>.callgraph.dot' callgraph.dot

# Stolen from some rando's github gist:
# https://gist.github.com/sverweij/93e324f67310f66a8f5da5c2abe94682?short_path=1afa5af

echo "/* the lines within the edges */ .edge:active path, .edge:hover path { stroke: fuchsia; stroke-width: 3; stroke-opacity: 1; } /* arrows are typically drawn with a polygon */ .edge:active polygon, .edge:hover polygon { stroke: fuchsia; stroke-width: 3; fill: fuchsia; stroke-opacity: 1; fill-opacity: 1; } /* If you happen to have text and want to color that as well... */ .edge:active text, .edge:hover text { fill: fuchsia; } " > /tmp/stylesheet.css

sed -i '' '/digraph .*{/a \
stylesheet="/tmp/stylesheet.css" \
' callgraph.dot

dot -Tsvg -ocallgraph.svg callgraph.dot

open callgraph.svg
