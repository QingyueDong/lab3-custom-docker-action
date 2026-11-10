#!/usr/bin/env python3
"""
Vowel Frequency Analyzer  (Lab 3 / Lecture 3 - Activity 6: frequency.py)

Counts how often each vowel (a, e, i, o, u) appears in a text file.

Usage:
    python3 frequency.py <file_path>

Example output (one line, always in a-e-i-o-u order):
    a=12, e=20, i=9, o=10, u=4 (total=55)

Differences from the slide version (see CHANGES_vs_course_materials.md):
  * Prints a stable, readable line instead of the raw Counter({...}) repr.
  * Error messages go to STDERR, so `FREQ_RESULT=$(python3 frequency.py ...)`
    in entrypoint.sh never captures an error message as if it were a result.
  * Reads the file as UTF-8 and tolerates odd bytes instead of crashing.
"""
import sys
from collections import Counter

VOWELS = "aeiou"


def count_vowels(file_path):
    """Return a Counter with the number of each vowel in the file (case-insensitive)."""
    try:
        with open(file_path, "r", encoding="utf-8", errors="replace") as file:
            text = file.read().lower()          # lower-case so 'A' and 'a' count together
    except FileNotFoundError:
        print(f"Error: {file_path} not found.", file=sys.stderr)
        sys.exit(1)                             # non-zero exit code = failure for CI

    # Counter is a dict that counts items: Counter("aab") -> {'a': 2, 'b': 1}
    return Counter(char for char in text if char in VOWELS)


def format_counts(counts):
    """Turn a Counter into 'a=1, e=2, i=0, o=0, u=0 (total=3)'."""
    parts = [f"{vowel}={counts.get(vowel, 0)}" for vowel in VOWELS]
    return ", ".join(parts) + f" (total={sum(counts.values())})"


if __name__ == "__main__":
    # Exactly one argument (the file path) is required.
    if len(sys.argv) != 2:
        print("Usage: python3 frequency.py <file_path>", file=sys.stderr)
        sys.exit(1)

    file_path = sys.argv[1]
    result = count_vowels(file_path)
    print(format_counts(result))
