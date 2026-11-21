# Agent Etiquette — Controlled Rollout Manifest

Protocol Source: `https://github.com/kelli-dotcom/agent-etiquette`
Pinned Version: `v1.0.0` (Universal Deployment PR branch: `feat/universal-deployment`)

| Repository | Visibility | Protocol Version | Installation Method | Existing Instructions Preserved | Validation Results | Branch / PR Reference | Blockers & Outstanding Actions |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| `agent-etiquette` | PUBLIC | `v1.0.0` | Source repository (installer + validator + setup guide + 11-scenario QA suite) | Yes (`AGENTS.md`, `SKILL.md`, `handoff.json` preserved) | PASS (11/11 QA scenarios via `bun tests/install-and-schema.test.mjs`) | `feat/universal-deployment` | Awaiting user review & merge approval |
| `getcrowd` | PRIVATE | `v1.0.0` | Compose Layer 3 block into `AGENTS.md` + install `skills/agent-etiquette/` & `schemas/` | Yes (root `AGENTS.md`, 5 existing `skills/`, `handoff/` CSV dir untouched) | Pending Stage 2 approval | — | Awaiting Stage 1 sign-off; target `dev/evidence-and-rules-clarity` (never `main`) |
| `github-trending-kit` | PUBLIC | `v1.0.0` | Compose Layer 3 block into root `AGENTS.md` + install `skills/agent-etiquette/` & `schemas/` | Yes (root `AGENTS.md` + 3 existing skills untouched) | Pending Stage 2 approval | — | Awaiting Stage 2 approval |
| `archetype-agent-vault` | PUBLIC | `v1.0.0` | Create root `AGENTS.md` (Layer 3) + install `skills/agent-etiquette/` & `schemas/` | Yes (8 nested suite `AGENTS.md` & 31 skills untouched) | Pending Stage 2 approval | — | Awaiting Stage 2 approval (flag Entrance Banner vs Zero-Filler as Layer 4 persona override) |
| `school-kitchen-os` | PRIVATE | `v1.0.0` | Compose Layer 3 block into root `AGENTS.md` + install `skills/agent-etiquette/` & `schemas/` | Yes (root `AGENTS.md` untouched) | Pending Stage 2 approval | — | Awaiting Stage 2 approval |
| `worth-knowing` | PRIVATE | `v1.0.0` | Fresh install via PR branch | N/A (no existing `AGENTS.md`) | Pending Stage 2 approval | — | Awaiting Stage 2 approval |
| `kelli-dotcom.github.io` | PUBLIC | `v1.0.0` | Optional fresh install via PR branch | N/A (static site) | Skipped pending confirmation | — | Confirm if static GitHub Pages repo should receive protocol |
| `Kelli-dotcom` | PUBLIC | — | Skip | N/A (1-file GitHub profile README) | Skipped | — | Not a code repository |
| `kelli-dotcom-getcrowd` | PRIVATE | — | Skip / Flagged | N/A (empty repo, no default branch) | Blocked (empty repo) | — | Empty repository — initialize or archive |
