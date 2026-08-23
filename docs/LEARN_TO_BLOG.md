# Learn-to-Blog Copilot Skill

The `learn-to-blog` skill turns a supported learning from the current Copilot
conversation into a reviewed post for this blog.

It is a personal skill invoked in a prompt:

```text
Use /learn-to-blog
```

Copilot CLI does not support adding a new native interactive command alongside
built-in commands such as `/diff`. The slash-prefixed name in the prompt
explicitly selects the personal skill.

## Install

Keep a stable checkout of this repository, then register its skills directory:

```bash
copilot skill add /absolute/path/to/gary-h9.github.io/.github/skills
```

The registration points to that directory rather than copying it. Do not use a
disposable worktree path.

For a Copilot session that is already running:

```text
/skills reload
/skills info learn-to-blog
```

From a terminal, `copilot skill list` also shows discovered skills.

Registration is local to a machine and must be repeated on each machine where
the skill should be available.

## Workflow

1. The skill decides whether the current conversation contains a clear,
   reusable learning supported by session evidence. If not, it stops.
2. It displays the complete proposed Jekyll Markdown, including front matter,
   for accuracy review.
3. In the Copilot app, it creates an interactive blog worktree session based on
   `gh-pages`. In standalone CLI, editing remains in the current chat.
4. After editing, it separately requires final Markdown approval and
   confirmation that the material is cleared for public publication.
5. It runs the bundled sensitive-pattern scanner. Findings block publication.
6. It creates a new post branch from `gh-pages` and opens a pull request.
7. GitHub Actions scans the changed post and runs the production CSS/Jekyll
   build without deploying.
8. After checks pass, the skill explains that merge means publication and asks
   for a separate merge confirmation.

No earlier approval authorises a later gate.

## App and standalone behaviour

When the Copilot app's project/session tools are available, the skill finds the
project for `Gary-H9/gary-h9.github.io` and creates a dedicated worktree so the
editorial conversation does not modify an unrelated repository.

In standalone Copilot CLI, the skill requires an authenticated GitHub CLI
account with write access:

```bash
gh auth status
```

The bundled PR helper uses GitHub APIs directly. It does not modify the
invoking repository, overwrite an existing post, merge the PR, or enable
auto-merge.

## Public repository warning

`gh-pages` is both the source branch and the production deployment branch.
Merging a post PR publishes it through the Pages deployment workflow.

The workflow uses defence in depth:

- model-based omission and generalisation;
- a deterministic scanner for common sensitive patterns;
- GitHub push protection where available; and
- explicit human confirmation that the content is safe and authorised for
  public publication.

These checks reduce risk but cannot guarantee detection of every secret,
personal detail, confidential fact, or publication-rights problem. The author
remains responsible for the final public-content review.
The canonical workflow and policy live in
`.github/skills/learn-to-blog/`.

## Workflow dependency policy

All third-party GitHub Actions are pinned to the full commit SHA of their latest
supported release, with the corresponding release tag retained as a comment.
Workflow language runtimes use the latest stable supported release; Node.js
uses the latest production LTS release rather than the non-LTS Current line.

When changing a workflow, verify both the action releases and runtime versions
against their authoritative upstream sources, then run the production build
with the selected runtimes.

Dependabot checks GitHub Actions, Bundler, npm, and Docker dependencies weekly.
It can update SHA-pinned action references, but it does not update workflow
runtime inputs or `.tool-versions`; those versions still require the manual
upstream check described above.
