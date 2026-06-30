# AGENTS.md

Repository guidance for Codex in `cgfixit/Veeam-HealthCheck-Simplifier`.

## Scope

- This repo is a single-file Python CLI centered on [vhc_simplifier.py](/C:/Users/cgrady/Documents/Codex/2026-06-30/connect-to-veeam-healthcheck-simplifier-github/vhc_simplifier.py).
- Tests live in [tests/test_vhc_simplifier.py](/C:/Users/cgrady/Documents/Codex/2026-06-30/connect-to-veeam-healthcheck-simplifier-github/tests/test_vhc_simplifier.py).
- There is no package layout, build backend, or lockfile. Keep changes minimal and local.

## Commands

- Install deps: `python -m pip install -r requirements.txt`
- Run demo: `python vhc_simplifier.py --demo`
- Run tests: `python -m pytest tests/ -v`
- Narrow validation: `python -m py_compile vhc_simplifier.py`

## Repo Facts

- Target Python is 3.12+ per README and file header.
- Main outputs are `remediation_summary.md`, `fixit.ps1`, and `tickets.json`.
- Optional integrations are Salesforce and Slack. Never hardcode or log secrets.
- PowerShell output is intentionally safety-biased with `-WhatIf` defaults. Do not remove that without an explicit request.

## Change Rules

- Preserve the single-file CLI structure unless a refactor is explicitly requested.
- Prefer stdlib and existing dependencies over adding packages.
- Keep analyzer logic pure where practical; isolate IO and external integrations.
- Treat credential handling, webhook posting, and generated PowerShell as high-risk paths.
- For mutating behavior, preserve dry-run or safe-preview semantics.

## Validation Expectations

- After editing Python, run `python -m py_compile vhc_simplifier.py`.
- Run `python -m pytest tests/ -v` when the change affects behavior.
- If optional integrations are touched, state what could not be verified without live credentials.
