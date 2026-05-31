# Veeam-HealthCheck-Simplifier

**Veeam Health Check Simplifier** — a security-focused CLI pipeline that ingests Veeam Backup & Replication health check exports (CSV or JSON), analyzes them for compliance gaps, and generates safe, reviewable remediation artifacts.

---

## Features

- **Multi-format input** — CSV (default, from [vee.am/vhc2](https://vee.am/vhc2)) or JSON (VBR REST API exports)
- **Demo mode** — runs instantly with embedded real-world sample data; no input files required
- **Secure PowerShell output** — all mutating commands (`Set-`, `New-`, `Remove-`, etc.) include `-WhatIf` by default
- **PS injection prevention** — object names with control characters are refused, not interpolated
- **Salesforce integration** — creates Tasks on an Account record for High/Medium findings
- **Slack notifications** — posts a severity summary to an incoming webhook
- **Graceful degradation** — missing input files are logged but never fatal; partial runs proceed
- **No secrets in code** — Salesforce credentials resolved from environment variables only

## Generated Artifacts

| File | Description |
|---|---|
| `remediation_summary.md` | Human-readable findings with PowerShell snippets and KB links |
| `fixit.ps1` | Safe preview remediation script (`-WhatIf` on all mutating commands) |
| `tickets.json` | ITSM-ready JSON payload (High/Medium findings only) |

---

## Requirements

- Python 3.12+ (tested on 3.12 and 3.13)
- `pandas` (core dependency)
- `simple-salesforce` *(optional — only for `--sf-account-id`)*
- `httpx` *(optional — Slack fallback uses stdlib `urllib` if absent)*

```bash
pip install -r requirements.txt
```

---

## Quick Start

```bash
# Demo mode (no files needed)
python vhc_simplifier.py --demo

# Real CSV export (from vee.am/vhc2)
python vhc_simplifier.py --input-dir ./vhc-exports --output-dir ./results

# JSON / VBR REST API export
python vhc_simplifier.py --input-dir ./vhc-json --input-format json

# With Salesforce Task creation
export SF_USERNAME=user@domain.com
export SF_PASSWORD=yourpassword
export SF_TOKEN=yoursecuritytoken
python vhc_simplifier.py --demo --sf-account-id 001XXXXXXXXXXXX

# With Slack notification
python vhc_simplifier.py --input-dir ./vhc-exports --slack-webhook https://hooks.slack.com/...
```

---

## CLI Reference

| Flag | Default | Description |
|---|---|---|
| `--input-dir` | `.` | Directory containing VHC export files |
| `--output-dir` | `.` | Directory for generated artifacts |
| `--input-format` | `csv` | Input format: `csv` or `json` |
| `--demo` | off | Use embedded sample data (no files needed) |
| `--no-artifacts` | off | Skip writing `.md`/`.ps1`/`.json` files |
| `--quiet` | off | Suppress console report |
| `--sf-account-id` | — | Salesforce Account ID for Task creation |
| `--sf-username` | — | SF username (prefer `SF_USERNAME` env var) |
| `--sf-password` | — | SF password (prefer `SF_PASSWORD` env var) |
| `--sf-token` | — | SF security token (prefer `SF_TOKEN` env var) |
| `--slack-webhook` | — | Slack incoming webhook URL |

---

## Expected Input Files

| Key | CSV filename | JSON filename |
|---|---|---|
| Jobs | `localhost_Jobs.csv` | `localhost_Jobs.json` |
| Sessions | `VeeamSessionReport.csv` | `VeeamSessionReport.json` |
| Security | `localhost_SecurityCompliance.csv` | `localhost_SecurityCompliance.json` |
| Repositories | `localhost_Repositories.csv` | `localhost_Repositories.json` |
| Malware | `localhostmalware_events.csv` | `localhostmalware_events.json` |

All files are optional — missing files are logged and skipped without aborting.

---

## Architecture

```
Input (CSV / JSON / --demo)
        |
        v
  _safe_load_*()       <- adapter layer (swap format here only)
        |
        v
  analyze_*()          <- pure functions, fault-isolated per domain
        |
        v
  enrich_findings()    <- pattern-matched remediation + PS injection guard
        |
        |---> write_markdown()
        |---> write_powershell_script()
        |---> write_ticket_payload()
        |---> _push_to_salesforce()   (optional)
        `---> _post_slack_summary()   (optional)
```

---

## Exit Codes

| Code | Meaning |
|---|---|
| `0` | Success |
| `2` | Processing errors occurred (check stderr / logs) |

---

## Security Notes

- **Never commit credentials.** Use env vars (`SF_USERNAME`, `SF_PASSWORD`, `SF_TOKEN`) or a secrets manager.
- **Review `-WhatIf` output before removing it.** Validate every command in a non-production environment first.
- **Injection prevention.** Object names with ASCII control characters (`0x00–0x1F`, `0x7F`) are refused from PS command generation entirely.

---

See [LICENSE.md](LICENSE.md) and [CONTRIBUTORS.md](CONTRIBUTORS.md).
