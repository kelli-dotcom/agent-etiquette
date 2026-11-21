#!/usr/bin/env node
/**
 * Phase 6 Automated QA Suite for Agent Etiquette Universal Deployment.
 * Covers all 11 required installation, schema, permission, and rollback scenarios.
 */
import assert from "node:assert/strict";
import { execFileSync, spawnSync } from "node:child_process";
import { chmodSync, existsSync, mkdirSync, mkdtempSync, readFileSync, rmSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { dirname, join, resolve } from "node:path";
import { fileURLToPath } from "node:url";
import { validateHandoffObject } from "../scripts/validate-handoff.mjs";

const __dirname = dirname(fileURLToPath(import.meta.url));
const REPO_ROOT = resolve(__dirname, "..");
const INSTALLER = join(REPO_ROOT, "scripts/install-agent-etiquette.sh");
const VALIDATOR = join(REPO_ROOT, "scripts/validate-handoff.mjs");
const SCHEMA = JSON.parse(readFileSync(join(REPO_ROOT, "schemas/handoff.json"), "utf8"));

const results = [];
function test(name, fn) {
  try {
    fn();
    results.push({ name, ok: true });
    console.log(`✓ ${name}`);
  } catch (err) {
    results.push({ name, ok: false, error: err.message });
    console.error(`✗ ${name}\n  ${err.message}`);
  }
}

function runInstaller(args) {
  return spawnSync("bash", [INSTALLER, ...args], { encoding: "utf8" });
}

const workRoot = mkdtempSync(join(tmpdir(), "agent-etiquette-qa-"));

try {
  // 1. Fresh repository
  test("1. Fresh repository installation + verification", () => {
    const dir = join(workRoot, "fresh");
    mkdirSync(dir, { recursive: true });
    const res = runInstaller(["--target", dir, "--source", REPO_ROOT, "--version", "v1.0.0", "--with-tests"]);
    assert.equal(res.status, 0, res.stderr);
    assert.ok(existsSync(join(dir, "AGENTS.md")));
    assert.ok(existsSync(join(dir, "skills/agent-etiquette/SKILL.md")));
    assert.ok(existsSync(join(dir, "schemas/handoff.json")));
    assert.ok(existsSync(join(dir, "agent-etiquette.lock.json")));
    const ver = runInstaller(["--target", dir, "--version", "v1.0.0", "--verify"]);
    assert.equal(ver.status, 0, ver.stderr);
  });

  // 2. Repository with an existing AGENTS.md
  test("2. Preserves existing AGENTS.md rules via Layer 3 composition", () => {
    const dir = join(workRoot, "existing-agents");
    mkdirSync(dir, { recursive: true });
    writeFileSync(join(dir, "AGENTS.md"), "# My Repo Rules\n- Never break production.\n");
    const res = runInstaller(["--target", dir, "--source", REPO_ROOT, "--version", "v1.0.0"]);
    assert.equal(res.status, 0, res.stderr);
    const content = readFileSync(join(dir, "AGENTS.md"), "utf8");
    assert.ok(content.includes("# My Repo Rules"));
    assert.ok(content.includes("- Never break production."));
    assert.ok(content.includes("AGENT-ETIQUETTE:START"));
  });

  // 3. Repository with nested instructions
  test("3. Preserves nested suite AGENTS.md files untouched", () => {
    const dir = join(workRoot, "nested");
    mkdirSync(join(dir, "subpkg"), { recursive: true });
    const nestedContent = "# Nested Subpackage Rules\n- Custom rule.\n";
    writeFileSync(join(dir, "subpkg/AGENTS.md"), nestedContent);
    const res = runInstaller(["--target", dir, "--source", REPO_ROOT, "--version", "v1.0.0"]);
    assert.equal(res.status, 0, res.stderr);
    assert.equal(readFileSync(join(dir, "subpkg/AGENTS.md"), "utf8"), nestedContent);
  });

  // 4. Repeated (idempotent) installation
  test("4. Repeated installation is idempotent (no duplicate blocks)", () => {
    const dir = join(workRoot, "idempotent");
    mkdirSync(dir, { recursive: true });
    writeFileSync(join(dir, "AGENTS.md"), "# Base\n");
    assert.equal(runInstaller(["--target", dir, "--source", REPO_ROOT, "--version", "v1.0.0"]).status, 0);
    assert.equal(runInstaller(["--target", dir, "--source", REPO_ROOT, "--version", "v1.0.0"]).status, 0);
    const content = readFileSync(join(dir, "AGENTS.md"), "utf8");
    const matches = content.match(/AGENT-ETIQUETTE:START/g) || [];
    assert.equal(matches.length, 1, "Expected exactly 1 composed block");
  });

  // 5. Missing dependency / missing source file
  test("5. Fails cleanly when required source file is missing", () => {
    const dir = join(workRoot, "missing-dep-target");
    const badSrc = join(workRoot, "bad-source");
    mkdirSync(dir, { recursive: true });
    mkdirSync(badSrc, { recursive: true });
    const res = runInstaller(["--target", dir, "--source", badSrc, "--version", "v1.0.0"]);
    assert.notEqual(res.status, 0);
    assert.match(res.stderr, /Missing required source file/);
  });

  // 6. Valid & Invalid handoff JSON validation
  test("6. Validates handoff JSON strictly against schemas/handoff.json", () => {
    const valid = {
      from_agent: "builder-1",
      to_agent: "reviewer-1",
      task_id: "TASK-1",
      status: "ready_for_review",
      verified_artifacts: ["README.md"],
      blockers: [],
      next_action: "Review PR",
    };
    assert.deepEqual(validateHandoffObject(valid, SCHEMA), []);

    const missingField = { ...valid };
    delete missingField.next_action;
    assert.ok(validateHandoffObject(missingField, SCHEMA).length > 0);

    const badStatus = { ...valid, status: "shipped" };
    assert.ok(validateHandoffObject(badStatus, SCHEMA).length > 0);

    const extraProp = { ...valid, secret_field: "nope" };
    assert.ok(validateHandoffObject(extraProp, SCHEMA).length > 0);

    const payloadFile = join(workRoot, "valid-handoff.json");
    writeFileSync(payloadFile, JSON.stringify(valid));
    const cliOut = execFileSync(process.execPath, [VALIDATOR, payloadFile], { encoding: "utf8" });
    assert.match(cliOut, /VALID HANDOFF/);
  });

  // 7. Existing project-specific skills preserved
  test("7. Retains existing project-specific skills untouched", () => {
    const dir = join(workRoot, "custom-skills");
    mkdirSync(join(dir, "skills/my-custom-skill"), { recursive: true });
    writeFileSync(join(dir, "skills/my-custom-skill/SKILL.md"), "# Custom Skill\n");
    assert.equal(runInstaller(["--target", dir, "--source", REPO_ROOT, "--version", "v1.0.0"]).status, 0);
    assert.equal(readFileSync(join(dir, "skills/my-custom-skill/SKILL.md"), "utf8"), "# Custom Skill\n");
  });

  // 8. Update and rollback (uninstall)
  test("8. Supports version update and clean rollback without damaging repo AGENTS.md", () => {
    const dir = join(workRoot, "update-rollback");
    mkdirSync(dir, { recursive: true });
    writeFileSync(join(dir, "AGENTS.md"), "# Keep Me\n");
    assert.equal(runInstaller(["--target", dir, "--source", REPO_ROOT, "--version", "v1.0.0"]).status, 0);
    assert.equal(runInstaller(["--target", dir, "--source", REPO_ROOT, "--version", "v1.0.1", "--update"]).status, 0);
    assert.equal(JSON.parse(readFileSync(join(dir, "agent-etiquette.lock.json"), "utf8")).version, "v1.0.1");

    const un = runInstaller(["--target", dir, "--uninstall"]);
    assert.equal(un.status, 0, un.stderr);
    assert.ok(!existsSync(join(dir, "agent-etiquette.lock.json")));
    assert.ok(!existsSync(join(dir, "skills/agent-etiquette/SKILL.md")));
    assert.equal(readFileSync(join(dir, "AGENTS.md"), "utf8").trim(), "# Keep Me");
  });

  // 9. Mobile-only installation instructions & path integrity
  test("9. Mobile-only instructions and all referenced repo paths exist", () => {
    const readme = readFileSync(join(REPO_ROOT, "README.md"), "utf8");
    const guide = readFileSync(join(REPO_ROOT, "docs/SETUP_GUIDE.md"), "utf8");
    assert.ok(readme.includes("archive/refs/heads/main.zip"));
    assert.ok(guide.includes("iOS / iPadOS"));
    assert.ok(guide.includes("Android"));
    assert.ok(guide.includes("Mode 1: Conversational AI Attachment"));
    assert.ok(guide.includes("Mode 2: Code Repository Installation"));
    assert.ok(guide.includes("Mode 3: Coding-Agent Runtime Enforcement"));
    for (const rel of [
      "AGENTS.md",
      "skills/agent-etiquette/SKILL.md",
      "schemas/handoff.json",
      "schemas/handoff-schema.md",
      "tests/stress-tests.md",
      "scripts/install-agent-etiquette.sh",
      "scripts/validate-handoff.mjs",
      "docs/SETUP_GUIDE.md",
      "ROLLOUT_MANIFEST.md",
    ]) {
      assert.ok(existsSync(join(REPO_ROOT, rel)), `Missing referenced file: ${rel}`);
    }
  });

  // 10. Version mismatch detection
  test("10. Detects version mismatch during --verify", () => {
    const dir = join(workRoot, "version-mismatch");
    mkdirSync(dir, { recursive: true });
    assert.equal(runInstaller(["--target", dir, "--source", REPO_ROOT, "--version", "v1.0.0"]).status, 0);
    const badVerify = runInstaller(["--target", dir, "--version", "v9.9.9", "--verify"]);
    assert.notEqual(badVerify.status, 0);
    assert.match(badVerify.stderr, /Version mismatch/);
  });

  // 11. Unavailable repository permissions (read-only target)
  test("11. Fails safely on read-only target directory", () => {
    const dir = join(workRoot, "readonly-target");
    mkdirSync(dir, { recursive: true });
    chmodSync(dir, 0o555);
    try {
      const res = runInstaller(["--target", dir, "--source", REPO_ROOT, "--version", "v1.0.0"]);
      assert.notEqual(res.status, 0);
      assert.match(res.stderr, /not writable/i);
    } finally {
      chmodSync(dir, 0o755);
    }
  });
} finally {
  rmSync(workRoot, { recursive: true, force: true });
}

const failed = results.filter((r) => !r.ok);
console.log(`\nSummary: ${results.length - failed.length} pass, ${failed.length} fail`);
if (failed.length > 0) process.exit(1);
