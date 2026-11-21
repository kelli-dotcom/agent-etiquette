#!/usr/bin/env bash
set -euo pipefail

# Agent Etiquette — Version-Pinned, Idempotent Installer / Updater / Rollback
# Preserves existing AGENTS.md rules, custom skills, and relative paths.
# Never writes secrets, tokens, or credentials.

DEFAULT_VERSION="v1.0.0"
SOURCE_REPO="https://github.com/kelli-dotcom/agent-etiquette"
VERSION="$DEFAULT_VERSION"
TARGET_DIR="."
LOCAL_SOURCE=""
MODE="install"
WITH_TESTS=0

usage() {
  cat <<'USAGE'
Usage: install-agent-etiquette.sh [options]
  --target <dir>       Target repository directory (default: .)
  --version <tag>      Pinned protocol version tag (default: v1.0.0)
  --source <dir>       Use a local agent-etiquette directory instead of network fetch
  --with-tests         Also install tests/agent-etiquette/stress-tests.md
  --update             Update an existing installation to --version
  --verify             Verify installed files, checksums, relative paths, and schema
  --uninstall          Clean rollback: remove lockfile-tracked files & AGENTS.md block
  -h, --help           Show help
USAGE
}

while [ $# -gt 0 ]; do
  case "$1" in
    --target) TARGET_DIR="${2:-}"; shift 2 ;;
    --version) VERSION="${2:-}"; shift 2 ;;
    --source) LOCAL_SOURCE="${2:-}"; shift 2 ;;
    --with-tests) WITH_TESTS=1; shift ;;
    --update) MODE="update"; shift ;;
    --verify) MODE="verify"; shift ;;
    --uninstall) MODE="uninstall"; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage >&2; exit 2 ;;
  esac
done

if [ ! -d "$TARGET_DIR" ]; then
  echo "Error: Target directory does not exist: $TARGET_DIR" >&2
  exit 1
fi
TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"
LOCK_FILE="$TARGET_DIR/agent-etiquette.lock.json"

if command -v node >/dev/null 2>&1; then
  JS_BIN="node"
elif command -v bun >/dev/null 2>&1; then
  JS_BIN="bun"
elif [ -x "$HOME/.bun/bin/bun" ]; then
  JS_BIN="$HOME/.bun/bin/bun"
else
  echo "Error: Node.js or Bun is required to run install-agent-etiquette.sh." >&2
  exit 1
fi

if [ "$MODE" = "verify" ]; then
  if [ ! -f "$LOCK_FILE" ]; then
    echo "Verify failed: $LOCK_FILE not found." >&2
    exit 1
  fi
  AE_TARGET="$TARGET_DIR" AE_VERSION="$VERSION" "$JS_BIN" -e '
    const fs = require("fs");
    const path = require("path");
    const crypto = require("crypto");
    const target = process.env.AE_TARGET;
    const expectedVersion = process.env.AE_VERSION;
    const lock = JSON.parse(fs.readFileSync(path.join(target, "agent-etiquette.lock.json"), "utf8"));
    const errors = [];
    if (expectedVersion && lock.version !== expectedVersion) {
      errors.push(`Version mismatch: lockfile has ${lock.version}, expected ${expectedVersion}`);
    }
    for (const [rel, expectedSha] of Object.entries(lock.files || {})) {
      const full = path.join(target, rel);
      if (!fs.existsSync(full)) {
        errors.push(`Missing installed file: ${rel}`);
        continue;
      }
      const actualSha = crypto.createHash("sha256").update(fs.readFileSync(full)).digest("hex");
      if (actualSha !== expectedSha) {
        errors.push(`Checksum mismatch for ${rel}`);
      }
    }
    const skillPath = path.join(target, "skills/agent-etiquette/SKILL.md");
    const schemaPath = path.join(target, "schemas/handoff.json");
    if (!fs.existsSync(skillPath) || !fs.existsSync(schemaPath)) {
      errors.push("Core relative path pair skills/agent-etiquette/SKILL.md <-> schemas/handoff.json is incomplete.");
    }
    const agentsPath = path.join(target, "AGENTS.md");
    if (!fs.existsSync(agentsPath) || !fs.readFileSync(agentsPath, "utf8").includes("AGENT-ETIQUETTE:START")) {
      errors.push("AGENTS.md is missing the Agent Etiquette composition block.");
    }
    if (errors.length > 0) {
      console.error("VERIFICATION FAILED:\n" + errors.map((e) => "  - " + e).join("\n"));
      process.exit(1);
    }
    console.log(`VERIFIED: agent-etiquette ${lock.version} in ${target}`);
  '
  exit 0
