# =============================================================================
# Lab 3 / Lecture 3 - Activity 9: Dockerfile for the Vowel Frequency Analyzer
#
# Built automatically by GitHub when the workflow runs the custom Docker action
# (.github/actions/vowel-frequency-analyzer/action.yml -> image: ../../../Dockerfile).
# Local test:  docker build -t vowel-frequency-analyzer:latest .
# =============================================================================

# Use a Python base image.
# The slides use python:3.9-slim - Python 3.9 reached end-of-life in Oct 2025
# (no more security fixes), so we use a currently supported release.
# The slim image already contains bash and tzdata (time zones).
FROM python:3.12-slim

# Do not write .pyc files; print output immediately (nicer CI logs).
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Set the working directory inside the container
WORKDIR /app

# The slides install git here because their container committed and pushed by itself.
# Ours does not: the container only computes and edits README.md, and the workflow
# commits on the runner. So no extra packages are needed (smaller, faster image).

# Copy ONLY the scripts into the image (not the whole repo, and never .git - which
# can contain the workflow's access token; see .dockerignore).
COPY .github/scripts/ /app/.github/scripts/

# Ensure the entrypoint script exists and is executable
RUN chmod +x /app/.github/scripts/*.sh

# Set the entrypoint to the entrypoint script
ENTRYPOINT ["/app/.github/scripts/entrypoint.sh"]
