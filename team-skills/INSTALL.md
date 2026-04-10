# Team Skills Installation Guide

This guide explains how to install and run the workflow skills in this repository.

If you only want to read, review, or maintain the documentation, you do not need to install OpenSpec or Superpowers. The runtime setup below is only required when an agent should actually execute these workflows.

## Package Overview

The workflow packages are stored in this repository under `team-skills/`:

- [openspec-superpowers-workflow](openspec-superpowers-workflow/README.md)
- [superpowers-openspec-execution-workflow](superpowers-openspec-execution-workflow/README.md)
- [superpowers-feature-workflow](superpowers-feature-workflow/README.md)
- [openspec-feature-workflow](openspec-feature-workflow/README.md)

Each package contains:

- `SKILL.md`: the executable workflow instruction.
- `README.md`: an English workflow introduction.
- `readme_cn.md`: a Chinese workflow introduction.
- `agents/openai.yaml`: lightweight agent UI metadata.

## Runtime Requirements

To execute the workflows, prepare these pieces:

- A skill-capable agent runtime, such as Codex.
- A project repository where the agent can write design docs, plans, OpenSpec changes, code, tests, and verification output.
- OpenSpec CLI, required by OpenSpec-related workflows.
- Superpowers base skills, required by Superpowers-related workflows.
- This repository's team workflow skills, copied into the runtime skill directory.

The workflow skills in this repository are orchestrators. They assume the runtime can also invoke the underlying OpenSpec and Superpowers skills they reference.

## Install OpenSpec CLI

OpenSpec is required when using:

- `openspec-superpowers-workflow`
- `superpowers-openspec-execution-workflow`
- `openspec-feature-workflow`

Install the CLI with npm:

```bash
npm install -g @fission-ai/openspec@latest
```

Verify the installation:

```bash
openspec --version
```

If `openspec` is not found, confirm that your global npm binary directory is on `PATH`.

On Windows PowerShell, you can usually verify npm's global binary path with:

```powershell
npm bin -g
```

## Install Superpowers Base Skills

Superpowers is required when using:

- `openspec-superpowers-workflow`
- `superpowers-openspec-execution-workflow`
- `superpowers-feature-workflow`

These workflows refer to Superpowers skills such as:

- `brainstorming`
- `writing-plans`
- `using-git-worktrees`
- `test-driven-development`
- `verification-before-completion`
- `finishing-a-development-branch`

Install the Superpowers skill collection according to your agent runtime's instructions. For a Codex-style setup, the important result is that the Superpowers skill folders are available in the runtime skill directory, for example:

```text
~/.codex/skills/
```

or on Windows:

```text
%USERPROFILE%\.codex\skills\
```

If your runtime uses a different skill directory, use that directory instead.

## Install This Team Skill Pack

Copy the workflow folders from this repository into your runtime skill directory.

### macOS / Linux

From the repository root:

```bash
mkdir -p ~/.codex/skills
cp -R team-skills/openspec-superpowers-workflow ~/.codex/skills/
cp -R team-skills/superpowers-openspec-execution-workflow ~/.codex/skills/
cp -R team-skills/superpowers-feature-workflow ~/.codex/skills/
cp -R team-skills/openspec-feature-workflow ~/.codex/skills/
```

### Windows PowerShell

From the repository root:

```powershell
$skillDir = Join-Path $env:USERPROFILE ".codex\skills"
New-Item -ItemType Directory -Force -Path $skillDir
Copy-Item -Recurse -Force team-skills\openspec-superpowers-workflow $skillDir
Copy-Item -Recurse -Force team-skills\superpowers-openspec-execution-workflow $skillDir
Copy-Item -Recurse -Force team-skills\superpowers-feature-workflow $skillDir
Copy-Item -Recurse -Force team-skills\openspec-feature-workflow $skillDir
```

## Verify Skill Availability

Restart or reload your agent runtime after copying skills.

Then ask the agent to use one workflow explicitly:

```text
Use $openspec-superpowers-workflow to run this feature from clarification through verification.
```

If the runtime reports that the skill is missing:

- Confirm the folder name matches the `name` field in `SKILL.md`.
- Confirm `SKILL.md` is directly inside the copied workflow folder.
- Confirm the folder was copied into the runtime's active skill directory.
- Restart the runtime so it can rediscover skills.

## Verify OpenSpec Availability

In a project that uses OpenSpec, run:

```bash
openspec status
```

For a specific change, the workflow expects commands like:

```bash
openspec status --change "<change-name>" --json
openspec instructions apply --change "<change-name>" --json
```

If these fail, install or update OpenSpec before running OpenSpec-related workflows.

## Recommended Prompts

Full OpenSpec plus Superpowers flow:

```text
Use $openspec-superpowers-workflow to run this feature from clarification through verification.
```

Three-stage flow:

```text
Use $superpowers-openspec-execution-workflow for this feature: first explore with Superpowers, then lock the change with OpenSpec, then return to Superpowers for implementation, testing, verification, and archive.
```

Superpowers-only feature flow:

```text
Use $superpowers-feature-workflow to drive the Superpowers stages for this feature request.
```

OpenSpec-only artifact flow:

```text
Use $openspec-feature-workflow to create and complete the OpenSpec change for this feature.
```

## Maintenance Notes

- Keep workflow folders portable: avoid machine-specific paths.
- Keep `SKILL.md` focused on executable workflow instructions.
- Keep `README.md` and `readme_cn.md` focused on human-readable introductions.
- Re-copy updated workflow folders into the runtime skill directory after changing this repository.
