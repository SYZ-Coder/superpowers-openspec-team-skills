# Security Policy

## Scope

This repository primarily contains:

- workflow definitions
- install scripts
- memory and validation scripts
- tool-adapted bundles for AI coding assistants

Security reports are especially relevant when they involve:

- install script behavior
- unsafe file writes or path handling
- unintended workflow auto-activation
- memory leakage across repositories or users
- dangerous default execution paths

## Supported State

Security fixes are most likely to be considered for the current default branch and the latest published repository state.

This repository does not currently maintain long-term support branches.

## How To Report A Vulnerability

Please do not open a public issue for a suspected security problem before maintainers have had a chance to review it.

Instead, report:

- what component is affected
- how to reproduce the issue
- what the impact is
- whether a workaround exists

If GitHub Security Advisories are enabled later, prefer private reporting there.

Until then, use the maintainer contact method associated with the repository or open a minimal, non-exploitative private communication channel if available.

## Good Reports Include

- affected file paths
- exact commands used
- operating system and shell
- expected behavior
- actual behavior
- why the issue matters

## Out Of Scope

The following are usually out of scope unless they create a concrete security impact:

- documentation typos
- wording disagreements
- feature requests
- missing convenience automation
- theoretical issues without a reproducible path

## Safe Handling Expectations

Contributors should be especially careful around:

- recursive file operations
- installer overwrite behavior
- path normalization
- command injection risks in shell and PowerShell scripts
- unintended writes outside the target repository

## Disclosure Process

After receiving a credible report, the expected process is:

1. confirm whether the issue is reproducible
2. assess impact and affected paths
3. prepare a fix
4. update verification guidance if needed
5. disclose publicly after a fix is available, when appropriate
