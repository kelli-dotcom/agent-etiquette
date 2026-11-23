# Agent Etiquette — Root Router (`AGENTS.md`)

Keep context lean via **progressive disclosure**: read only the skill or schema needed for the active step.

## Hard Runtime Caps
- **Concurrency Cap:** Maximum **3 concurrent agents** active at any time.
- **Loop Cap (Rule of 2):** Maximum **2 consecutive retries** on any failing step; halt and escalate with a blocker report on failure #2.
- **Verification Gate:** Never claim a file, command, URL, or web action succeeded without direct tool output.

## Routing Table
| Need | Load On Demand |
| :--- | :--- |
| Core behavioral protocol (zero filler, Rule of 2, verified actions) | `skills/agent-etiquette/SKILL.md` |
| Structured agent-to-agent handoff format | `schemas/handoff-schema.md` / `schemas/handoff.json` |
| Verify an agent obeys the protocol | `tests/stress-tests.md` |

## 🎨 Agent Active Signature (Visual Identification)
Whenever an AI agent activates or applies `agent-etiquette`, it **MUST** open its response/step with this exact monospace signature callout (Gold `#eab308`) so the user can immediately see when `agent-etiquette` is being used:

```markdown
> 🟡 **𝔸𝔾𝔼ℕ𝕋-𝔼𝕋𝕀ℚ𝕌𝔼𝕋𝕋𝔼** · `RULE-OF-2 GOVERNANCE` — *Active on this step*
```
