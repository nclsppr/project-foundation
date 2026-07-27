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
  echo "Échec test bootstrap : $*" >&2
  exit 1
}

expect_failure() {
  if "$@" >"${TEST_ROOT}/expected-failure.out" 2>&1; then
    fail "la commande devait échouer : $*"
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
    "${SOURCE_FOUNDATION_ROOT}/scripts/documentation_catalog.py" \
    "${SOURCE_FOUNDATION_ROOT}/scripts/sanitize_git_remote.py" \
    "${destination}/scripts/"
}

FOUNDATION_ROOT="${TEST_ROOT}/foundation-fixture"
copy_foundation_fixture "${FOUNDATION_ROOT}"
FOUNDATION_ROOT="$(cd -- "${FOUNDATION_ROOT}" && pwd -P)"
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

sanitized_https="$("${SANITIZER}" 'https://user:secret@example.com/org/repo.git?access_token=secret#fragment')"
[[ "${sanitized_https}" == "https://example.com/org/repo.git" ]] || fail "remote HTTPS mal nettoyé."
sanitized_ssh="$("${SANITIZER}" 'git@github.com:owner/repo.git')"
[[ "${sanitized_ssh}" == "ssh://github.com/owner/repo.git" ]] || fail "remote SSH mal normalisé."
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
grep -F "doit être la racine de son propre dépôt Git" "${TEST_ROOT}/expected-failure.out" >/dev/null || fail "racine Git parente non détectée."

DRY_TARGET="${TEST_ROOT}/dry-run-project"
"${BOOTSTRAP}" \
  --target "${DRY_TARGET}" \
  --class exploration \
  --profiles experiment \
  --dry-run >"${TEST_ROOT}/dry-run.out"
[[ ! -e "${DRY_TARGET}" ]] || fail "le dry-run a créé la cible."
grep -F "Mode dry-run : aucune écriture." "${TEST_ROOT}/dry-run.out" >/dev/null || fail "sortie dry-run absente."
grep -F "docs/foundation/profiles/experiment.md" "${TEST_ROOT}/dry-run.out" >/dev/null || fail "profil absent du dry-run."

EXPLORATION_TARGET="${TEST_ROOT}/exploration-project"
"${BOOTSTRAP}" \
  --target "${EXPLORATION_TARGET}" \
  --class exploration \
  --profiles experiment,web >/dev/null

printf '%s\n' \
  "./AGENTS.md" \
  "./BRIEF.md" \
  "./CHANGELOG.md" \
  "./DOCUMENTATION-CATALOG.md" \
  "./DOCUMENTATION.md" \
  "./FOUNDATION.md" \
  "./README.md" \
  "./docs/decisions/.gitkeep" \
  "./docs/foundation/DEFAULTS.md" \
  "./docs/foundation/DEFINITION-OF-DONE.md" \
  "./docs/foundation/PRINCIPLES.md" \
  "./docs/foundation/profiles/documentation-nimbus.md" \
  "./docs/foundation/profiles/experiment.md" \
  "./docs/foundation/profiles/web.md" \
  "./documentation.json" \
  "./scripts/check_markdown.py" \
  "./scripts/documentation_catalog.py" \
  "./scripts/verify.sh" >"${TEST_ROOT}/exploration.expected"
append_nimbus_expected "${TEST_ROOT}/exploration.expected"
tree_files "${EXPLORATION_TARGET}" >"${TEST_ROOT}/exploration.actual"
diff -u "${TEST_ROOT}/exploration.expected" "${TEST_ROOT}/exploration.actual" || fail "arbre exploration inattendu."
[[ -x "${EXPLORATION_TARGET}/scripts/verify.sh" ]] || fail "verify exploration non exécutable."
[[ -x "${EXPLORATION_TARGET}/scripts/documentation_catalog.py" ]] || fail "catalogue exploration non exécutable."
[[ ! -e "${EXPLORATION_TARGET}/.git" ]] || fail "le bootstrap a initialisé Git."
[[ ! -e "${EXPLORATION_TARGET}/DESIGN.md" ]] || fail "le pack minimal a reçu DESIGN.md."
grep -F '| Pack adopté | `minimal` |' "${EXPLORATION_TARGET}/FOUNDATION.md" >/dev/null || fail "pack minimal absent."
grep -F '"@cloudflare/nimbus-docs": "0.8.2"' "${EXPLORATION_TARGET}/docs-nimbus/package.json" >/dev/null || fail "version Nimbus obligatoire absente du pack minimal."
grep -F '"name": "nimbus"' "${EXPLORATION_TARGET}/documentation.json" >/dev/null || fail "renderer Nimbus absent du pack minimal."

