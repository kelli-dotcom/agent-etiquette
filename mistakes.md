# Mistakes & Guardrails (`mistakes.md`)

## Never Repeat
1. **Hidden Agent Files:** Never store agent instructions, skills, or handoffs in hidden dot-files/folders (except where runtime/tooling strictly requires it). Always keep `AGENTS.md`, `llms.txt`, `HANDOFF.md`, `mistakes.md`, and `skills/` visible at the repo root.
2. **Model-Locked Instructions:** Never write instructions that only work for one vendor/model. Keep `AGENTS.md` and `llms.txt` plain, vendor-neutral Markdown so Claude, Gemini, GPT/Codex, Cursor, Antigravity, Copilot, OpenHands, and local LLMs all parse them cleanly.
3. **Prose Handoffs:** Never pass raw HTML or unstructured prose dumps between agents—always validate structured JSON handoffs with `verified_artifacts`.
