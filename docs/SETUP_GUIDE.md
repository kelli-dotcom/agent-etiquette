# Agent Etiquette — Cross-Platform Setup Guide

This guide explains how to install, verify, update, and remove **Agent Etiquette** across every supported device and coding environment — without needing to understand agent architecture.

---

## 1. Three Different Ways to Use Agent Etiquette (Not Equivalent)

Before you start, choose the mode that matches what you are doing:

| Mode | What It Does | Persistent in Git? | Automated Validation? |
| :--- | :--- | :---: | :---: |
| **Mode 1: Conversational AI Attachment** | Upload `AGENTS.md`, `SKILL.md`, or `handoff.json` into Gemini, Claude, or ChatGPT chat. | No | No (model follows prompt voluntarily) |
| **Mode 2: Code Repository Installation** | Installs version-pinned files + `agent-etiquette.lock.json` and composes a Layer 3 block into root `AGENTS.md`. | Yes | Optional (`validate-handoff.mjs`) |
| **Mode 3: Coding-Agent Runtime Enforcement** | Antigravity, Cursor, Claude Code, or CI automatically loads `AGENTS.md`, enforces the Rule of 2, and validates handoffs via `scripts/validate-handoff.mjs`. | Yes | Yes |

---

## 2. Plain-Language File Hierarchy (What Goes Where)

```text
your-repo/
├── AGENTS.md                         # Root instructions (your repo rules stay at the top; Agent Etiquette appends safely below)
├── agent-etiquette.lock.json         # Pinned protocol version + SHA-256 checksums for verification & rollback
├── skills/
│   └── agent-etiquette/
│       └── SKILL.md                  # Behavioral rules (zero filler, verified actions, Rule of 2, 3-agent cap)
├── schemas/
│   ├── handoff.json                  # Exact 7-field JSON Schema for inter-agent handoffs
│   └── handoff-schema.md             # Human-readable handoff guide + example
└── scripts/
    └── validate-handoff.mjs          # Zero-dependency validator (Node 18+ or Bun)
```

> **Important:** Keep `skills/agent-etiquette/SKILL.md` and `schemas/handoff.json` in these exact relative paths so links like `../../schemas/handoff.json` never break.

---

## 3. Instruction Hierarchy (5 Layers)

1. **Layer 1 — Platform & Execution Constraints:** Hosting platform safety rules, permissions, and tool sandboxes always win.
2. **Layer 2 — Repository Instructions:** Your existing `AGENTS.md`, architecture locks, and coding standards are never overwritten.
3. **Layer 3 — Agent Etiquette:** Zero filler, verified actions only, Rule of 2 (max 2 retries), max 3 concurrent specialists.
4. **Layer 4 — Task-Specific Skills:** Loaded on demand only when relevant.
5. **Layer 5 — Agent Handoffs:** Structured JSON validated strictly against `schemas/handoff.json`.

---

## 4. Platform-Specific Setup Paths

### Beginner Path — Mobile Only (iOS / iPadOS & Android — Mode 1)
1. Tap **[Download ZIP (Mobile-Friendly)](https://github.com/kelli-dotcom/agent-etiquette/archive/refs/heads/main.zip)**.
2. **iOS / iPadOS:** Open **Files** → **Downloads** → tap the `.zip` once to unzip.
3. **Android:** Open **My Files / Files** → **Downloads** → tap the `.zip` → **Extract**.
4. **Browser Alternative:** Tap **Request Desktop Website** in Safari/Chrome to reveal **Code → Download ZIP**.
5. Attach `AGENTS.md`, `skills/agent-etiquette/SKILL.md`, and `schemas/handoff.json` in Gemini, Claude, or ChatGPT (or save them once inside a Gemini Gem / Claude Project).

### macOS & Linux (Mode 2 & Mode 3)
```bash
curl -fsSL https://raw.githubusercontent.com/kelli-dotcom/agent-etiquette/v1.0.0/scripts/install-agent-etiquette.sh -o /tmp/install-agent-etiquette.sh
bash /tmp/install-agent-etiquette.sh --target /path/to/your-repo --version v1.0.0
```

### Windows (PowerShell or WSL)
- **WSL / Git Bash (recommended):** Run the exact `curl` + `bash` commands from macOS/Linux above.
- **PowerShell (without Bash):** Download and extract `https://github.com/kelli-dotcom/agent-etiquette/archive/refs/tags/v1.0.0.zip`, copy `skills/agent-etiquette/SKILL.md`, `schemas/handoff.json`, `schemas/handoff-schema.md`, and `scripts/validate-handoff.mjs` into your repo root, then append the pointer line from `README.md` to `AGENTS.md`.

### GitHub Codespaces & Browser IDEs (Replit / StackBlitz / Gitpod)
Open the integrated terminal in your workspace root and run:
```bash
bash /path/to/install-agent-etiquette.sh --target . --version v1.0.0
```

### Antigravity & Compatible AI Coding Assistants (Cursor, Claude Code, Codex)
- Antigravity automatically discovers visible root `AGENTS.md` and `skills/agent-etiquette/SKILL.md` (never put agent files in hidden dot-folders).
- Compatible assistants read root `AGENTS.md` on session start and load `skills/agent-etiquette/SKILL.md` on demand.

---

## 5. Verification, Updating & Rollback

### Verify Installation
```bash
bash scripts/install-agent-etiquette.sh --target /path/to/your-repo --version v1.0.0 --verify
node /path/to/your-repo/scripts/validate-handoff.mjs /path/to/handoff.json
```

### Update to a New Pinned Version
```bash
bash scripts/install-agent-etiquette.sh --target /path/to/your-repo --version v1.1.0 --update
```

### Clean Uninstall / Rollback
Removes only files tracked in `agent-etiquette.lock.json` and strips only the `<!-- AGENT-ETIQUETTE:START ... END -->` block from `AGENTS.md` (your repository rules remain untouched):
```bash
bash scripts/install-agent-etiquette.sh --target /path/to/your-repo --uninstall
```

---

## 6. Permissions, Troubleshooting & Common Mistakes
- **Required Permissions:** Write access to the target repository directory (and `Node 18+` or `Bun` for `--verify` / `validate-handoff.mjs`). No GitHub tokens or secrets are ever written into repo files.
- **Common Mistake — Moving `SKILL.md` without `schemas/`:** Breaks `../../schemas/handoff.json`. Always keep the standard root paths.
- **Common Mistake — Treating chat attachments as runtime enforcement:** Chat apps cannot execute `validate-handoff.mjs`; run Mode 2/3 inside a real repo for automated checks.
- **Permission Denied Error:** Check directory ownership/write permissions or open a writable branch/PR clone.
