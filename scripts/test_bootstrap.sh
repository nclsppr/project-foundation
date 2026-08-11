#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
SOURCE_FOUNDATION_ROOT="$(cd -- "${SCRIPT_DIR}/.." && pwd -P)"
SOURCE_SANITIZER="${SCRIPT_DIR}/sanitize_git_remote.py"
TEST_ROOT="$(mktemp -d)"
TEST_ROOT="$(cd -- "${TEST_ROOT}" && pwd -P)"
DIRTY_SENTINEL=""

cleanup() {
  if [[ -n "${DIRTY_SENTINEL:-}" && -f "${DIRTY_SENTINEL}" ]]; then
    rm -f "${DIRTY_SENTINEL}"
  fi
  if [[ -n "${TEST_ROOT:-}" && -d "${TEST_ROOT}" ]]; then
    rm -rf "${TEST_ROOT}"
  fi
}
trap cleanup EXIT INT TERM

fail() {
  echo "Bootstrap test failed: $*" >&2
  exit 1
}

expect_failure() {
  if "$@" >"${TEST_ROOT}/expected-failure.out" 2>&1; then
    fail "the command was expected to fail: $*"
  fi
}

tree_files() {
  (cd "$1" && find . -type f | LC_ALL=C sort)
}

copy_nimbus_scaffold() {
  source_root="$1"
  destination_root="$2"
  while IFS= read -r -d '' source; do
    relative="${source#${source_root}/}"
    case "${relative}" in
      node_modules/*|dist/*|.astro/*|.nimbus/*|.wrangler/*|src/content/docs/*) continue ;;
      .env|.env.local|.env.*.local|.env.production|.dev.vars|.dev.vars.*) continue ;;
      npm-debug.log*|yarn-debug.log*|yarn-error.log*|pnpm-debug.log*) continue ;;
    esac
    mkdir -p "${destination_root}/$(dirname -- "${relative}")"
    cp -p "${source}" "${destination_root}/${relative}"
  done < <(find "${source_root}" -type f -print0)
}

append_nimbus_expected() {
  expected_file="$1"
  while IFS= read -r -d '' source; do
    relative="${source#${SOURCE_FOUNDATION_ROOT}/}"
    case "${relative}" in
      docs-nimbus/node_modules/*|docs-nimbus/dist/*|docs-nimbus/.astro/*|docs-nimbus/.nimbus/*|docs-nimbus/.wrangler/*|docs-nimbus/src/content/docs/*) continue ;;
      docs-nimbus/.env|docs-nimbus/.env.local|docs-nimbus/.env.*.local|docs-nimbus/.env.production|docs-nimbus/.dev.vars|docs-nimbus/.dev.vars.*) continue ;;
      docs-nimbus/npm-debug.log*|docs-nimbus/yarn-debug.log*|docs-nimbus/yarn-error.log*|docs-nimbus/pnpm-debug.log*) continue ;;
    esac
    printf './%s\n' "${relative}" >>"${expected_file}"
  done < <(find "${SOURCE_FOUNDATION_ROOT}/docs-nimbus" -type f -print0)
  LC_ALL=C sort -o "${expected_file}" "${expected_file}"
}

copy_foundation_fixture() {
  destination="$1"
  mkdir -p "${destination}/scripts"
  cp -p \
    "${SOURCE_FOUNDATION_ROOT}/VERSION" \
    "${SOURCE_FOUNDATION_ROOT}/foundation-distribution.json" \
    "${SOURCE_FOUNDATION_ROOT}/PRINCIPLES.md" \
    "${SOURCE_FOUNDATION_ROOT}/DEFAULTS.md" \
    "${SOURCE_FOUNDATION_ROOT}/DEFINITION-OF-DONE.md" \
    "${destination}/"
  cp -Rp \
    "${SOURCE_FOUNDATION_ROOT}/profiles" \
    "${SOURCE_FOUNDATION_ROOT}/templates" \
    "${destination}/"
  copy_nimbus_scaffold \
    "${SOURCE_FOUNDATION_ROOT}/docs-nimbus" \
    "${destination}/docs-nimbus"
  cp -p \
    "${SOURCE_FOUNDATION_ROOT}/scripts/bootstrap.sh" \
    "${SOURCE_FOUNDATION_ROOT}/scripts/check_compose.py" \
    "${SOURCE_FOUNDATION_ROOT}/scripts/documentation_catalog.py" \
    "${SOURCE_FOUNDATION_ROOT}/scripts/foundation_sync.py" \
    "${SOURCE_FOUNDATION_ROOT}/scripts/sanitize_git_remote.py" \
    "${destination}/scripts/"
}

FOUNDATION_ROOT="${TEST_ROOT}/foundation-fixture"
copy_foundation_fixture "${FOUNDATION_ROOT}"
FOUNDATION_ROOT="$(cd -- "${FOUNDATION_ROOT}" && pwd -P)"
printf '%s\n' '0.0.0' >"${FOUNDATION_ROOT}/VERSION"
git -C "${FOUNDATION_ROOT}" init -q -b main
git -C "${FOUNDATION_ROOT}" add -- .
git -C "${FOUNDATION_ROOT}" \
  -c user.name="Project Foundation Tests" \
  -c user.email="foundation-tests@example.invalid" \
  commit -q -m "test: create clean foundation fixture"
git -C "${FOUNDATION_ROOT}" \
  -c user.name="Project Foundation Tests" \
  -c user.email="foundation-tests@example.invalid" \
  tag -a v0.0.0 -m "Test fixture"

BOOTSTRAP="${FOUNDATION_ROOT}/scripts/bootstrap.sh"
SANITIZER="${FOUNDATION_ROOT}/scripts/sanitize_git_remote.py"
EXPECTED_FOUNDATION_SOURCE="${FOUNDATION_ROOT}"
EXPECTED_FOUNDATION_COMMIT="$(git -C "${FOUNDATION_ROOT}" rev-parse HEAD)"
EXPECTED_FOUNDATION_TAG="$(git -C "${FOUNDATION_ROOT}" describe --tags --exact-match HEAD)"
export PROJECT_FOUNDATION_TRUSTED_SOURCE="${FOUNDATION_ROOT}"

sanitized_https="$("${SANITIZER}" 'https://user:secret@example.com/org/repo.git?access_token=secret#fragment')"
[[ "${sanitized_https}" == "https://example.com/org/repo.git" ]] || fail "the HTTPS remote was not sanitized correctly."
sanitized_ssh="$("${SANITIZER}" 'git@github.com:owner/repo.git')"
[[ "${sanitized_ssh}" == "ssh://github.com/owner/repo.git" ]] || fail "the SSH remote was not normalized correctly."
expect_failure "${SANITIZER}" 'https://example.com/org|injection.git'

DIRTY_SENTINEL="$(mktemp "${FOUNDATION_ROOT}/foundation-dirty-test.XXXXXX")"
expect_failure "${BOOTSTRAP}" \
  --target "${TEST_ROOT}/dirty-source-project" \
  --class exploration \
  --profiles experiment
rm -f "${DIRTY_SENTINEL}"
DIRTY_SENTINEL=""

NESTED_PARENT="${TEST_ROOT}/nested-parent"
NESTED_FOUNDATION="${NESTED_PARENT}/project-foundation"
mkdir -p "${NESTED_PARENT}"
copy_foundation_fixture "${NESTED_FOUNDATION}"
git -C "${NESTED_PARENT}" init -q -b main
git -C "${NESTED_PARENT}" add -- .
git -C "${NESTED_PARENT}" \
  -c user.name="Project Foundation Tests" \
  -c user.email="foundation-tests@example.invalid" \
  commit -q -m "test: create parent repository"
expect_failure "${NESTED_FOUNDATION}/scripts/bootstrap.sh" \
  --target "${TEST_ROOT}/nested-root-project" \
  --class exploration \
  --profiles experiment
grep -F "Project Foundation must be its own Git repository root." "${TEST_ROOT}/expected-failure.out" >/dev/null || fail "the parent Git root was not detected."

DRY_TARGET="${TEST_ROOT}/dry-run-project"
"${BOOTSTRAP}" \
  --target "${DRY_TARGET}" \
  --class exploration \
  --profiles experiment \
  --dry-run >"${TEST_ROOT}/dry-run.out"
[[ ! -e "${DRY_TARGET}" ]] || fail "the dry run created the target."
grep -F "Dry-run mode: no writes." "${TEST_ROOT}/dry-run.out" >/dev/null || fail "the dry-run output is missing."
grep -F "docs/foundation/profiles/experiment.md" "${TEST_ROOT}/dry-run.out" >/dev/null || fail "the profile is missing from the dry-run output."

EXPLORATION_TARGET="${TEST_ROOT}/exploration-project"
"${BOOTSTRAP}" \
  --target "${EXPLORATION_TARGET}" \
  --class exploration \
  --profiles experiment,web >/dev/null

printf '%s\n' \
  "./.github/workflows/foundation-sync.yml" \
  "./.github/workflows/verify.yml" \
  "./.githooks/pre-commit" \
  "./AGENTS.md" \
  "./BRIEF.md" \
  "./CHANGELOG.md" \
  "./DOCUMENTATION-CATALOG.md" \
  "./DOCUMENTATION.md" \
  "./FOUNDATION.md" \
  "./README.md" \
  "./compose.yaml" \
  "./docs/decisions/.gitkeep" \
  "./docs/foundation/DEFAULTS.md" \
  "./docs/foundation/DEFINITION-OF-DONE.md" \
  "./docs/foundation/PRINCIPLES.md" \
  "./docs/foundation/profiles/documentation-nimbus.md" \
  "./docs/foundation/profiles/experiment.md" \
  "./docs/foundation/profiles/web.md" \
  "./documentation.json" \
  "./foundation.lock.json" \
  "./scripts/check_compose.py" \
  "./scripts/check_markdown.py" \
  "./scripts/documentation_catalog.py" \
  "./scripts/foundation_sync.py" \
  "./scripts/install_foundation_hook.sh" \
  "./scripts/verify.sh" >"${TEST_ROOT}/exploration.expected"
append_nimbus_expected "${TEST_ROOT}/exploration.expected"
tree_files "${EXPLORATION_TARGET}" >"${TEST_ROOT}/exploration.actual"
diff -u "${TEST_ROOT}/exploration.expected" "${TEST_ROOT}/exploration.actual" || fail "the exploration tree is not as expected."
[[ -x "${EXPLORATION_TARGET}/scripts/verify.sh" ]] || fail "the exploration verify script is not executable."
[[ -x "${EXPLORATION_TARGET}/scripts/check_compose.py" ]] || fail "the exploration Compose checker is not executable."
[[ -x "${EXPLORATION_TARGET}/scripts/documentation_catalog.py" ]] || fail "the exploration documentation catalog script is not executable."
[[ -x "${EXPLORATION_TARGET}/scripts/foundation_sync.py" ]] || fail "the exploration Foundation synchronizer is not executable."
[[ -x "${EXPLORATION_TARGET}/scripts/install_foundation_hook.sh" ]] || fail "the exploration hook installer is not executable."
[[ -x "${EXPLORATION_TARGET}/.githooks/pre-commit" ]] || fail "the exploration pre-commit hook is not executable."
[[ ! -e "${EXPLORATION_TARGET}/.git" ]] || fail "the bootstrap initialized Git."
[[ ! -e "${EXPLORATION_TARGET}/DESIGN.md" ]] || fail "the Minimal pack contains DESIGN.md."
grep -F '| Adopted pack | `minimal` |' "${EXPLORATION_TARGET}/FOUNDATION.md" >/dev/null || fail "the Minimal pack metadata is missing."
grep -F '"@cloudflare/nimbus-docs": "0.8.2"' "${EXPLORATION_TARGET}/docs-nimbus/package.json" >/dev/null || fail "the mandatory Nimbus version is missing from the Minimal pack."
grep -F '"name": "nimbus"' "${EXPLORATION_TARGET}/documentation.json" >/dev/null || fail "the Nimbus renderer is missing from the Minimal pack."
grep -F '## P18. Commit and push each verified work unit' "${EXPLORATION_TARGET}/docs/foundation/PRINCIPLES.md" >/dev/null || fail "principle P18 is missing from the Minimal pack."
grep -F 'Apply `P18` when the task authorizes changes.' "${EXPLORATION_TARGET}/AGENTS.md" >/dev/null || fail "the P18 operational rule is missing from the Minimal pack."
grep -F '## P19. Orchestrate the local environment with Docker Compose' "${EXPLORATION_TARGET}/docs/foundation/PRINCIPLES.md" >/dev/null || fail "principle P19 is missing from the Minimal pack."
grep -F 'Keep `compose.yaml` and its gate.' "${EXPLORATION_TARGET}/AGENTS.md" >/dev/null || fail "the P19 operational rule is missing from the Minimal pack."
grep -F '## P20. Use controlled technical English' "${EXPLORATION_TARGET}/docs/foundation/PRINCIPLES.md" >/dev/null || fail "principle P20 is missing from the Minimal pack."
grep -F 'Follow the principles of ASD-STE100 Simplified Technical English.' "${EXPLORATION_TARGET}/docs/foundation/PRINCIPLES.md" >/dev/null || fail "the ASD-STE100 clause is missing from the Minimal pack."
grep -F 'Use ISO/IEC/IEEE 24765 terminology when it applies.' "${EXPLORATION_TARGET}/docs/foundation/PRINCIPLES.md" >/dev/null || fail "the ISO/IEC/IEEE 24765 clause is missing from the Minimal pack."
grep -F 'A local exception cannot select another language.' "${EXPLORATION_TARGET}/AGENTS.md" >/dev/null || fail "the P20 operational rule is missing from the Minimal pack."
grep -F '`P20` cannot be disabled by a local exception.' "${EXPLORATION_TARGET}/FOUNDATION.md" >/dev/null || fail "the P20 exception limit is missing from the Minimal pack."
grep -F '## P21. Emit safe, structured, and actionable log records' "${EXPLORATION_TARGET}/docs/foundation/PRINCIPLES.md" >/dev/null || fail "principle P21 is missing from the Minimal pack."
grep -F 'Every `INFO`, `WARN`, and `ERROR` log record has a stable, lowercase, dot-separated event name.' "${EXPLORATION_TARGET}/docs/foundation/PRINCIPLES.md" >/dev/null || fail "the P21 event-name rule is missing from the Minimal pack."
grep -F 'Use both the stable event name and the human-readable message.' "${EXPLORATION_TARGET}/docs/foundation/PRINCIPLES.md" >/dev/null || fail "the P21 identifier and message rule is missing from the Minimal pack."
grep -F 'Apply `P21` to each first-party runtime log record.' "${EXPLORATION_TARGET}/AGENTS.md" >/dev/null || fail "the P21 operational rule is missing from the Minimal pack."
grep -F '`P21` cannot be disabled for first-party runtime log records.' "${EXPLORATION_TARGET}/FOUNDATION.md" >/dev/null || fail "the P21 exception limit is missing from the Minimal pack."
grep -F '## P22. Verify and adopt the latest stable Foundation release before each commit' "${EXPLORATION_TARGET}/docs/foundation/PRINCIPLES.md" >/dev/null || fail "principle P22 is missing from the Minimal pack."
grep -F 'Apply `P22` before each commit.' "${EXPLORATION_TARGET}/AGENTS.md" >/dev/null || fail "the P22 operational rule is missing from the Minimal pack."
grep -F '`P22` cannot be disabled by a local exception.' "${EXPLORATION_TARGET}/FOUNDATION.md" >/dev/null || fail "the P22 exception limit is missing from the Minimal pack."
python3 "${EXPLORATION_TARGET}/scripts/foundation_sync.py" check >"${TEST_ROOT}/exploration-foundation-sync.out"
grep -F 'name: exploration-project' "${EXPLORATION_TARGET}/compose.yaml" >/dev/null || fail "the exploration Compose name is not initialized."
python3 "${EXPLORATION_TARGET}/scripts/check_compose.py" >"${TEST_ROOT}/exploration-compose.out"

PRODUCT_TARGET="${TEST_ROOT}/product-project"
USER='unsafe|actor' "${BOOTSTRAP}" \
  --target "${PRODUCT_TARGET}" \
  --class product \
  --profiles web,backend-data >/dev/null

printf '%s\n' \
  "./.github/workflows/foundation-sync.yml" \
  "./.github/workflows/verify.yml" \
  "./.githooks/pre-commit" \
  "./AGENTS.md" \
  "./CHANGELOG.md" \
  "./DESIGN.md" \
  "./DOCUMENTATION-CATALOG.md" \
  "./DOCUMENTATION.md" \
  "./FOUNDATION.md" \
  "./PROJECT.md" \
  "./README.md" \
  "./ROADMAP.md" \
  "./STATUS.md" \
  "./compose.yaml" \
  "./docs/decisions/.gitkeep" \
  "./docs/foundation/DEFAULTS.md" \
  "./docs/foundation/DEFINITION-OF-DONE.md" \
  "./docs/foundation/PRINCIPLES.md" \
  "./docs/foundation/profiles/backend-data.md" \
  "./docs/foundation/profiles/documentation-nimbus.md" \
  "./docs/foundation/profiles/web.md" \
  "./documentation.json" \
  "./foundation.lock.json" \
  "./scripts/check_compose.py" \
  "./scripts/check_markdown.py" \
  "./scripts/documentation_catalog.py" \
  "./scripts/foundation_sync.py" \
  "./scripts/install_foundation_hook.sh" \
  "./scripts/verify.sh" >"${TEST_ROOT}/product.expected"
append_nimbus_expected "${TEST_ROOT}/product.expected"
tree_files "${PRODUCT_TARGET}" >"${TEST_ROOT}/product.actual"
diff -u "${TEST_ROOT}/product.expected" "${TEST_ROOT}/product.actual" || fail "the product tree is not as expected."
[[ -x "${PRODUCT_TARGET}/scripts/documentation_catalog.py" ]] || fail "the product documentation catalog script is not executable."
grep -F '## P18. Commit and push each verified work unit' "${PRODUCT_TARGET}/docs/foundation/PRINCIPLES.md" >/dev/null || fail "principle P18 is missing from the Full pack."
grep -F 'Apply `P18` when the task authorizes changes.' "${PRODUCT_TARGET}/AGENTS.md" >/dev/null || fail "the P18 operational rule is missing from the Full pack."
grep -F '## P19. Orchestrate the local environment with Docker Compose' "${PRODUCT_TARGET}/docs/foundation/PRINCIPLES.md" >/dev/null || fail "principle P19 is missing from the Full pack."
grep -F 'Keep `compose.yaml` and its gate.' "${PRODUCT_TARGET}/AGENTS.md" >/dev/null || fail "the P19 operational rule is missing from the Full pack."
grep -F '## P20. Use controlled technical English' "${PRODUCT_TARGET}/docs/foundation/PRINCIPLES.md" >/dev/null || fail "principle P20 is missing from the Full pack."
grep -F 'Follow the principles of ASD-STE100 Simplified Technical English.' "${PRODUCT_TARGET}/docs/foundation/PRINCIPLES.md" >/dev/null || fail "the ASD-STE100 clause is missing from the Full pack."
grep -F 'Use ISO/IEC/IEEE 24765 terminology when it applies.' "${PRODUCT_TARGET}/docs/foundation/PRINCIPLES.md" >/dev/null || fail "the ISO/IEC/IEEE 24765 clause is missing from the Full pack."
grep -F 'A local exception cannot select another language.' "${PRODUCT_TARGET}/AGENTS.md" >/dev/null || fail "the P20 operational rule is missing from the Full pack."
grep -F '`P20` cannot be disabled by a local exception.' "${PRODUCT_TARGET}/FOUNDATION.md" >/dev/null || fail "the P20 exception limit is missing from the Full pack."
grep -F '## P21. Emit safe, structured, and actionable log records' "${PRODUCT_TARGET}/docs/foundation/PRINCIPLES.md" >/dev/null || fail "principle P21 is missing from the Full pack."
grep -F 'Every `INFO`, `WARN`, and `ERROR` log record has a stable, lowercase, dot-separated event name.' "${PRODUCT_TARGET}/docs/foundation/PRINCIPLES.md" >/dev/null || fail "the P21 event-name rule is missing from the Full pack."
grep -F 'Use both the stable event name and the human-readable message.' "${PRODUCT_TARGET}/docs/foundation/PRINCIPLES.md" >/dev/null || fail "the P21 identifier and message rule is missing from the Full pack."
grep -F 'Apply `P21` to each first-party runtime log record.' "${PRODUCT_TARGET}/AGENTS.md" >/dev/null || fail "the P21 operational rule is missing from the Full pack."
grep -F '`P21` cannot be disabled for first-party runtime log records.' "${PRODUCT_TARGET}/FOUNDATION.md" >/dev/null || fail "the P21 exception limit is missing from the Full pack."
grep -F '## P22. Verify and adopt the latest stable Foundation release before each commit' "${PRODUCT_TARGET}/docs/foundation/PRINCIPLES.md" >/dev/null || fail "principle P22 is missing from the Full pack."
grep -F 'Apply `P22` before each commit.' "${PRODUCT_TARGET}/AGENTS.md" >/dev/null || fail "the P22 operational rule is missing from the Full pack."
grep -F '`P22` cannot be disabled by a local exception.' "${PRODUCT_TARGET}/FOUNDATION.md" >/dev/null || fail "the P22 exception limit is missing from the Full pack."
python3 "${PRODUCT_TARGET}/scripts/foundation_sync.py" check >"${TEST_ROOT}/product-foundation-sync.out"
grep -F 'name: product-project' "${PRODUCT_TARGET}/compose.yaml" >/dev/null || fail "the Product Compose name is not initialized."
grep -F 'Check Docker Compose' "${PRODUCT_TARGET}/.github/workflows/verify.yml" >/dev/null || fail "the Compose gate is missing from the generated CI workflow."
git -C "${PRODUCT_TARGET}" init -q -b main
"${PRODUCT_TARGET}/scripts/install_foundation_hook.sh" >"${TEST_ROOT}/hook-install.out"
python3 "${PRODUCT_TARGET}/scripts/foundation_sync.py" hook-status >"${TEST_ROOT}/hook-status.out"
[[ "$(git -C "${PRODUCT_TARGET}" config --local --get core.hooksPath)" == ".githooks" ]] || fail "the Foundation hook path was not configured."

expect_failure python3 "${PRODUCT_TARGET}/scripts/check_compose.py"
grep -F "the full pack requires at least one service in compose.yaml" "${TEST_ROOT}/expected-failure.out" >/dev/null || fail "the empty Full pack was not rejected."

python3 - "${PRODUCT_TARGET}/compose.yaml" <<'PY'
import sys
from pathlib import Path

Path(sys.argv[1]).write_text(
    """name: product-project

services:
  contract-check:
    image: node:24.18.0-bookworm@sha256:5711a0d445a1af54af9589066c646df387d1831a608226f4cd694fc59e745059
    command: [\"node\", \"--version\"]
    labels:
      foundation.lifecycle: job
""",
    encoding="utf-8",
)
PY
python3 "${PRODUCT_TARGET}/scripts/check_compose.py" >"${TEST_ROOT}/product-compose.out"
cp -p "${PRODUCT_TARGET}/compose.yaml" "${TEST_ROOT}/product-compose.yaml"

python3 - "${PRODUCT_TARGET}/compose.yaml" <<'PY'
import sys
from pathlib import Path

path = Path(sys.argv[1])
text = path.read_text(encoding="utf-8")
text = text.replace(
    "@sha256:5711a0d445a1af54af9589066c646df387d1831a608226f4cd694fc59e745059",
    "",
)
path.write_text(text, encoding="utf-8")
PY
expect_failure python3 "${PRODUCT_TARGET}/scripts/check_compose.py"
grep -F "external image for contract-check is not pinned by digest" "${TEST_ROOT}/expected-failure.out" >/dev/null || fail "the Compose checker accepted an image that is not pinned by digest."
cp -p "${TEST_ROOT}/product-compose.yaml" "${PRODUCT_TARGET}/compose.yaml"

python3 - "${PRODUCT_TARGET}/compose.yaml" <<'PY'
import sys
from pathlib import Path

path = Path(sys.argv[1])
text = path.read_text(encoding="utf-8").replace(
    "foundation.lifecycle: job",
    "foundation.lifecycle: service",
)
path.write_text(text, encoding="utf-8")
PY
expect_failure python3 "${PRODUCT_TARGET}/scripts/check_compose.py"
grep -F "long-running service contract-check has no healthcheck" "${TEST_ROOT}/expected-failure.out" >/dev/null || fail "the Compose checker accepted a long-running service without a healthcheck."
cp -p "${TEST_ROOT}/product-compose.yaml" "${PRODUCT_TARGET}/compose.yaml"

if [[ -n "${EXPECTED_FOUNDATION_COMMIT}" ]]; then
  expected_source_line="$(printf '| Source | `%s` |' "${EXPECTED_FOUNDATION_SOURCE}")"
  expected_version_line="$(printf '| Readable version | `%s` |' "${EXPECTED_FOUNDATION_TAG}")"
  expected_commit_line="$(printf '| Immutable commit | `%s` |' "${EXPECTED_FOUNDATION_COMMIT}")"
  expected_pack_line='| Adopted pack | `full` |'
  grep -F "${expected_source_line}" "${PRODUCT_TARGET}/FOUNDATION.md" >/dev/null || fail "the Foundation source is missing."
  grep -F "${expected_version_line}" "${PRODUCT_TARGET}/FOUNDATION.md" >/dev/null || fail "the Foundation version is missing."
  grep -F "${expected_commit_line}" "${PRODUCT_TARGET}/FOUNDATION.md" >/dev/null || fail "the Foundation commit is missing."
  grep -F "${expected_pack_line}" "${PRODUCT_TARGET}/FOUNDATION.md" >/dev/null || fail "the bootstrap pack is missing."
  grep -F '| Class | Product |' "${PRODUCT_TARGET}/PROJECT.md" >/dev/null || fail "the project class is not completed."
  grep -F '| Adopted by | unknown |' "${PRODUCT_TARGET}/FOUNDATION.md" >/dev/null || fail "the provenance actor was not sanitized."
  grep -F -- '- `web`' "${PRODUCT_TARGET}/FOUNDATION.md" >/dev/null || fail "the web profile is missing from the metadata."
  grep -F -- '- `backend-data`' "${PRODUCT_TARGET}/FOUNDATION.md" >/dev/null || fail "the backend-data profile is missing from the metadata."
  grep -F -- '- `documentation-nimbus`' "${PRODUCT_TARGET}/FOUNDATION.md" >/dev/null || fail "the mandatory Nimbus profile is missing from the metadata."
  if grep -F 'TODO tag' "${PRODUCT_TARGET}/FOUNDATION.md" >/dev/null; then
    fail "the version marker was not replaced."
  fi
  if grep -F 'TODO full SHA' "${PRODUCT_TARGET}/FOUNDATION.md" >/dev/null; then
    fail "the commit marker was not replaced."
  fi
fi

python3 "${PRODUCT_TARGET}/scripts/documentation_catalog.py" --check >"${TEST_ROOT}/catalog-check-baseline.out"
mkdir -p "${PRODUCT_TARGET}/docs/notes"
printf '%s\n' '# Orphan note' >"${PRODUCT_TARGET}/docs/notes/orphan.md"
expect_failure python3 "${PRODUCT_TARGET}/scripts/documentation_catalog.py" --check
grep -F "Unclassified Markdown file: docs/notes/orphan.md" "${TEST_ROOT}/expected-failure.out" >/dev/null || fail "the unclassified Markdown file was not detected."
rm -f "${PRODUCT_TARGET}/docs/notes/orphan.md"
rmdir "${PRODUCT_TARGET}/docs/notes"

cp -p "${PRODUCT_TARGET}/documentation.json" "${TEST_ROOT}/product-documentation.json"
python3 - "${PRODUCT_TARGET}/documentation.json" <<'PY'
import json
import sys
from pathlib import Path

path = Path(sys.argv[1])
manifest = json.loads(path.read_text(encoding="utf-8"))
manifest["collections"][0]["include"].append("docs/foundation/**/*.md")
path.write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
PY
expect_failure python3 "${PRODUCT_TARGET}/scripts/documentation_catalog.py" --check
grep -F "Markdown file classified more than once: docs/foundation/DEFAULTS.md" "${TEST_ROOT}/expected-failure.out" >/dev/null || fail "the Markdown file with multiple classifications was not detected."
cp -p "${TEST_ROOT}/product-documentation.json" "${PRODUCT_TARGET}/documentation.json"

if python3 "${PRODUCT_TARGET}/scripts/check_markdown.py" >"${TEST_ROOT}/project-checker-baseline.out" 2>&1; then
  fail "the project checker was expected to reject input markers."
fi
grep -F "unresolved TODO marker" "${TEST_ROOT}/project-checker-baseline.out" >/dev/null || fail "the project checker does not detect input markers."
if grep -E "required file is missing|declared profile has no snapshot|profile snapshot is not declared in FOUNDATION.md" "${TEST_ROOT}/project-checker-baseline.out" >/dev/null; then
  fail "the generated Full pack is structurally inconsistent."
fi

[[ -d "${SOURCE_FOUNDATION_ROOT}/docs-nimbus/node_modules" ]] || fail "the Nimbus dependencies are missing. Run the complete verification before the bootstrap tests."
cmp -s \
  "${SOURCE_FOUNDATION_ROOT}/docs-nimbus/package-lock.json" \
  "${PRODUCT_TARGET}/docs-nimbus/package-lock.json" || fail "the bootstrap changed the Nimbus lockfile."
ln -s \
  "${SOURCE_FOUNDATION_ROOT}/docs-nimbus/node_modules" \
  "${PRODUCT_TARGET}/docs-nimbus/node_modules"
if ! (
  cd "${PRODUCT_TARGET}"
  npm run check --prefix docs-nimbus
) >"${TEST_ROOT}/product-nimbus-check.out" 2>&1; then
  tail -n 80 "${TEST_ROOT}/product-nimbus-check.out" >&2
  fail "the generated Full pack has an invalid Nimbus build."
fi
rm "${PRODUCT_TARGET}/docs-nimbus/node_modules"

mv \
  "${PRODUCT_TARGET}/docs/foundation/profiles/documentation-nimbus.md" \
  "${TEST_ROOT}/documentation-nimbus.md"
expect_failure python3 "${PRODUCT_TARGET}/scripts/check_markdown.py"
grep -F "the required documentation-nimbus profile is not declared" "${TEST_ROOT}/expected-failure.out" >/dev/null && fail "removing the Nimbus profile snapshot must not remove its declaration."
grep -F "declared profile has no snapshot: docs/foundation/profiles/documentation-nimbus.md" "${TEST_ROOT}/expected-failure.out" >/dev/null || fail "removal of the mandatory Nimbus profile snapshot was not detected."
mv \
  "${TEST_ROOT}/documentation-nimbus.md" \
  "${PRODUCT_TARGET}/docs/foundation/profiles/documentation-nimbus.md"

mv "${PRODUCT_TARGET}/docs-nimbus/package.json" "${TEST_ROOT}/nimbus-package.json"
expect_failure python3 "${PRODUCT_TARGET}/scripts/check_markdown.py"
grep -F "required file is missing: docs-nimbus/package.json" "${TEST_ROOT}/expected-failure.out" >/dev/null || fail "removal of the mandatory Nimbus package was not detected."
mv "${TEST_ROOT}/nimbus-package.json" "${PRODUCT_TARGET}/docs-nimbus/package.json"

mv "${PRODUCT_TARGET}/compose.yaml" "${TEST_ROOT}/required-compose.yaml"
expect_failure python3 "${PRODUCT_TARGET}/scripts/check_markdown.py"
grep -F "required file is missing: compose.yaml" "${TEST_ROOT}/expected-failure.out" >/dev/null || fail "removal of compose.yaml was not detected."
mv "${TEST_ROOT}/required-compose.yaml" "${PRODUCT_TARGET}/compose.yaml"

mv "${PRODUCT_TARGET}/scripts/check_compose.py" "${TEST_ROOT}/required-check-compose.py"
expect_failure python3 "${PRODUCT_TARGET}/scripts/check_markdown.py"
grep -F "required file is missing: scripts/check_compose.py" "${TEST_ROOT}/expected-failure.out" >/dev/null || fail "removal of the Compose checker was not detected."
mv "${TEST_ROOT}/required-check-compose.py" "${PRODUCT_TARGET}/scripts/check_compose.py"

mv "${PRODUCT_TARGET}/.github/workflows/verify.yml" "${TEST_ROOT}/required-workflow.yml"
expect_failure python3 "${PRODUCT_TARGET}/scripts/check_markdown.py"
grep -F "required file is missing: .github/workflows/verify.yml" "${TEST_ROOT}/expected-failure.out" >/dev/null || fail "removal of the CI workflow was not detected."
mv "${TEST_ROOT}/required-workflow.yml" "${PRODUCT_TARGET}/.github/workflows/verify.yml"

cp -p "${PRODUCT_TARGET}/scripts/verify.sh" "${TEST_ROOT}/wired-verify.sh"
python3 - "${PRODUCT_TARGET}/scripts/verify.sh" <<'PY'
import sys
from pathlib import Path

path = Path(sys.argv[1])
text = path.read_text(encoding="utf-8")
needle = 'python3 "${SCRIPT_DIR}/check_compose.py"\n'
if needle not in text:
    raise SystemExit("the expected Compose call is missing from the fixture")
path.write_text(text.replace(needle, "", 1), encoding="utf-8")
PY
expect_failure python3 "${PRODUCT_TARGET}/scripts/check_markdown.py"
grep -F "Compose gate is not connected: scripts/verify.sh" "${TEST_ROOT}/expected-failure.out" >/dev/null || fail "removal of the Compose call from verify was not detected."
mv "${TEST_ROOT}/wired-verify.sh" "${PRODUCT_TARGET}/scripts/verify.sh"

cp -p "${PRODUCT_TARGET}/.github/workflows/verify.yml" "${TEST_ROOT}/wired-workflow.yml"
python3 - "${PRODUCT_TARGET}/.github/workflows/verify.yml" <<'PY'
import sys
from pathlib import Path

path = Path(sys.argv[1])
text = path.read_text(encoding="utf-8")
needle = "          python3 scripts/check_compose.py\n"
if needle not in text:
    raise SystemExit("the expected Compose call is missing from the workflow fixture")
path.write_text(text.replace(needle, "", 1), encoding="utf-8")
PY
expect_failure python3 "${PRODUCT_TARGET}/scripts/check_markdown.py"
grep -F "Compose gate is not connected: .github/workflows/verify.yml" "${TEST_ROOT}/expected-failure.out" >/dev/null || fail "removal of the Compose call from CI was not detected."
mv "${TEST_ROOT}/wired-workflow.yml" "${PRODUCT_TARGET}/.github/workflows/verify.yml"

mv "${PRODUCT_TARGET}/foundation.lock.json" "${TEST_ROOT}/required-foundation-lock.json"
expect_failure python3 "${PRODUCT_TARGET}/scripts/check_markdown.py"
grep -F "required file is missing: foundation.lock.json" "${TEST_ROOT}/expected-failure.out" >/dev/null || fail "removal of the Foundation lock was not detected."
mv "${TEST_ROOT}/required-foundation-lock.json" "${PRODUCT_TARGET}/foundation.lock.json"

mv "${PRODUCT_TARGET}/.githooks/pre-commit" "${TEST_ROOT}/required-pre-commit"
expect_failure python3 "${PRODUCT_TARGET}/scripts/check_markdown.py"
grep -F "required file is missing: .githooks/pre-commit" "${TEST_ROOT}/expected-failure.out" >/dev/null || fail "removal of the Foundation pre-commit hook was not detected."
mv "${TEST_ROOT}/required-pre-commit" "${PRODUCT_TARGET}/.githooks/pre-commit"

cp -p "${PRODUCT_TARGET}/scripts/verify.sh" "${TEST_ROOT}/foundation-wired-verify.sh"
python3 - "${PRODUCT_TARGET}/scripts/verify.sh" <<'PY'
import sys
from pathlib import Path

path = Path(sys.argv[1])
text = path.read_text(encoding="utf-8")
needle = '  python3 "${SCRIPT_DIR}/foundation_sync.py" enforce\n'
if needle not in text:
    raise SystemExit("the expected Foundation enforcement call is missing")
path.write_text(text.replace(needle, "", 1), encoding="utf-8")
PY
expect_failure python3 "${PRODUCT_TARGET}/scripts/check_markdown.py"
grep -F "Foundation local enforcement is not connected: scripts/verify.sh" "${TEST_ROOT}/expected-failure.out" >/dev/null || fail "removal of local Foundation enforcement was not detected."
mv "${TEST_ROOT}/foundation-wired-verify.sh" "${PRODUCT_TARGET}/scripts/verify.sh"

cp -p "${PRODUCT_TARGET}/.github/workflows/foundation-sync.yml" "${TEST_ROOT}/foundation-wired-workflow.yml"
python3 - "${PRODUCT_TARGET}/.github/workflows/foundation-sync.yml" <<'PY'
import sys
from pathlib import Path

path = Path(sys.argv[1])
text = path.read_text(encoding="utf-8")
needle = "        run: python3 scripts/foundation_sync.py check\n"
if needle not in text:
    raise SystemExit("the expected Foundation CI call is missing")
path.write_text(text.replace(needle, "", 1), encoding="utf-8")
PY
expect_failure python3 "${PRODUCT_TARGET}/scripts/check_markdown.py"
grep -F "Foundation CI check is not connected: .github/workflows/foundation-sync.yml" "${TEST_ROOT}/expected-failure.out" >/dev/null || fail "removal of the Foundation CI check was not detected."
mv "${TEST_ROOT}/foundation-wired-workflow.yml" "${PRODUCT_TARGET}/.github/workflows/foundation-sync.yml"

rm -f "${PRODUCT_TARGET}/docs/foundation/PRINCIPLES.md"
expect_failure python3 "${PRODUCT_TARGET}/scripts/check_markdown.py"
grep -F "required file is missing: docs/foundation/PRINCIPLES.md" "${TEST_ROOT}/expected-failure.out" >/dev/null || fail "removal of the core was not detected."

rm -f "${PRODUCT_TARGET}/docs/foundation/profiles/web.md"
expect_failure python3 "${PRODUCT_TARGET}/scripts/check_markdown.py"
grep -F "declared profile has no snapshot: docs/foundation/profiles/web.md" "${TEST_ROOT}/expected-failure.out" >/dev/null || fail "removal of a profile snapshot was not detected."

printf '%s\n' \
  "# ADR-NNNN: Decision" \
  "" \
  "- Date: YYYY-MM-DD" >"${PRODUCT_TARGET}/docs/decisions/adr-placeholder.md"
expect_failure python3 "${PRODUCT_TARGET}/scripts/check_markdown.py"
grep -F "unresolved ADR identifier" "${TEST_ROOT}/expected-failure.out" >/dev/null || fail "the placeholder ADR identifier was not detected."
grep -F "unresolved ADR date" "${TEST_ROOT}/expected-failure.out" >/dev/null || fail "the placeholder ADR date was not detected."

python3 - "${PRODUCT_TARGET}/FOUNDATION.md" <<'PY'
import sys
from pathlib import Path

path = Path(sys.argv[1])
text = path.read_text(encoding="utf-8")
text = "\n".join(
    line for line in text.splitlines() if not line.startswith("| Immutable commit |")
) + "\n"
path.write_text(text, encoding="utf-8")
PY
expect_failure python3 "${PRODUCT_TARGET}/scripts/check_markdown.py"
grep -F "FOUNDATION.md has missing or invalid metadata: Immutable commit" "${TEST_ROOT}/expected-failure.out" >/dev/null || fail "removal of the provenance commit was not detected."

PROTOTYPE_TARGET="${TEST_ROOT}/prototype-project"
"${BOOTSTRAP}" \
  --target "${PROTOTYPE_TARGET}" \
  --class prototype \
  --profiles experiment,documentation-nimbus >/dev/null

printf '%s\n' \
  "./.github/workflows/foundation-sync.yml" \
  "./.github/workflows/verify.yml" \
  "./.githooks/pre-commit" \
  "./AGENTS.md" \
  "./CHANGELOG.md" \
  "./DOCUMENTATION-CATALOG.md" \
  "./DOCUMENTATION.md" \
  "./FOUNDATION.md" \
  "./PROJECT.md" \
  "./README.md" \
  "./ROADMAP.md" \
  "./STATUS.md" \
  "./compose.yaml" \
  "./docs/decisions/.gitkeep" \
  "./docs/foundation/DEFAULTS.md" \
  "./docs/foundation/DEFINITION-OF-DONE.md" \
  "./docs/foundation/PRINCIPLES.md" \
  "./docs/foundation/profiles/documentation-nimbus.md" \
  "./docs/foundation/profiles/experiment.md" \
  "./documentation.json" \
  "./foundation.lock.json" \
  "./scripts/check_compose.py" \
  "./scripts/check_markdown.py" \
  "./scripts/documentation_catalog.py" \
  "./scripts/foundation_sync.py" \
  "./scripts/install_foundation_hook.sh" \
  "./scripts/verify.sh" >"${TEST_ROOT}/prototype.expected"
append_nimbus_expected "${TEST_ROOT}/prototype.expected"
tree_files "${PROTOTYPE_TARGET}" >"${TEST_ROOT}/prototype.actual"
diff -u "${TEST_ROOT}/prototype.expected" "${TEST_ROOT}/prototype.actual" || fail "the prototype tree is not as expected."
grep -F '| Adopted pack | `standard` |' "${PROTOTYPE_TARGET}/FOUNDATION.md" >/dev/null || fail "the Standard pack metadata is missing."
grep -F '| Class | Prototype |' "${PROTOTYPE_TARGET}/PROJECT.md" >/dev/null || fail "the prototype class is not completed."

CRITICAL_TARGET="${TEST_ROOT}/critical-project"
"${BOOTSTRAP}" \
  --target "${CRITICAL_TARGET}" \
  --class critical \
  --profiles infrastructure-production,dependency-change >/dev/null

printf '%s\n' \
  "./.github/workflows/foundation-sync.yml" \
  "./.github/workflows/verify.yml" \
  "./.githooks/pre-commit" \
  "./AGENTS.md" \
  "./CHANGELOG.md" \
  "./DELIVERY-EVIDENCE.md" \
  "./DOCUMENTATION-CATALOG.md" \
  "./DOCUMENTATION.md" \
  "./FOUNDATION.md" \
  "./PROJECT.md" \
  "./README.md" \
  "./ROADMAP.md" \
  "./RUNBOOK.md" \
  "./STATUS.md" \
  "./compose.yaml" \
  "./docs/decisions/.gitkeep" \
  "./docs/foundation/DEFAULTS.md" \
  "./docs/foundation/DEFINITION-OF-DONE.md" \
  "./docs/foundation/PRINCIPLES.md" \
  "./docs/foundation/profiles/dependency-change.md" \
  "./docs/foundation/profiles/documentation-nimbus.md" \
  "./docs/foundation/profiles/infrastructure-production.md" \
  "./documentation.json" \
  "./foundation.lock.json" \
  "./scripts/check_compose.py" \
  "./scripts/check_markdown.py" \
  "./scripts/documentation_catalog.py" \
  "./scripts/foundation_sync.py" \
  "./scripts/install_foundation_hook.sh" \
  "./scripts/verify.sh" >"${TEST_ROOT}/critical.expected"
append_nimbus_expected "${TEST_ROOT}/critical.expected"
tree_files "${CRITICAL_TARGET}" >"${TEST_ROOT}/critical.actual"
diff -u "${TEST_ROOT}/critical.expected" "${TEST_ROOT}/critical.actual" || fail "the critical tree is not as expected."
grep -F '| Adopted pack | `critical` |' "${CRITICAL_TARGET}/FOUNDATION.md" >/dev/null || fail "the Critical pack metadata is missing."
grep -F '| Class | Critical |' "${CRITICAL_TARGET}/PROJECT.md" >/dev/null || fail "the critical class is not completed."

if python3 "${CRITICAL_TARGET}/scripts/check_markdown.py" >"${TEST_ROOT}/critical-checker-baseline.out" 2>&1; then
  fail "the critical checker was expected to reject input markers."
fi
if grep -F "required file for the critical pack is missing" "${TEST_ROOT}/critical-checker-baseline.out" >/dev/null; then
  fail "the generated Critical pack is structurally inconsistent."
fi
rm -f "${CRITICAL_TARGET}/RUNBOOK.md" "${CRITICAL_TARGET}/DELIVERY-EVIDENCE.md"
expect_failure python3 "${CRITICAL_TARGET}/scripts/check_markdown.py"
grep -F "required file for the critical pack is missing: RUNBOOK.md" "${TEST_ROOT}/expected-failure.out" >/dev/null || fail "removal of the runbook was not detected."
grep -F "required file for the critical pack is missing: DELIVERY-EVIDENCE.md" "${TEST_ROOT}/expected-failure.out" >/dev/null || fail "removal of the delivery evidence was not detected."

before_checksum="$(cksum "${PRODUCT_TARGET}/README.md")"
expect_failure "${BOOTSTRAP}" \
  --target "${PRODUCT_TARGET}" \
  --class product \
  --profiles web
after_checksum="$(cksum "${PRODUCT_TARGET}/README.md")"
[[ "${before_checksum}" == "${after_checksum}" ]] || fail "an existing file was modified."

expect_failure "${BOOTSTRAP}" --target relative/project --class exploration --profiles none
expect_failure "${BOOTSTRAP}" --target "${TEST_ROOT}/bad-class" --class demo --profiles none
expect_failure "${BOOTSTRAP}" --target "${TEST_ROOT}/bad-profile" --class product --profiles unknown
expect_failure "${BOOTSTRAP}" --target "${TEST_ROOT}/critical-without-profile" --class critical --profiles none
expect_failure "${BOOTSTRAP}" --target "${TEST_ROOT}/critical-with-weak-profile" --class critical --profiles web
expect_failure "${BOOTSTRAP}" --target / --class product --profiles none --dry-run

echo "Bootstrap tests passed."
