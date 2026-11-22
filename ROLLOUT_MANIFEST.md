# Agent Etiquette — Controlled Rollout Manifest

Protocol Source: `https://github.com/kelli-dotcom/agent-etiquette`
Pinned Version: `v1.1.0` (Release: `https://github.com/kelli-dotcom/agent-etiquette/releases/tag/v1.1.0`)

| Repository | Visibility | Protocol Version | Installation Method | Existing Instructions Preserved | Validation Results | Branch / PR Reference | Blockers & Outstanding Actions |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| `agent-etiquette` | PUBLIC | `v1.1.0` | Source repository (installer + validator + setup guide + 11-scenario QA suite) | Yes (`AGENTS.md`, `SKILL.md`, `handoff.json` preserved) | PASS (11/11 QA scenarios via `bun tests/install-and-schema.test.mjs`) | PR #1 **MERGED** (`v1.1.0`) | None (upload optional Social Preview PNG in GitHub Settings) |
| `getcrowd` | PRIVATE | `v1.1.0` | Compose Layer 3 block into `AGENTS.md` + install `skills/agent-etiquette/` & `schemas/` | Yes (root `AGENTS.md`, 5 existing `skills/`, `handoff/` CSV dir untouched) | PASS (`--verify` + lockfile verified) | `kelli-dotcom/getcrowd#1` **MERGED** into `dev/evidence-and-rules-clarity` | None (`main` untouched per repo guardrail) |
| `github-trending-kit` | PUBLIC | `v1.1.0` | Compose Layer 3 block into root `AGENTS.md` + install `skills/agent-etiquette/` & `schemas/` | Yes (root `AGENTS.md` + 3 existing skills untouched) | PASS (`--verify` + lockfile verified) | `kelli-dotcom/github-trending-kit#1` **MERGED** | None |
| `archetype-agent-vault` | PUBLIC | `v1.1.0` | Compose Layer 3 block into root `AGENTS.md` + install `skills/agent-etiquette/` & `schemas/` | Yes (root `AGENTS.md`, `llms.txt`, System Map `README.md`, 12 nested suite `AGENTS.md` & 43 skills untouched) | PASS (`--verify` + lockfile verified) | `kelli-dotcom/archetype-agent-vault#1` **MERGED** | None |
| `school-kitchen-os` | PRIVATE | `v1.1.0` | Compose Layer 3 block into root `AGENTS.md` + install `skills/agent-etiquette/` & `schemas/` | Yes (root `AGENTS.md` untouched) | PASS (`--verify` + lockfile verified) | `kelli-dotcom/school-kitchen-os#1` **MERGED** | None |
| `worth-knowing` | PRIVATE | `v1.1.0` | Fresh install via PR branch | N/A (no existing `AGENTS.md`) | PASS (`--verify` + lockfile verified) | `kelli-dotcom/worth-knowing#1` **MERGED** | None |
| `kelli-dotcom.github.io` | PUBLIC | `v1.1.0` | Optional fresh install via PR branch | N/A (static site) | Skipped pending confirmation | — | Confirm if static GitHub Pages repo should receive protocol |
| `Kelli-dotcom` | PUBLIC | — | Skip | N/A (1-file GitHub profile README) | Skipped | — | Not a code repository |
| `kelli-dotcom-getcrowd` | PRIVATE | — | Skip / Flagged | N/A (empty repo, no default branch) | Blocked (empty repo) | — | Empty repository — initialize or archive |
