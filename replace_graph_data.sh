#!/bin/bash

# Script to replace the content of the 'graphData' JavaScript object
# in the index.html file with the content of an external JSON file.

# --- Configuration ---
HTML_FILE="index.html"
START_MARKER="// START_GRAPHDATA_JSON"
END_MARKER="// END_GRAPHDATA_JSON"

# --- Argument Validation ---

# 1. Check if the JSON file path is provided
if [ -z "$1" ]; then
    echo "Error: Missing argument."
    echo "Usage: $0 <path/to/your/data.json>"
    exit 1
fi

JSON_FILE="$1"

# 2. Check if the JSON file exists
if [ ! -f "$JSON_FILE" ]; then
    echo "Error: JSON file not found at '$JSON_FILE'"
    exit 1
fi

# 3. Check if the HTML file exists
if [ ! -f "$HTML_FILE" ]; then
    echo "Error: HTML file not found at '$HTML_FILE'. Ensure the script is run in the correct directory."
    exit 1
fi

# --- Content Preparation and Replacement ---

# 1. Escape the JSON content for insertion into the sed command.
#    This process escapes backslashes and forward slashes, ensuring sed's
#    'r' (read) command correctly inserts the multi-line content.
#    We will use 'r' (read) command along with 'd' (delete) to achieve replacement.

# 2. Perform the replacement using sed.

# NOTE: The content of the JSON file MUST be a valid JavaScript object
# (i.e., only the object content inside the outermost curly braces,
# WITHOUT "const graphData = "). The script will automatically add the 
# necessary indentation (tab character) for better readability.

# Create a temporary file to hold the JSON content with correct indentation for insertion.
TEMP_JSON=$(mktemp)
# Add an extra tab indent to every line of the JSON file content
sed 's/^/\t\t\t/' "$JSON_FILE" > "$TEMP_JSON"

# Use sed to perform the block replacement in-place.
# Explanation of the sed command:
# 1. '/START_MARKER/,/END_MARKER/{ ... }': Defines the address range to operate on.
# 2. 'd': Deletes the content in the range (the existing graphData body).
# 3. 'r TEMP_JSON': Reads the prepared JSON content from the temp file immediately
#    after the START_MARKER line (which is now deleted, so the new content goes 
#    where the old content started).
# 4. '}' closes the operation block.

# NOTE: This uses the GNU sed syntax for in-place editing.
sed -i.bak -e "/$START_MARKER/{
r $TEMP_JSON
}" \
-e "/$START_MARKER/,/$END_MARKER/{
/START_GRAPHDATA_JSON/b
/END_GRAPHDATA_JSON/b
d
}" "$HTML_FILE"

# Clean up the temporary file
rm "$TEMP_JSON"

# Inform the user
if [ $? -eq 0 ]; then
    echo "Successfully replaced 'graphData' content in '$HTML_FILE' with data from '$JSON_FILE'."
    echo "A backup file, '$HTML_FILE.bak', was created."
else
    echo "An error occurred during sed replacement."
fi

# End of Script
