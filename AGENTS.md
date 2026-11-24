# Agent Etiquette — Fractal Agent Contract (`AGENTS.md`)

- **Pillar:** CRTA Tech Solutions (Public MIT Open-Source Toolkit)
- **North Star:** Multi-agent workflow governance with hard concurrency caps, typed JSON handoff schemas, and a Rule-of-2 circuit breaker.

## Hard Phase Locks & Guardrails
- **Concurrency Cap:** Maximum **3 concurrent agents** active at any time.
- **Rule of 2:** Maximum **2 consecutive retries** on any failing step; halt and escalate on failure #2.
- **Verification Gate:** Never claim a file, command, URL, or action succeeded without direct tool output.

## Stack, Entry Points & Verification
- **Stack:** JSON Schema (Ajv), Node/Bun validation script, cross-model Markdown skills.
- **Entry Points:** `skills/agent-etiquette/SKILL.md`, `schemas/handoff.json`, `scripts/validate-handoff.mjs`, `scripts/install-agent-etiquette.sh`.
- **Verification:** `/Users/kelli/.bun/bin/bun scripts/validate-handoff.mjs schemas/handoff.json` (or `node scripts/validate-handoff.mjs <handoff.json>`).

## Pointers
- State & Index: [`HANDOFF.md`](HANDOFF.md) · [`mistakes.md`](mistakes.md) · [`llms.txt`](llms.txt)
- Active Signature: `> 🟡 **𝔸𝔾𝔼ℕ𝕋-𝔼𝕋𝕀ℚ𝕌𝔼𝕋𝕋𝔼** · \`RULE-OF-2 GOVERNANCE\` — *Active on this step*`

## 4-Stage Loop
1. **Frame:** Define agent ownership and `task_id` before spawning work.
2. **Bridge:** Enforce max 3 agents, Rule of 2, and verified-artifact-only handoffs.
3. **Proof:** Validate handoff JSON against `schemas/handoff.json`.
4. **Push-Off:** Update `HANDOFF.md` and escalate cleanly if `retry_count === 2`.

## Live State & Next Action
- **State:** `v1.1.0` live on GitHub and pinned across CRTA repositories.
- **Next Action:** Keep `schemas/handoff.json` backward-compatible when adding new project fields.