PRODUCT_TARGET="${TEST_ROOT}/product-project"
USER='unsafe|actor' "${BOOTSTRAP}" \
  --target "${PRODUCT_TARGET}" \
  --class product \
  --profiles web,backend-data >/dev/null

printf '%s\n' \
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
  "./docs/decisions/.gitkeep" \
  "./docs/foundation/DEFAULTS.md" \
  "./docs/foundation/DEFINITION-OF-DONE.md" \
  "./docs/foundation/PRINCIPLES.md" \
  "./docs/foundation/profiles/backend-data.md" \
  "./docs/foundation/profiles/documentation-nimbus.md" \
  "./docs/foundation/profiles/web.md" \
  "./documentation.json" \
  "./scripts/check_markdown.py" \
  "./scripts/documentation_catalog.py" \
  "./scripts/verify.sh" >"${TEST_ROOT}/product.expected"
append_nimbus_expected "${TEST_ROOT}/product.expected"
tree_files "${PRODUCT_TARGET}" >"${TEST_ROOT}/product.actual"
diff -u "${TEST_ROOT}/product.expected" "${TEST_ROOT}/product.actual" || fail "arbre product inattendu."
[[ -x "${PRODUCT_TARGET}/scripts/documentation_catalog.py" ]] || fail "catalogue product non exécutable."

if [[ -n "${EXPECTED_FOUNDATION_COMMIT}" ]]; then
  expected_source_line="$(printf '| Source | `%s` |' "${EXPECTED_FOUNDATION_SOURCE}")"
  expected_version_line="$(printf '| Version lisible | `%s` |' "${EXPECTED_FOUNDATION_TAG}")"
  expected_commit_line="$(printf '| Commit immuable | `%s` |' "${EXPECTED_FOUNDATION_COMMIT}")"
  expected_pack_line='| Pack adopté | `full` |'
  grep -F "${expected_source_line}" "${PRODUCT_TARGET}/FOUNDATION.md" >/dev/null || fail "source du socle absente."
  grep -F "${expected_version_line}" "${PRODUCT_TARGET}/FOUNDATION.md" >/dev/null || fail "version du socle absente."
  grep -F "${expected_commit_line}" "${PRODUCT_TARGET}/FOUNDATION.md" >/dev/null || fail "commit du socle absent."
  grep -F "${expected_pack_line}" "${PRODUCT_TARGET}/FOUNDATION.md" >/dev/null || fail "pack du bootstrap absent."
  grep -F '| Classe | Produit |' "${PRODUCT_TARGET}/PROJECT.md" >/dev/null || fail "classe du projet non remplie."
  grep -F '| Adoptée par | unknown |' "${PRODUCT_TARGET}/FOUNDATION.md" >/dev/null || fail "acteur de provenance non nettoyé."
  grep -F -- '- `web`' "${PRODUCT_TARGET}/FOUNDATION.md" >/dev/null || fail "profil web absent des métadonnées."
  grep -F -- '- `backend-data`' "${PRODUCT_TARGET}/FOUNDATION.md" >/dev/null || fail "profil backend-data absent des métadonnées."
  grep -F -- '- `documentation-nimbus`' "${PRODUCT_TARGET}/FOUNDATION.md" >/dev/null || fail "profil Nimbus obligatoire absent des métadonnées."
  if grep -F 'TODO tag' "${PRODUCT_TARGET}/FOUNDATION.md" >/dev/null; then
    fail "marqueur de version non remplacé."
  fi
  if grep -F 'TODO SHA complet' "${PRODUCT_TARGET}/FOUNDATION.md" >/dev/null; then
    fail "marqueur de commit non remplacé."
  fi
