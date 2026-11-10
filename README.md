# Vowel Frequency Analyzer - custom Docker GitHub Action

Lab 3 for **UTS 43030 Module 3 - Custom GitHub Actions** (Lecture 3 practical activities).

Contributors push text in `data.txt`. On every push to `main` the workflow runs a **custom Docker
container action** that counts the vowels in `data.txt` and appends the result, the contributor's
GitHub username and a timestamp to this README.

## How it works

```
push to main
  └─ .github/workflows/ci.yml            (workflow)
       ├─ actions/checkout@v4            checks out the repo on the runner
       ├─ ./.github/actions/vowel-frequency-analyzer   (custom action, action.yml)
       │    └─ builds ./Dockerfile → runs the container with the repo mounted at /github/workspace
       │         └─ .github/scripts/entrypoint.sh
       │              ├─ frequency.py data.txt        → "a=.., e=.., i=.., o=.., u=.. (total=..)"
       │              └─ update_readme.sh             → appends a line to README.md
       └─ git commit + push README.md    (on the runner, with GITHUB_TOKEN)
```

## Project structure

| Path | Purpose (course activity) |
|------|---------------------------|
| `README.md` | Target file updated by `update_readme.sh` |
| `data.txt` | Required input |
| `.github/workflows/ci.yml` | Workflow (Activity 4) |
| `.github/actions/vowel-frequency-analyzer/action.yml` | Custom action metadata (Activity 5) |
| `.github/scripts/frequency.py` | Vowel counter (Activity 6) |
| `.github/scripts/update_readme.sh` | README updater (Activity 7) |
| `.github/scripts/entrypoint.sh` | Container entrypoint (Activity 8) |
| `Dockerfile` | Container image (Activity 9) |

## Run it locally (optional)

```bash
python3 .github/scripts/frequency.py data.txt                 # just the counts
GITHUB_ACTOR=me bash .github/scripts/entrypoint.sh            # full run, appends to README.md
git restore README.md                                         # undo the local test

# With Docker Desktop (mirrors what GitHub does):
docker build -t vowel-frequency-analyzer:latest .
docker run --rm -v "$PWD:/github/workspace" -w /github/workspace \
  -e GITHUB_ACTOR=me -e INPUT_FILE=data.txt vowel-frequency-analyzer:latest
```

## Vowel Frequency Log

<!-- The workflow appends one line per run below this comment. -->
- 2026-11-11 03:30:49 AEDT | contributor: **QingyueDong** | file: `data.txt` | a=24, e=30, i=15, o=16, u=12 (total=97) | commit `0708448`
- 2026-11-11 03:31:24 AEDT | contributor: **QingyueDong** | file: `data.txt` | a=29, e=37, i=18, o=20, u=14 (total=118) | commit `4a9e5f2`
