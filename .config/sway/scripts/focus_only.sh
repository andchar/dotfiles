#!/bin/bash

# Get the focused output
FOCUSED=$(swaymsg -t get_outputs | jq -r '.[] | select(.focused==true) | .name')

# Build a single command to disable all other outputs
CMD=""
for OUTPUT in $(swaymsg -t get_outputs | jq -r '.[].name'); do
  if [ "$OUTPUT" != "$FOCUSED" ]; then
    CMD+="output $OUTPUT disable; "
  fi
done

echo -e "Executing command:\n$CMD"
# Execute the command in one go
swaymsg "$CMD"