fi

python3 "${PRODUCT_TARGET}/scripts/documentation_catalog.py" --check >"${TEST_ROOT}/catalog-check-baseline.out"
mkdir -p "${PRODUCT_TARGET}/docs/notes"
printf '%s\n' '# Note orpheline' >"${PRODUCT_TARGET}/docs/notes/orphan.md"
expect_failure python3 "${PRODUCT_TARGET}/scripts/documentation_catalog.py" --check
grep -F "Markdown orphelin : docs/notes/orphan.md" "${TEST_ROOT}/expected-failure.out" >/dev/null || fail "Markdown orphelin non détecté."
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
grep -F "Markdown classé plusieurs fois : docs/foundation/DEFAULTS.md" "${TEST_ROOT}/expected-failure.out" >/dev/null || fail "Markdown classé plusieurs fois non détecté."
cp -p "${TEST_ROOT}/product-documentation.json" "${PRODUCT_TARGET}/documentation.json"

if python3 "${PRODUCT_TARGET}/scripts/check_markdown.py" >"${TEST_ROOT}/project-checker-baseline.out" 2>&1; then
  fail "le checker projet devait refuser les marqueurs de saisie."
fi
grep -F "marqueur TODO non résolu" "${TEST_ROOT}/project-checker-baseline.out" >/dev/null || fail "le checker projet ne détecte pas les marqueurs."
if grep -E "fichier requis absent|profil déclaré sans snapshot|snapshot de profil non déclaré" "${TEST_ROOT}/project-checker-baseline.out" >/dev/null; then
  fail "le pack product généré est structurellement incohérent."
fi

[[ -d "${SOURCE_FOUNDATION_ROOT}/docs-nimbus/node_modules" ]] || fail "dépendances Nimbus absentes ; lancer la vérification complète avant les tests du bootstrap."
cmp -s \
  "${SOURCE_FOUNDATION_ROOT}/docs-nimbus/package-lock.json" \
  "${PRODUCT_TARGET}/docs-nimbus/package-lock.json" || fail "lockfile Nimbus altéré pendant le bootstrap."
ln -s \
  "${SOURCE_FOUNDATION_ROOT}/docs-nimbus/node_modules" \
  "${PRODUCT_TARGET}/docs-nimbus/node_modules"
if ! (
  cd "${PRODUCT_TARGET}"
  npm run check --prefix docs-nimbus
) >"${TEST_ROOT}/product-nimbus-check.out" 2>&1; then
  tail -n 80 "${TEST_ROOT}/product-nimbus-check.out" >&2
  fail "build Nimbus du pack product généré invalide."
fi
rm "${PRODUCT_TARGET}/docs-nimbus/node_modules"

mv \
  "${PRODUCT_TARGET}/docs/foundation/profiles/documentation-nimbus.md" \
  "${TEST_ROOT}/documentation-nimbus.md"
expect_failure python3 "${PRODUCT_TARGET}/scripts/check_markdown.py"
grep -F "le profil obligatoire documentation-nimbus n'est pas déclaré" "${TEST_ROOT}/expected-failure.out" >/dev/null && fail "le retrait du profil Nimbus ne doit pas effacer sa déclaration."
grep -F "profil déclaré sans snapshot : docs/foundation/profiles/documentation-nimbus.md" "${TEST_ROOT}/expected-failure.out" >/dev/null || fail "retrait du profil Nimbus obligatoire non détecté."
mv \
  "${TEST_ROOT}/documentation-nimbus.md" \
  "${PRODUCT_TARGET}/docs/foundation/profiles/documentation-nimbus.md"

