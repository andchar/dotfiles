#!/usr/bin/env bash
ARCH=$(incus query /1.0 | jq -r '.environment.architectures[0]')

IMAGE_NAME=$(
  incus image list images: --format=json |
  jq -r --arg ARCH "$ARCH" '
    .[]
    | select(.type == "container")
    | select(.architecture == $ARCH)
    | select(.aliases != null)
    | . as $img
    | $img.properties.description + (" [" + $img.properties.variant + "]") + (" [" + $img.fingerprint[0:12] + "]")
  ' |
  sort -u |
  rofi -dmenu -p "Image"
)

FINGERPRINT=$(sed -n 's/.*\[\([a-f0-9]\{12\}\)\]$/\1/p' <<< "$IMAGE_NAME")

echo "$FINGERPRINT"
