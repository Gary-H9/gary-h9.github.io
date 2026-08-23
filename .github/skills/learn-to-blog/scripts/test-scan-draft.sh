#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
work_dir="$(mktemp -d)"
trap 'rm -rf "$work_dir"' EXIT

cat > "$work_dir/safe.markdown" <<'EOF'
---
layout: post
title: "A safe draft"
---

This example contains no configured sensitive patterns.
EOF

"$script_dir/scan-draft.sh" "$work_dir/safe.markdown" >/dev/null

unsafe_values=(
  "github_pat_1234567890abcdefghijklmnopqrstuvwxyz_ABCDEFGH"
  "ghp_1234567890abcdefghijklmnopqrstuvwxyz"
  "AKIA1234567890ABCDEF"
  "xoxb-123456789012345678901234"
  "eyJabcdefgh.ijklmnop.qrstuvwx"
  "api_key=1234567890abcdef"
  "https://user:password@example.com"
  "/Users/example/private/project"
  "https://service.internal/path"
  "person@example.com"
)

for ((index = 0; index < ${#unsafe_values[@]}; index++)); do
  file="$work_dir/unsafe-$index.markdown"
  printf '%s\n' "${unsafe_values[index]}" > "$file"
  if "$script_dir/scan-draft.sh" "$file" >/dev/null 2>&1; then
    echo "Scanner failed to block test case $index." >&2
    exit 1
  fi
done

echo "Draft scanner tests passed."
