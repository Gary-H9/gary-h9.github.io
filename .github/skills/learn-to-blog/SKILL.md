---
name: learn-to-blog
description: Turn a supported learning from the current Copilot conversation into a reviewed pull request for Gary-H9/gary-h9.github.io. Use when the user asks to use /learn-to-blog or wants to turn the current session's learning into a blog post.
---

# Learn to blog

Follow this workflow in order. Do not combine or skip approval gates.

Read [AUTHORING_POLICY.md](AUTHORING_POLICY.md) before drafting.

## 1. Decide whether there is a post

Use only the current conversation and its tool results as evidence. Do not use
memory, prior sessions, unrelated repositories, or unsupported model knowledge
to fill gaps.

A publishable learning must have:

- one clear, reusable insight;
- supporting evidence or an example from this session; and
- a meaningful limitation, caveat, or context boundary.

If these are absent, say that the session does not contain enough supported,
reusable material and stop. Do not force a reflection post and do not create a
branch or pull request.

## 2. Draft the complete post

Draft a concise, first-person learning note using the policy.

Use:

- `_posts/YYYY-MM-DD-slug.md`;
- the current UTC date and time;
- `layout: post`;
- two to five lowercase, normalised tags;
- a concise excerpt;
- `toc: true`; and
- sections covering context, insight, evidence or example, caveats, and
  takeaway.

Do not overwrite or reuse an existing destination. If the filename is already
present in the blog repository, ask the user to choose a different slug.

Generalise local paths, private repository names, usernames, internal URLs, and
other identifying details before showing the draft. Do not include credentials
or suspected secrets.

### Make the draft visible before asking for approval

When an editor canvas is available:

1. Persist the complete Markdown as a session-scoped workspace artifact named
   `learning-post-draft.md`. Do not write it into the invoking repository.
2. Open or focus that artifact in the editor canvas with a clear
   `Learning post draft` title.
3. Tell the user that the draft is visible in the editor and is not yet a
   repository file.
4. Use a separate, short approval prompt that asks whether the visible draft
   accurately captures the learning.

If no editor canvas is available, show the complete Markdown in a normal chat
response first. Ask the short approval question only in the following turn.

Never place the full article inside an approval control or `ask_user` question:
long controls may be truncated, dismissed, or unavailable, leaving the user
unable to inspect what they are being asked to approve.

If the user requests changes, update the persisted artifact or show the complete
revised Markdown again before presenting another short approval prompt.

## 3. Choose the editing handoff

After the user approves the initial Markdown, use the app flow only when the
app's project/session tools are available. If tool availability is uncertain,
use the standalone flow.

### Copilot app flow

1. Find the configured project whose GitHub repository is
   `Gary-H9/gary-h9.github.io`.
2. Create a dedicated worktree session based explicitly on `gh-pages`.
3. Start it in interactive mode with the approved Markdown, destination path,
   this policy, and the remaining approval steps in its kickoff prompt.
4. Let the user continue the editorial conversation in that session.

The child session must not create a pull request merely because it received the
initial draft.

### Standalone CLI flow

Keep the editorial conversation in the current session. Do not modify the
invoking repository. Continue to show the complete Markdown after each
substantive revision.

Before publishing, require `gh auth status` to succeed for an account with
write access to `Gary-H9/gary-h9.github.io`. If it does not, stop and explain
the prerequisite.

## 4. Apply the final pre-PR gates

When the user says editing is finished:

1. Ask for explicit approval of the final, complete Markdown.
2. Separately ask:

   > This post will be public. Have you confirmed that you have the right to
   > publish all included text and code, and that it contains no confidential,
   > personal, employer, customer, or credential material?

3. Save the exact approved Markdown to a temporary file or the intended post
   file.
4. Run `scripts/scan-draft.sh` from this skill against that file.

Any negative answer or scanner finding blocks branch and pull request creation.
Revise, show the complete Markdown again, and repeat both approvals and the
scan. Never describe the scanner or model review as perfect detection.

## 5. Create the pull request

The fixed repository is `Gary-H9/gary-h9.github.io`, and the fixed base branch
is `gh-pages`. Never branch from the invoking repository or its current branch.

In an app worktree, create the approved post, verify that no existing post is
being replaced, run the scanner, commit the post, push the branch, and open a
pull request targeting `gh-pages`.

In standalone CLI, run `scripts/create-post-pr.sh` from this skill with the
approved Markdown file, destination path, and PR title. The helper creates a
new branch from the latest `gh-pages`, adds only the new post, and opens the
pull request without merging it.

## 6. Validate before publication

Wait for the pull request checks to finish. The required post validation must
include the sensitive-pattern scan and the production CSS/Jekyll build.

If a check fails, do not merge. Return to editing or fix the validation problem,
then wait for checks again.

After all checks pass, explain that merging to `gh-pages` publishes the post
and ask for a separate, explicit merge confirmation. Merge only after that
confirmation. Never enable auto-merge or infer merge approval from an earlier
draft or PR approval.
