---
applyTo: ".github/workflows/**/*.yml,.github/workflows/**/*.yaml"
---

# GitHub Actions dependencies

- Pin every third-party action to the full commit SHA of its latest supported
  release. Add the release tag as an inline comment for readability.
- Use the latest stable supported language runtime.
- For production Node.js workflows, use the latest LTS release rather than a
  non-LTS Current release.
- Verify action releases, commit SHAs, and runtime support against authoritative
  upstream sources whenever creating or updating a workflow.
- Keep validation and deployment workflows on the same runtime versions.
- Keep `.github/dependabot.yml` enabled for GitHub Actions, Bundler, npm, and
  Docker updates. Dependabot does not update workflow runtime inputs or
  `.tool-versions`, so check those versions manually.