fi

if [ ! -w "$TARGET_DIR" ]; then
  echo "Error: Target directory is not writable (permission denied): $TARGET_DIR" >&2
  exit 1
fi

if [ "$MODE" = "uninstall" ]; then
  if [ ! -f "$LOCK_FILE" ]; then
    echo "Nothing to uninstall: $LOCK_FILE not found in $TARGET_DIR"
    exit 0
  fi
  AE_TARGET="$TARGET_DIR" "$JS_BIN" -e '
    const fs = require("fs");
    const path = require("path");
    const target = process.env.AE_TARGET;
    const lockPath = path.join(target, "agent-etiquette.lock.json");
    const lock = JSON.parse(fs.readFileSync(lockPath, "utf8"));
    for (const rel of Object.keys(lock.files || {})) {
      const full = path.join(target, rel);
      if (fs.existsSync(full)) fs.unlinkSync(full);
    }
    const agentsPath = path.join(target, "AGENTS.md");
    if (fs.existsSync(agentsPath)) {
      const raw = fs.readFileSync(agentsPath, "utf8");
      const stripped = raw.replace(/\n?<!-- AGENT-ETIQUETTE:START[\s\S]*?<!-- AGENT-ETIQUETTE:END -->\n?/g, "\n").trim();
      if (lock.createdAgentsMd && stripped.length === 0) {
        fs.unlinkSync(agentsPath);
      } else {
        fs.writeFileSync(agentsPath, stripped + "\n", "utf8");
      }
    }
    fs.unlinkSync(lockPath);
    console.log("UNINSTALLED: agent-etiquette removed cleanly from " + target);
  '
  exit 0
fi

TMP_DIR=""
cleanup() { if [ -n "$TMP_DIR" ]; then rm -rf "$TMP_DIR"; fi; }
trap cleanup EXIT

if [ -n "$LOCAL_SOURCE" ]; then
  if [ ! -d "$LOCAL_SOURCE" ]; then
    echo "Error: Local source directory not found: $LOCAL_SOURCE" >&2
    exit 1
  fi
  SRC_DIR="$(cd "$LOCAL_SOURCE" && pwd)"
else
  if ! command -v curl >/dev/null 2>&1 || ! command -v tar >/dev/null 2>&1; then
    echo "Error: curl and tar are required for remote installation." >&2
    exit 1
  fi
  TMP_DIR="$(mktemp -d)"
  TARBALL="$TMP_DIR/agent-etiquette.tar.gz"
  curl -fsSL "$SOURCE_REPO/archive/refs/tags/$VERSION.tar.gz" -o "$TARBALL"
  tar -xzf "$TARBALL" -C "$TMP_DIR"
  SRC_DIR="$(find "$TMP_DIR" -mindepth 1 -maxdepth 1 -type d | head -n 1)"
fi

for REQ in "skills/agent-etiquette/SKILL.md" "schemas/handoff.json" "schemas/handoff-schema.md"; do
  if [ ! -f "$SRC_DIR/$REQ" ]; then
    echo "Error: Missing required source file: $REQ" >&2
    exit 1
  fi
done

mkdir -p "$TARGET_DIR/skills/agent-etiquette" "$TARGET_DIR/schemas" "$TARGET_DIR/scripts"
cp "$SRC_DIR/skills/agent-etiquette/SKILL.md" "$TARGET_DIR/skills/agent-etiquette/SKILL.md"
cp "$SRC_DIR/schemas/handoff.json" "$TARGET_DIR/schemas/handoff.json"
cp "$SRC_DIR/schemas/handoff-schema.md" "$TARGET_DIR/schemas/handoff-schema.md"

