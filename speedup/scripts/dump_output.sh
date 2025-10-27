#!/bin/bash

TEMP_DIR=$(mktemp -d)
echo "Temporary directory: $TEMP_DIR"

for FIG in "14" "15" "16a" "16b" "17a" "17b"
do
  find "figure${FIG}" -name "output.log" | while read log_file; do
    cp "$log_file" "$TEMP_DIR/$(basename $(dirname "$log_file"))_$(basename "$log_file")"
  done
done

tar -czf all-figure-output.tar.gz -C "$TEMP_DIR" .

rm -rf "$TEMP_DIR"

echo "Created: all-figure-output.tar.gz (contains logs from all figures)"