mv "${PRODUCT_TARGET}/docs-nimbus/package.json" "${TEST_ROOT}/nimbus-package.json"
expect_failure python3 "${PRODUCT_TARGET}/scripts/check_markdown.py"
grep -F "fichier requis absent : docs-nimbus/package.json" "${TEST_ROOT}/expected-failure.out" >/dev/null || fail "retrait du package Nimbus obligatoire non détecté."
mv "${TEST_ROOT}/nimbus-package.json" "${PRODUCT_TARGET}/docs-nimbus/package.json"

rm -f "${PRODUCT_TARGET}/docs/foundation/PRINCIPLES.md"
expect_failure python3 "${PRODUCT_TARGET}/scripts/check_markdown.py"
grep -F "fichier requis absent : docs/foundation/PRINCIPLES.md" "${TEST_ROOT}/expected-failure.out" >/dev/null || fail "suppression du noyau non détectée."

rm -f "${PRODUCT_TARGET}/docs/foundation/profiles/web.md"
expect_failure python3 "${PRODUCT_TARGET}/scripts/check_markdown.py"
grep -F "profil déclaré sans snapshot : docs/foundation/profiles/web.md" "${TEST_ROOT}/expected-failure.out" >/dev/null || fail "suppression d'un profil non détectée."

printf '%s\n' \
  "# ADR-NNNN : décision" \
  "" \
  "- Date : YYYY-MM-DD" >"${PRODUCT_TARGET}/docs/decisions/adr-placeholder.md"
expect_failure python3 "${PRODUCT_TARGET}/scripts/check_markdown.py"
grep -F "identifiant ADR non résolu" "${TEST_ROOT}/expected-failure.out" >/dev/null || fail "identifiant ADR factice non détecté."
grep -F "date ADR non résolue" "${TEST_ROOT}/expected-failure.out" >/dev/null || fail "date ADR factice non détectée."

python3 - "${PRODUCT_TARGET}/FOUNDATION.md" <<'PY'
import sys
from pathlib import Path

path = Path(sys.argv[1])
text = path.read_text(encoding="utf-8")
text = "\n".join(
    line for line in text.splitlines() if not line.startswith("| Commit immuable |")
) + "\n"
path.write_text(text, encoding="utf-8")
PY
expect_failure python3 "${PRODUCT_TARGET}/scripts/check_markdown.py"
grep -F "métadonnée absente ou invalide : Commit immuable" "${TEST_ROOT}/expected-failure.out" >/dev/null || fail "suppression du commit de provenance non détectée."

PROTOTYPE_TARGET="${TEST_ROOT}/prototype-project"
"${BOOTSTRAP}" \
  --target "${PROTOTYPE_TARGET}" \
  --class prototype \
  --profiles experiment,documentation-nimbus >/dev/null

printf '%s\n' \
  "./AGENTS.md" \
  "./CHANGELOG.md" \
  "./DOCUMENTATION-CATALOG.md" \
  "./DOCUMENTATION.md" \
  "./FOUNDATION.md" \
  "./PROJECT.md" \
  "./README.md" \
  "./ROADMAP.md" \
  "./STATUS.md" \
  "./docs/decisions/.gitkeep" \
  "./docs/foundation/DEFAULTS.md" \
  "./docs/foundation/DEFINITION-OF-DONE.md" \
  "./docs/foundation/PRINCIPLES.md" \
  "./docs/foundation/profiles/documentation-nimbus.md" \
  "./docs/foundation/profiles/experiment.md" \
  "./documentation.json" \
  "./scripts/check_markdown.py" \
  "./scripts/documentation_catalog.py" \
  "./scripts/verify.sh" >"${TEST_ROOT}/prototype.expected"
append_nimbus_expected "${TEST_ROOT}/prototype.expected"
tree_files "${PROTOTYPE_TARGET}" >"${TEST_ROOT}/prototype.actual"
diff -u "${TEST_ROOT}/prototype.expected" "${TEST_ROOT}/prototype.actual" || fail "arbre prototype inattendu."
grep -F '| Pack adopté | `standard` |' "${PROTOTYPE_TARGET}/FOUNDATION.md" >/dev/null || fail "pack standard absent."
grep -F '| Classe | Prototype |' "${PROTOTYPE_TARGET}/PROJECT.md" >/dev/null || fail "classe prototype non remplie."

