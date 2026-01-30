
#!/usr/bin/env bash
set -euo pipefail

# --- Global config ---
REPO="AndriiCharnosh/pa-deploy"   # e.g. "octocat/example"
REF="main"          # default ref for dispatch
# --------------------

# Define workflows and their inputs.
# Key = display name; value = "WORKFLOW_ID_OR_FILE|input1,input2,..."
# Note: inputs here must match the 'workflow_dispatch' inputs defined in your workflow YAML.
declare -A WF_MAP=(
  # Example single-input workflow
  ["Setup Self-Hosted Runners"]="main.yml|environment"

  # Add more later, e.g.:
  # ["Run E2E"]="e2e.yml|suite,browser"
  # ["Build with flag"]="build.yml|feature_flag"
)

# Choose workflow via rofi
WF_CHOICE="$(printf '%s\n' "${!WF_MAP[@]}" | sort | rofi -dmenu -p "Choose workflow")"
[[ -z "${WF_CHOICE}" ]] && exit 0

WF_DEF="${WF_MAP[${WF_CHOICE}]}"
WORKFLOW="${WF_DEF%%|*}"
INPUT_LIST="${WF_DEF#*|}"

declare -A INPUTS=()

# Prompt for each input
IFS=',' read -r -a INPUT_ARRAY <<< "${INPUT_LIST}"
for name in "${INPUT_ARRAY[@]}"; do
  val="$(echo "" | rofi -dmenu -p "Value for '${name}':" -theme-str 'entry { placeholder: "type and Enter"; }')"
  if [[ -z "${val}" ]]; then
    notify-send "GitHub Action" "Canceled: missing value for '${name}'"
    exit 0
  fi
  INPUTS["$name"]="$val"
done

# Build -f args for gh
GH_F_ARGS=()
for k in "${!INPUTS[@]}"; do
  GH_F_ARGS+=("-f" "${k}=${INPUTS[$k]}")
done

RUN_OUT="$(gh workflow run "${WORKFLOW}" -R "${REPO}" --ref "${REF}" "${GH_F_ARGS[@]}" 2>&1 || true)"
RUN_URL="$(echo "${RUN_OUT}" | grep -Eo 'https?://[^ ]+' | head -n1)"

if [[ -n "${RUN_URL}" ]]; then
  notify-send "GitHub Action" "Triggered: ${WF_CHOICE} → ${RUN_URL}"
else
  notify-send "GitHub Action" "Triggered: ${WF_CHOICE} on ${REF}"

