# Changelog

All notable changes to `superpowers-openspec-team-skills` should be documented in this file.

This project does not yet publish formal releases for every change. Until that stabilizes, this changelog records the current repository baseline and major capability additions.

## Unreleased

### Added

- repo-persisted Superpowers memory scaffold under `.superpowers-memory/`
- expanded memory surfaces including `DECISIONS.md`, `KNOWN_FAILURES.md`, `VERIFICATION_BASELINE.md`, `TEAM_PREFERENCES.md`, `USER_PROFILE.md`, and `AGENT_NOTES.md`
- `SESSION_CLOSE_CHECKLIST.md` and `memory-index.yaml` support
- memory validation scripts:
  - `scripts/validate-superpowers-memory.ps1`
  - `scripts/validate-superpowers-memory.sh`
- memory search scripts:
  - `scripts/search-superpowers-memory.ps1`
  - `scripts/search-superpowers-memory.sh`
- memory update suggestion scripts:
  - `scripts/suggest-superpowers-memory-updates.ps1`
  - `scripts/suggest-superpowers-memory-updates.sh`
- standardized closeout helper:
  - `scripts/run-superpowers-memory-closeout.ps1`
  - `scripts/run-superpowers-memory-closeout.sh`
- learning candidate promotion draft generation:
  - `scripts/generate-superpowers-promotion-drafts.ps1`
  - `scripts/generate-superpowers-promotion-drafts.sh`
- cross-platform testing documentation:
  - `docs/CROSS_PLATFORM_TESTING.md`
  - `docs/CROSS_PLATFORM_TESTING.cn.md`
- learning/reference documentation:
  - `docs/memory-learning-dialogue.md`
  - `docs/memory-learning-dialogue.cn.md`
  - `docs/memory-learning-appendix.cn.md`
- open-source governance files:
  - `LICENSE`
  - `CONTRIBUTING.md`
  - `SECURITY.md`
  - `.github/PULL_REQUEST_TEMPLATE.md`
  - `.github/ISSUE_TEMPLATE/*`
  - `CODE_OF_CONDUCT.md`
  - `.github/workflows/ci.yml`

### Changed

- aligned workflow docs, memory docs, and verification docs around the enhanced memory model
- upgraded validator behavior from basic structure checks to broader governance checks
- added grouped session-close suggestions and closeout summary output
- improved shell and PowerShell feature parity for memory search and closeout flows
- refreshed major Chinese documentation files to match current repository behavior
- added baseline GitHub Actions checks for repository governance files and memory-script smoke tests

### Known Gaps

- Windows PowerShell workflows have been smoke-tested locally
- Linux and macOS shell scripts have been aligned and documented, but still need full real-environment execution confirmation
