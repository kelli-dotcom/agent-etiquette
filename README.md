# Agent Etiquette

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![CRTA Crafted](https://img.shields.io/badge/CRTA-Crafted-6f42c1.svg)](https://github.com/topics/crta-crafted)

Multi-agent workflow rules, structured handoff schemas, and loop caps for AI coding agents.

- **What:** A lightweight, standalone protocol (`AGENTS.md` + `SKILL.md` + JSON handoff schema + stress tests) that stops AI coding agents from rambling, hallucinating completed work, or spinning in infinite retry loops.
- **Why:** Multi-agent runs fail predictably — agents burn tokens on filler, retry broken commands forever, lose state between handoffs, and overload context windows.
- **Who:** Solo builders, engineering teams, and anyone orchestrating AI coding assistants across local or mobile workflows.
- **When:** Drop into any repository at project start or before running multi-agent / long-running coding tasks.
- **How:** Point your root `AGENTS.md` at `skills/agent-etiquette/SKILL.md` so rules load progressively on demand without duplicating files.

## Repository Directory

| File | Purpose |
| :--- | :--- |
| [`AGENTS.md`](AGENTS.md) | Lightweight root router & progressive-disclosure pointer (3-agent concurrency cap) |
| [`skills/agent-etiquette/SKILL.md`](skills/agent-etiquette/SKILL.md) | Core behavioral protocol (Zero Filler, Verified Actions Only, Rule of 2, Concurrency Cap) |
| [`schemas/handoff-schema.md`](schemas/handoff-schema.md) | Human-readable multi-agent handoff contract & example |
| [`schemas/handoff.json`](schemas/handoff.json) | Machine-validatable JSON Schema for agent handoffs |
| [`tests/stress-tests.md`](tests/stress-tests.md) | 4 prompt-based compliance tests for any coding agent |
| [`CHANGELOG.md`](CHANGELOG.md) | Release history (`v1.0.0`) |
| [`LICENSE`](LICENSE) | MIT License (CRTA Tech Solutions) |

## Quick Start

### Progressive-Disclosure Pointer (Recommended — Zero File Duplication)
Add one line to your project's root `AGENTS.md`:
```markdown
- Follow `skills/agent-etiquette/SKILL.md` (Rule of 2, verified actions only, 3-agent cap) and pass handoffs via `schemas/handoff.json`.
```

<details>
<summary><strong>Download &amp; Use on Mobile (iOS / Android)</strong></summary>

**[Download ZIP (Mobile-Friendly)](https://github.com/kelli-dotcom/agent-etiquette/archive/refs/heads/main.zip)**

- **iPhone (iOS):** Tap **Download** → open **Files** → **Downloads** → tap the `.zip` once to unzip.
- **Android:** Tap **Download** → open **My Files / Files** → **Downloads** → tap the `.zip` and select **Extract**.
- **Browser Alternative:** Tap **Request Desktop Website** in Safari/Chrome to reveal the green **Code → Download ZIP** button.
- **Use on Mobile:** Attach `AGENTS.md`, `skills/agent-etiquette/SKILL.md`, or `schemas/handoff.json` directly in Gemini, Claude, or ChatGPT (or upload them once into a Gemini Gem / Claude Project), or sync via Working Copy / Codespaces / Replit.

</details>

---

✨ *Crafted with main-character energy by **CRTA*** • GitHub Topic: `crta-crafted`