INSTALLED_LIST=(
  "skills/agent-etiquette/SKILL.md"
  "schemas/handoff.json"
  "schemas/handoff-schema.md"
)

if [ -f "$SRC_DIR/scripts/validate-handoff.mjs" ]; then
  cp "$SRC_DIR/scripts/validate-handoff.mjs" "$TARGET_DIR/scripts/validate-handoff.mjs"
  chmod +x "$TARGET_DIR/scripts/validate-handoff.mjs"
  INSTALLED_LIST+=("scripts/validate-handoff.mjs")
fi

if [ "$WITH_TESTS" -eq 1 ] && [ -f "$SRC_DIR/tests/stress-tests.md" ]; then
  mkdir -p "$TARGET_DIR/tests/agent-etiquette"
  cp "$SRC_DIR/tests/stress-tests.md" "$TARGET_DIR/tests/agent-etiquette/stress-tests.md"
  INSTALLED_LIST+=("tests/agent-etiquette/stress-tests.md")
fi

AGENTS_FILE="$TARGET_DIR/AGENTS.md"
CREATED_AGENTS=false
if [ ! -f "$AGENTS_FILE" ]; then
  CREATED_AGENTS=true
  touch "$AGENTS_FILE"
fi

AE_FILES_CSV="$(IFS=','; echo "${INSTALLED_LIST[*]}")"
AE_TARGET="$TARGET_DIR" AE_VERSION="$VERSION" AE_SOURCE_REPO="$SOURCE_REPO" AE_CREATED_AGENTS="$CREATED_AGENTS" AE_FILES="$AE_FILES_CSV" "$JS_BIN" -e '
  const fs = require("fs");
  const path = require("path");
  const crypto = require("crypto");
  const target = process.env.AE_TARGET;
  const version = process.env.AE_VERSION;
  const sourceRepo = process.env.AE_SOURCE_REPO;
  const createdAgents = process.env.AE_CREATED_AGENTS === "true";
  const files = (process.env.AE_FILES || "").split(",").filter(Boolean);

  const agentsPath = path.join(target, "AGENTS.md");
  const existing = fs.readFileSync(agentsPath, "utf8");
  const block = [
    `<!-- AGENT-ETIQUETTE:START version=${version} -->`,
    `## Agent Etiquette Protocol (Layer 3 — Pinned \`${version}\`)`,
    `- **Hierarchy:** Platform constraints (Layer 1) → Repository rules above (Layer 2) → Agent Etiquette (Layer 3) → Task-specific skills (Layer 4) → Handoffs (Layer 5).`,
    `- **Behavioral Rules:** Load \`skills/agent-etiquette/SKILL.md\` (zero filler, verified actions only, Rule of 2 retry cap, max 3 concurrent specialists).`,
    `- **Handoff Contract:** Validate inter-agent handoffs against \`schemas/handoff.json\` (\`node scripts/validate-handoff.mjs <file>\`).`,
    `<!-- AGENT-ETIQUETTE:END -->`,
  ].join("\n");

  const re = /<!-- AGENT-ETIQUETTE:START[\s\S]*?<!-- AGENT-ETIQUETTE:END -->/g;
  let next;
  if (re.test(existing)) {
    next = existing.replace(re, block);
  } else if (existing.trim().length === 0) {
    next = block + "\n";
  } else {
    next = existing.replace(/\s+$/, "") + "\n\n" + block + "\n";
  }
  fs.writeFileSync(agentsPath, next, "utf8");

  const checksums = {};
  for (const rel of files) {
    checksums[rel] = crypto.createHash("sha256").update(fs.readFileSync(path.join(target, rel))).digest("hex");
  }
  const lock = {
    protocol: "agent-etiquette",
    version,
    source_repo: sourceRepo,
    createdAgentsMd: createdAgents,
    installed_at: new Date().toISOString(),
    files: checksums,
  };
  fs.writeFileSync(path.join(target, "agent-etiquette.lock.json"), JSON.stringify(lock, null, 2) + "\n", "utf8");
'

echo "INSTALLED: agent-etiquette $VERSION into $TARGET_DIR (${#INSTALLED_LIST[@]} files)"
