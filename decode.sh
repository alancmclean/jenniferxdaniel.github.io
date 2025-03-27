#!/bin/bash

INPUT_FILE="slide1.txt"
OUTPUT_DIR="decoded_images"
mkdir -p "$OUTPUT_DIR"

# Grep all base64 image blocks
grep -oE 'data:image/[^;]+;base64,[A-Za-z0-9+/=]+' "$INPUT_FILE" | nl -nln -s: | while IFS=: read -r index line; do
    # Extract image type
    mime_type=$(echo "$line" | sed -E 's/data:image\/([^;]+);.*/\1/')
    ext=$(echo "$mime_type" | tr '[:upper:]' '[:lower:]')
    if [[ "$ext" == "jpeg" ]]; then ext="jpg"; fi

    # Extract base64 data
    base64_data=$(echo "$line" | sed -E 's/^data:image\/[^;]+;base64,//')

    # Decode and save
    filename="$OUTPUT_DIR/output_$index.$ext"
    echo "$base64_data" | base64 -d > "$filename" 2>/dev/null

    if [[ $? -eq 0 ]]; then
        echo "✅ Saved: $filename"
    else
        echo "⚠️  Failed to decode image $index"
    fi
done
