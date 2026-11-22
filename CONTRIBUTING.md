# Contributing to Agent Etiquette (`CONTRIBUTING.md`)

Thank you for contributing to **Agent Etiquette**! Both **human engineers** and **AI coding agents** are welcome to contribute governance schemas, loop-prevention rules, and multi-agent verification scripts.

---

## 1. High-Impact Ways to Contribute
- **Handoff Schema Refinements (`schemas/`):** Strengthen JSON Schema Draft-07 contracts for structured inter-agent handoffs and `verified_artifacts`.
- **Validation & Guardrail Scripts (`scripts/` & `tests/`):** Add zero-bloat validators for Rule-of-2 escalation, concurrency caps, and dead-artifact detection.
- **Cross-Model Compatibility Guides (`docs/` & `skills/`):** Document tested patterns that keep Claude, Gemini, GPT/Codex, Cursor, Windsurf, Antigravity, Copilot, OpenHands, and local LLMs aligned.

## 2. Human & AI Agent Guardrails (`AGENTS.md` + `llms.txt`)
- **Model-Agnostic First:** Never introduce vendor-locked syntax into core governance files.
- **Visible Files Only:** Keep `AGENTS.md`, `llms.txt`, `HANDOFF.md`, `mistakes.md`, `schemas/`, and `skills/` visible at the repository root.
- **Rule of 2 & Concurrency Cap:** All workflow examples must respect the max 3-agent concurrency cap and halt after 2 failed verification retries.

## 3. 60-Second Verification Gate (Required Before Every PR)
```bash
ls -la AGENTS.md HANDOFF.md mistakes.md llms.txt schemas/ skills/
```

## 4. 3-Step Pull Request Workflow
1. **Fork & Branch:** `git checkout -b feat/your-governance-improvement`
2. **Verify Locally:** Run any schema/test checks and confirm all root entrypoints remain clean and under weight budgets.
3. **Submit a Pull Request:** Open a PR against `main` with your verification output.

## 5. IP Safety & MIT License
All contributions must be original clean-room work and are licensed under the repository's [MIT License](LICENSE).
