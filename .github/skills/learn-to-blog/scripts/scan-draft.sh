#!/usr/bin/env bash

set -u

if [[ "$#" -eq 0 ]]; then
  echo "Usage: scan-draft.sh <markdown-file> [...]" >&2
  exit 2
fi

patterns=(
  "Private key material"
  "-----BEGIN (RSA |EC |OPENSSH |DSA |PGP )?PRIVATE KEY-----"
  "GitHub token"
  "gh[pousr]_[A-Za-z0-9]{30,}"
  "GitHub fine-grained token"
  "github_pat_[A-Za-z0-9_]{40,}"
  "AWS access key"
  "(AKIA|ASIA)[A-Z0-9]{16}"
  "Slack token"
  "xox[baprs]-[A-Za-z0-9-]{20,}"
  "JSON web token"
  "eyJ[A-Za-z0-9_-]{8,}\\.[A-Za-z0-9_-]{8,}\\.[A-Za-z0-9_-]{8,}"
  "Credential assignment"
  "(api[_-]?key|access[_-]?token|auth[_-]?token|client[_-]?secret|password|passwd)[[:space:]]*[:=][[:space:]]*['\\\"]?[^[:space:]'\\\"<>{}]{8,}"
  "Credential-bearing URL"
  "https?://[^/@[:space:]]+:[^/@[:space:]]+@"
  "Local home path"
  "(^|[^[:alnum:]_])(/Users/|/home/)[^[:space:]<>()]+"
  "Private or local network URL"
  "https?://(localhost|127\\.0\\.0\\.1|10\\.[0-9]+\\.[0-9]+\\.[0-9]+|192\\.168\\.[0-9]+\\.[0-9]+)(:[0-9]+)?([/[:space:]]|$)"
  "Internal hostname"
  "https?://([A-Za-z0-9-]+\\.)*(internal|local|corp)(:[0-9]+)?([/[:space:]]|$)"
  "Email address"
  "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
)

status=0
export LC_ALL=C

for file in "$@"; do
  if [[ ! -f "$file" ]]; then
    echo "Draft scanner: file not found: $file" >&2
    status=2
    continue
  fi

  for ((index = 0; index < ${#patterns[@]}; index += 2)); do
    label="${patterns[index]}"
    pattern="${patterns[index + 1]}"
    match="$(grep -E -n -m 1 -- "$pattern" "$file" 2>/dev/null || true)"

    if [[ -n "$match" ]]; then
      line="${match%%:*}"
      echo "Draft scanner: $label detected in $file at line $line." >&2
      status=1
    fi
  done
done

if [[ "$status" -eq 0 ]]; then
  echo "Draft scanner: no configured sensitive patterns detected."
fi

exit "$status"
