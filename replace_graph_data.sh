#!/bin/bash

# --- CONFIGURATION ---
HTML_FILE="index.html"
START_MARKER="// START_GRAPHDATA_JSON"
END_MARKER="// END_GRAPHDATA_JSON"
# ---------------------

# 1. Input Validation and Setup
if [ -z "$1" ]; then
    echo "Error: Missing JSON file path."
    echo "Usage: $0 <path_to_json_file>"
    exit 1
fi

JSON_PATH="$1"

if [ ! -f "$JSON_PATH" ]; then
    echo "Error: JSON file not found at '$JSON_PATH'."
    exit 1
fi

if [ ! -f "$HTML_FILE" ]; then
    echo "Error: HTML file not found at '$HTML_FILE'."
    exit 1
fi

# 2. Prepare the full replacement content with markers
# Create a temporary file containing the markers AND the JSON data.
# This entire file will be read by awk via a pipe, bypassing the ARG_MAX limit.
TEMP_REPLACEMENT_FILE=$(mktemp)
echo "$START_MARKER" > "$TEMP_REPLACEMENT_FILE"
cat "$JSON_PATH" >> "$TEMP_REPLACEMENT_FILE"
echo "$END_MARKER" >> "$TEMP_REPLACEMENT_FILE"

# 3. Perform in-place replacement using awk
# We use a combined input stream: the HTML file and the temporary replacement file.
# Awk reads the replacement data from File Descriptor 3 (<(cat "$TEMP_REPLACEMENT_FILE")).
# It is important to note the use of 'gawk' (GNU Awk) which is standard on most Linux systems.
TEMP_OUTPUT_FILE=$(mktemp)

awk -v start="$START_MARKER" \
    -v end="$END_MARKER" \
    '
    # Start by reading the replacement content from the piped file (FD 3)
    BEGIN {
        # Loop reads the *entire* replacement file content into the replacement_data array
        while ((getline line < "/dev/fd/3") > 0) {
            replacement_data[i++] = line
        }
    }

    $0 ~ start {
        # Found start: Print the replacement content and set the flag to skip lines
        for (j=0; j < i; j++) {
            print replacement_data[j]
        }
        in_block = 1
        next
    }

    $0 ~ end {
        # Found end: Unset the skip flag
        in_block = 0
        next
    }

    in_block == 0 {
        # If not inside the block to be replaced, print the line
        print $0
    }
    ' "$HTML_FILE" 3< "$TEMP_REPLACEMENT_FILE" > "$TEMP_OUTPUT_FILE"

# 4. Replace the original file and clean up
if [ $? -eq 0 ]; then
    mv "$TEMP_OUTPUT_FILE" "$HTML_FILE"
    echo "✅ Successfully replaced the section in '$HTML_FILE' with content from '$JSON_PATH'."
else
    echo "❌ Error: Awk replacement failed. HTML file was not modified."
    rm "$TEMP_OUTPUT_FILE"
fi

rm "$TEMP_REPLACEMENT_FILE"
