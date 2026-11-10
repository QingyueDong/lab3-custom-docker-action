#!/usr/bin/env bash
# =============================================================================
# update_readme.sh  (Lab 3 / Lecture 3 - Activity 7)
#
# Appends one log line with the vowel-frequency result, the contributor and a
# timestamp to README.md in the CURRENT directory.
#
# Usage:  update_readme.sh "<freq_result>" "<github_user>" [data_file]
#   $1  FREQ_RESULT  - output of frequency.py, e.g. "a=3, e=5, i=1, o=2, u=0 (total=11)"
#   $2  GITHUB_USER  - who pushed (github.actor)
#   $3  DATA_FILE    - optional, the file that was analysed (default: data.txt)
#
# Change vs. the slides: this script NO LONGER runs git config/add/commit/push.
# It runs inside a Docker container that has no Git credentials (and should not
# have any). The workflow commits README.md on the runner in a later step.
# =============================================================================
set -euo pipefail   # stop on errors, on unset variables, and on failures inside pipes

# Inputs
FREQ_RESULT="${1:?usage: update_readme.sh <freq_result> <github_user> [data_file]}"
GITHUB_USER="${2:-unknown}"
DATA_FILE="${3:-data.txt}"
README="${README_FILE:-README.md}"
TIMESTAMP="$(date '+%Y-%m-%d %H:%M:%S %Z')"
SHORT_SHA="${GITHUB_SHA:-local}"
SHORT_SHA="${SHORT_SHA:0:7}"

if [ ! -f "$README" ]; then
  echo "Error: $README not found in $(pwd)." >&2
  echo "Inside Docker the repository must be mounted (a Docker container action does this" >&2
  echo "automatically at /github/workspace; with 'docker run' use -v \"\$PWD:/github/workspace\" -w /github/workspace)." >&2
  exit 1
fi

# Make sure the file ends with a newline before we append a new line.
if [ -n "$(tail -c 1 "$README")" ]; then
  echo >> "$README"
fi

# Update README (slides: echo -e "\n[$GITHUB_USER - $FREQ_RESULT - $TIMESTAMP]" >> README.md)
printf -- '- %s | contributor: **%s** | file: `%s` | %s | commit `%s`\n' \
  "$TIMESTAMP" "$GITHUB_USER" "$DATA_FILE" "$FREQ_RESULT" "$SHORT_SHA" >> "$README"

echo "Appended to $README:"
tail -n 1 "$README"
