#!/bin/bash

# Define the output file
OUTPUT_FILE="packages.yml"

# Extract manually installed packages and save raw output for debugging
echo "Debug: Extracting manually installed packages..."
xbps-query -l -m > debug_raw_packages.txt

# Extract package names by removing everything after the last hyphen
# This will capture the name part before the last hyphen, which separates the version
awk -F'-' '{OFS="-"; NF--; print $0}' debug_raw_packages.txt | awk -F'_' '{print $1}' | sort -u > debug_package_names.txt

# Check if debug_package_names.txt contains data
if [ ! -s debug_package_names.txt ]; then
  echo "Error: No package names extracted. Please check debug_raw_packages.txt and extraction logic."
  exit 1
fi

# Start the YAML file
echo "packages:" > "$OUTPUT_FILE"

# Loop through each package name and append it to the YAML file
while IFS= read -r package; do
  if [ -n "$package" ]; then  # Ensure the package name is not empty
    echo "  - $package" >> "$OUTPUT_FILE"
  else
    echo "Warning: Skipping empty package name" >&2
  fi
done < debug_package_names.txt

echo "Export complete. Packages are listed in $OUTPUT_FILE"
