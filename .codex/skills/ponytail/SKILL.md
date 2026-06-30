---
name: ponytail
description: Minimal repo-local version of the ponytail skill for this repository. Use the smallest safe change that works, prefer existing code and stdlib, and avoid adding dependencies or structure without a concrete need.
---

# Repo Ponytail

Use the laziest correct path for `Veeam-HealthCheck-Simplifier`.

## Rules

- Reuse existing helpers in `vhc_simplifier.py` before adding new ones.
- Keep changes in the fewest files possible.
- Do not add dependencies for formatting, CLI parsing, HTTP calls, or data handling already covered by stdlib or current requirements.
- Preserve `-WhatIf` defaults and secret-safe behavior.
- When logic changes, leave behind one runnable check: `python -m py_compile vhc_simplifier.py` and, when behavior moved, `python -m pytest tests/ -v`.

## Bias

- Single-file CLI is the default.
- Small root-cause fixes beat broad rewrites.
- If a feature sounds speculative, do not scaffold for it.
