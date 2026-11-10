#!/usr/bin/env bash
# =============================================================================
# entrypoint.sh  (Lab 3 / Lecture 3 - Activity 8)
#
# The Docker image runs this script when the container starts (ENTRYPOINT).
#   1. runs frequency.py on the input file
#   2. passes the result + GitHub username to update_readme.sh
#   3. publishes the result as the action output "frequency"
#
# Where do the files come from?
#   * The SCRIPTS live inside the image at /app/.github/scripts (COPY in Dockerfile).
#   * The DATA (data.txt, README.md) live in the repository, which GitHub mounts
#     into a Docker container action at /github/workspace and makes the current
#     directory. That is why README changes survive after the container exits.
# =============================================================================
set -euo pipefail

# Folder this script is in (works in the container AND when you run it locally).
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Input file: action.yml sets FILE; GitHub also sets INPUT_FILE for every input.
DATA_FILE="${FILE:-${INPUT_FILE:-data.txt}}"
# Contributor: GITHUB_USER if you pass it with `docker run -e`, else GitHub's GITHUB_ACTOR.
CONTRIBUTOR="${GITHUB_USER:-${GITHUB_ACTOR:-unknown}}"

echo "Starting Frequency Analyzer..."
echo "  working directory : $(pwd)"
echo "  input file        : ${DATA_FILE}"
echo "  contributor       : ${CONTRIBUTOR}"

# Running the Python frequency analyzer (set -e stops here if it fails)
FREQ_RESULT="$(python3 "${SCRIPT_DIR}/frequency.py" "${DATA_FILE}")"
echo "  result            : ${FREQ_RESULT}"

# Running update_readme.sh
bash "${SCRIPT_DIR}/update_readme.sh" "${FREQ_RESULT}" "${CONTRIBUTOR}" "${DATA_FILE}"

# Action output: later workflow steps can read ${{ steps.<id>.outputs.frequency }}
if [ -n "${GITHUB_OUTPUT:-}" ]; then
  echo "frequency=${FREQ_RESULT}" >> "${GITHUB_OUTPUT}"
fi

echo "Process Completed!"