CRITICAL_TARGET="${TEST_ROOT}/critical-project"
"${BOOTSTRAP}" \
  --target "${CRITICAL_TARGET}" \
  --class critical \
  --profiles infrastructure-production,dependency-change >/dev/null

printf '%s\n' \
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
  "./docs/decisions/.gitkeep" \
  "./docs/foundation/DEFAULTS.md" \
  "./docs/foundation/DEFINITION-OF-DONE.md" \
  "./docs/foundation/PRINCIPLES.md" \
  "./docs/foundation/profiles/dependency-change.md" \
  "./docs/foundation/profiles/documentation-nimbus.md" \
  "./docs/foundation/profiles/infrastructure-production.md" \
  "./documentation.json" \
  "./scripts/check_markdown.py" \
  "./scripts/documentation_catalog.py" \
  "./scripts/verify.sh" >"${TEST_ROOT}/critical.expected"
append_nimbus_expected "${TEST_ROOT}/critical.expected"
tree_files "${CRITICAL_TARGET}" >"${TEST_ROOT}/critical.actual"
diff -u "${TEST_ROOT}/critical.expected" "${TEST_ROOT}/critical.actual" || fail "arbre critical inattendu."
grep -F '| Pack adopté | `critical` |' "${CRITICAL_TARGET}/FOUNDATION.md" >/dev/null || fail "pack critical absent."
grep -F '| Classe | Critique |' "${CRITICAL_TARGET}/PROJECT.md" >/dev/null || fail "classe critique non remplie."

if python3 "${CRITICAL_TARGET}/scripts/check_markdown.py" >"${TEST_ROOT}/critical-checker-baseline.out" 2>&1; then
  fail "le checker critical devait refuser les marqueurs de saisie."
fi
if grep -F "fichier requis pour le pack critical absent" "${TEST_ROOT}/critical-checker-baseline.out" >/dev/null; then
  fail "le pack critical généré est structurellement incohérent."
fi
rm -f "${CRITICAL_TARGET}/RUNBOOK.md" "${CRITICAL_TARGET}/DELIVERY-EVIDENCE.md"
expect_failure python3 "${CRITICAL_TARGET}/scripts/check_markdown.py"
grep -F "fichier requis pour le pack critical absent : RUNBOOK.md" "${TEST_ROOT}/expected-failure.out" >/dev/null || fail "suppression du runbook non détectée."
grep -F "fichier requis pour le pack critical absent : DELIVERY-EVIDENCE.md" "${TEST_ROOT}/expected-failure.out" >/dev/null || fail "suppression de la preuve de livraison non détectée."

before_checksum="$(cksum "${PRODUCT_TARGET}/README.md")"
expect_failure "${BOOTSTRAP}" \
  --target "${PRODUCT_TARGET}" \
  --class product \
  --profiles web
after_checksum="$(cksum "${PRODUCT_TARGET}/README.md")"
[[ "${before_checksum}" == "${after_checksum}" ]] || fail "un fichier existant a été modifié."

expect_failure "${BOOTSTRAP}" --target relative/project --class exploration --profiles none
expect_failure "${BOOTSTRAP}" --target "${TEST_ROOT}/bad-class" --class demo --profiles none
expect_failure "${BOOTSTRAP}" --target "${TEST_ROOT}/bad-profile" --class product --profiles unknown
expect_failure "${BOOTSTRAP}" --target "${TEST_ROOT}/critical-without-profile" --class critical --profiles none
expect_failure "${BOOTSTRAP}" --target "${TEST_ROOT}/critical-with-weak-profile" --class critical --profiles web
expect_failure "${BOOTSTRAP}" --target / --class product --profiles none --dry-run

echo "Tests bootstrap réussis."
