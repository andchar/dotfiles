#!/usr/bin/env bash
set -euo pipefail

# --- Configure these ---
REPO="AndriiCharnosh/pa-deploy"                 # e.g. "octocat/example"
WORKFLOW="Setup Self-Hosted Runners"  # e.g. "deploy.yml" or "Deploy" or workflow ID
PARAM_NAME="environment"          # e.g. the input name defined in workflow 'inputs'
REF="main"                        # branch or tag to dispatch
# -----------------------
# Environment list & default
ENVIRONMENTS=("proxmox" "development" "production")
DEFAULT_ENV_INDEX=0

printf "%s\n" "proxmox" "development" "production"

# Prompt for parameter value via rofi
#PARAM_VALUE="$(echo "" | rofi -dmenu -p "Value for '${PARAM_NAME}':" -theme-str 'entry { placeholder: "type and Enter"; }')"
PARAM_VALUE="$(
  printf "%s\n" "${ENVIRONMENTS[@]}" |
    rofi -dmenu \
      -p "Select environment:" \
      -theme-str 'entry { placeholder: "type and Enter"; }' \
      -selected-row "${DEFAULT_ENV_INDEX}"
)"


if [[ -z "${PARAM_VALUE}" ]]; then
  notify-send "GitHub Action" "Canceled: no value for '${PARAM_NAME}'"
  exit 0
fi

# Trigger workflow run
# -f passes an input; repeat -f for multiple inputs when you add more later
RUN_OUT="$(gh workflow run "${WORKFLOW}" -R "${REPO}" --ref "${REF}" -f "${PARAM_NAME}=${PARAM_VALUE}" 2>&1 || true)"

# Try to extract the URL to the run (gh often prints it)
RUN_URL="$(echo "${RUN_OUT}" | grep -Eo 'https?://[^ ]+' | head -n1)"

if [[ -n "${RUN_URL}" ]]; then
  notify-send "GitHub Action" "Triggered: ${RUN_URL}"
else
  notify-send "GitHub Action" "Triggered: ${WORKFLOW} on ${REF} with ${PARAM_NAME}=${PARAM_VALUE}"
fi

# Optional: show last few lines in a rofi window if needed
# echo "${RUN_OUT}" | rofi -e
