# Learning post authoring policy

## Purpose and voice

Write a concise first-person learning note, not a transcript and not a
comprehensive tutorial. Preserve the author's actual level of certainty.

Use this default shape:

1. Context: the problem or question that led to the learning.
2. Insight: the reusable idea in plain language.
3. Evidence or example: the smallest session-supported example that makes the
   insight concrete.
4. Caveats: where the idea does not apply or what remains uncertain.
5. Takeaway: what the author will do differently next time.

Prefer clear, direct prose. Remove repetition and session logistics that do not
help a reader understand the learning.

## Jekyll format

Posts live at `_posts/YYYY-MM-DD-slug.markdown` and use:

```yaml
---
layout: post
title: "A clear, specific title"
date: YYYY-MM-DD HH:MM:SS +0000
tags: [two, useful-tags]
excerpt: "A concise description of the learning."
toc: true
---
```

- Use the current UTC date and time for publish-now posts.
- Use a lowercase ASCII slug containing letters, numbers, and hyphens.
- Reject filename collisions; never overwrite an existing post.
- Use two to five lowercase, consistently spelled tags.
- Keep the excerpt concise and useful in article lists and metadata.
- Use H2 and H3 headings so `toc: true` can generate navigation.
- Add language identifiers to fenced code blocks.
- Add descriptive alt text to any image.

## Evidence and citations

- Include only claims supported by the current conversation or its tool
  results.
- Link primary sources when they were consulted in the session and are safe to
  publish.
- Distinguish observed behaviour from inference.
- State unresolved uncertainty instead of filling it with model knowledge.
- Do not invent benchmarks, quotations, links, API behaviour, or outcomes.
- Keep third-party quotations and code excerpts short and necessary. Prefer a
  summary and a link to the original source.

## Privacy, security, and publication rights

- Omit or generalise local file system paths, private repository names,
  usernames, internal hosts, issue links, customer or employer details, and
  other identifying context.
- Never include credentials, tokens, cookies, private keys, connection strings,
  or suspected secrets, including values that may already have expired.
- Do not publish proprietary or confidential code.
- Do not assume that content visible to Copilot is cleared for public use.
- Require the author to confirm both the right to publish the material and the
  absence of confidential or personal content before creating a pull request.
- Treat automated and model-based scanning as defence in depth, not a guarantee.

## Editorial boundaries

- Do not manufacture a post when the session lacks a clear, supported learning.
- Do not present Copilot's suggestion as something the author personally
  verified unless the session contains that verification.
- Do not turn uncertainty into authoritative advice.
- Do not add promotional claims, SEO filler, or unrelated background solely to
  make the post longer.

## Workflow dependencies

- Pin every third-party GitHub Action to the full commit SHA of its latest
  supported release and retain the release tag in a comment.
- Use the latest stable supported language runtime. For production Node.js
  workflows, use the latest LTS release rather than a non-LTS Current release.
- Verify action releases and runtime support against their authoritative
  upstream sources whenever a workflow is created or updated.
