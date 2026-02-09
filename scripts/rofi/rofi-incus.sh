#!/usr/bin/env bash

MODE="$1"

list_instances() {
  incus list --format=json | jq -r '
    .[] |
    "\(.name) (\(.type)) [\(.status)]"
  '
}

start_instance() {
  NAME="$1"
  incus start "$NAME" >/dev/null 2>&1
}

enter_instance() {
  NAME="$1"
  foot sh -c "incus exec \"$NAME\" -- /bin/bash"
}

create_instance() {
  TYPE="$1" # container or vm

  ARCH=$(incus query /1.0 | jq -r '.environment.architectures[0]')

  IMAGE_NAME=$(
    incus image list images: --format=json |
    jq -r --arg ARCH "$ARCH" --arg TYPE "$TYPE" '
      .[]
      | select(.type == $TYPE)
      | select(.architecture == $ARCH)
      | select(.aliases != null)
      | . as $img
      | $img.properties.description + (" [" + $img.properties.variant + "]") + (" [" + $img.fingerprint[0:12] + "]")
    ' |
    sort -u |
    rofi -dmenu -p "Image"
  )

  IMAGE=$(sed -n 's/.*\[\([a-f0-9]\{12\}\)\]$/\1/p' <<< "$IMAGE_NAME")

  echo "$IMAGE"

  [ -z "$IMAGE" ] && exit 0

  NAME=$(rofi -dmenu -p "Instance name")
  [ -z "$NAME" ] && exit 0

  if [ "$TYPE" = "virtual-machine" ]; then
    incus launch "images:$IMAGE" "$NAME" --vm
  else
    incus launch "images:$IMAGE" "$NAME"
  fi

  incus exec "$NAME" -- bash
}

case "$MODE" in
  menu)
    CHOICE=$( (
      list_instances
      echo "── Create new container"
      echo "── Create new VM"
    ) | rofi -dmenu -p "Incus")

    [[ -z "$CHOICE" ]] && exit 0

    if [[ "$CHOICE" == "── Create new container" ]]; then
      create_instance container
      exit 0
    fi

    if [[ "$CHOICE" == "── Create new VM" ]]; then
      create_instance virtual-machine
      exit 0
    fi

    NAME=$(echo "$CHOICE" | awk '{print $1}')
    STATUS=$(echo "$CHOICE" | grep -o '\[.*\]' | tr -d '[]')

    if [ "$STATUS" != "Running" ]; then
      start_instance "$NAME"
    fi

    enter_instance "$NAME"
    ;;
esac
