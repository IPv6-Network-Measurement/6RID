#!/bin/bash

# Define parameters
INTERFACE_NAME=""
SOURCE_MAC=""
SOURCE_IP=""
GATEWAY_MAC=""
INPUT_FILENAME="input/Hitlist_prefixes.txt"
OUTPUT_DIR="output"
BIN_DIR="bin"
OUTPUT_FILENAME="$OUTPUT_DIR/$(date +'%Y%m%d_%H%M%S').log"

# Ensure the output and bin directories exist
for dir in "$OUTPUT_DIR" "$BIN_DIR"; do
    if [ ! -d "$dir" ]; then
        mkdir -p "$dir"
        echo "Created directory: $dir"
    fi
done

# Check if the old executable exists and remove it
if [ -f "$BIN_DIR/main" ]; then
    sudo rm "$BIN_DIR/main"
    echo "Old executable removed."
fi

# Compile the source code
gcc src/config.c src/main.c src/hash.c src/construct.c src/sample.c src/parser.c -o "$BIN_DIR/main" -lm -lpthread -mcmodel=medium -fPIC

# Check if compilation was successful
if [ -f "$BIN_DIR/main" ]; then
    echo "Compilation successful, running the program..."
    sudo "$BIN_DIR/main" "$INTERFACE_NAME" "$SOURCE_MAC" "$SOURCE_IP" "$GATEWAY_MAC" "$INPUT_FILENAME" "$OUTPUT_FILENAME"
else
    echo "Compilation failed."
fi
