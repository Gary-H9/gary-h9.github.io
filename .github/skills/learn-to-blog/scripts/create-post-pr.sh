#!/usr/bin/env bash

set -euo pipefail

repo="Gary-H9/gary-h9.github.io"
base_branch="gh-pages"
script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

if [[ "$#" -ne 3 ]]; then
  echo "Usage: create-post-pr.sh <markdown-file> <_posts/path.markdown> <pr-title>" >&2
  exit 2
fi

draft_file="$1"
post_path="$2"
pr_title="$3"

if [[ ! "$post_path" =~ ^_posts/[0-9]{4}-[0-9]{2}-[0-9]{2}-[a-z0-9]+(-[a-z0-9]+)*\.markdown$ ]]; then
  echo "Post path must match _posts/YYYY-MM-DD-lowercase-slug.markdown." >&2
  exit 2
fi

"$script_dir/scan-draft.sh" "$draft_file"
gh auth status >/dev/null
gh repo view "$repo" --json nameWithOwner >/dev/null

if gh api "repos/$repo/contents/$post_path?ref=$base_branch" --silent >/dev/null 2>&1; then
  echo "Refusing to overwrite existing post: $post_path" >&2
  exit 1
fi

base_sha="$(gh api "repos/$repo/git/ref/heads/$base_branch" --jq '.object.sha')"
slug="${post_path#_posts/}"
slug="${slug%.markdown}"
branch="post/${slug}-$(date -u +%H%M%S)"
branch_created=false
pr_created=false

cleanup_failed_branch() {
  if [[ "$branch_created" == true && "$pr_created" == false ]]; then
    gh api --method DELETE "repos/$repo/git/refs/heads/$branch" --silent >/dev/null 2>&1 || true
  fi
}

trap cleanup_failed_branch EXIT

gh api --method POST "repos/$repo/git/refs" \
  -f ref="refs/heads/$branch" \
  -f sha="$base_sha" >/dev/null
branch_created=true

content="$(base64 < "$draft_file" | tr -d '\n')"
gh api --method PUT "repos/$repo/contents/$post_path" \
  -f message="Add post: $pr_title" \
  -f content="$content" \
  -f branch="$branch" >/dev/null

gh pr create \
  --repo "$repo" \
  --base "$base_branch" \
  --head "$branch" \
  --title "$pr_title" \
  --body "Adds the approved learning note at \`$post_path\`.

Publication requires passing post validation and a separate merge approval."
pr_created=true
