#!/usr/bin/env bash
set -euo pipefail

if (( BASH_VERSINFO[0] < 3 || (BASH_VERSINFO[0] == 3 && BASH_VERSINFO[1] < 2) )); then
  echo "Bash >= 3.2 est requis." >&2
  exit 1
fi

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
FOUNDATION_ROOT="$(cd -- "${SCRIPT_DIR}/.." && pwd -P)"
TEMPLATE_ROOT="${FOUNDATION_ROOT}/templates"

usage() {
  cat <<'USAGE'
Usage:
  ./scripts/bootstrap.sh \
    --target /chemin/absolu/nouveau-projet \
    --class exploration|prototype|product|critical \
    --profiles web,backend-data,infrastructure-production,experiment,generated-artifacts,dependency-change,documentation-nimbus|none \
    [--dry-run]

Le chemin cible doit être absolu, son dossier parent doit déjà exister et la
cible ne doit pas exister. Le bootstrap ne remplace aucun fichier, n'initialise
pas Git et ne publie rien.
USAGE
}

fail() {
  echo "Erreur : $*" >&2
  exit 1
}

TARGET_INPUT=""
PROJECT_CLASS=""
PROFILE_CSV=""
DRY_RUN=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --target)
      [[ $# -ge 2 ]] || fail "--target attend une valeur."
      TARGET_INPUT="$2"
      shift 2
      ;;
    --class)
      [[ $# -ge 2 ]] || fail "--class attend une valeur."
      PROJECT_CLASS="$2"
      shift 2
      ;;
    --profiles)
      [[ $# -ge 2 ]] || fail "--profiles attend une valeur CSV ou 'none'."
      PROFILE_CSV="$2"
      shift 2
      ;;
    --dry-run)
      DRY_RUN=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      fail "option inconnue : $1"
      ;;
  esac
done

[[ -n "${TARGET_INPUT}" ]] || fail "--target est requis."
[[ -n "${PROJECT_CLASS}" ]] || fail "--class est requis."
[[ -n "${PROFILE_CSV}" ]] || fail "--profiles est requis ; utiliser 'none' si nécessaire."
[[ "${TARGET_INPUT}" = /* ]] || fail "--target doit être un chemin absolu."
[[ "${TARGET_INPUT}" != *$'\n'* ]] || fail "--target ne peut pas contenir de saut de ligne."

case "${PROJECT_CLASS}" in
  exploration)
    PROJECT_CLASS_LABEL="Exploration"
    PROJECT_PACK="minimal"
    ;;
  prototype)
    PROJECT_CLASS_LABEL="Prototype"
    PROJECT_PACK="standard"
    ;;
  product)
    PROJECT_CLASS_LABEL="Produit"
    PROJECT_PACK="full"
    ;;
  critical)
    PROJECT_CLASS_LABEL="Critique"
    PROJECT_PACK="critical"
    ;;
  *) fail "classe invalide : ${PROJECT_CLASS}" ;;
esac

command -v python3 >/dev/null 2>&1 || fail "Python >= 3.9 est requis."
python3 -c 'import sys; raise SystemExit(0 if sys.version_info >= (3, 9) else 1)' || {
  detected_version="$(python3 -c 'import platform; print(platform.python_version())')"
  fail "Python >= 3.9 est requis (version détectée : ${detected_version})."
}

TARGET="$(python3 - "${TARGET_INPUT}" <<'PY'
import sys
from pathlib import Path

print(Path(sys.argv[1]).expanduser().resolve(strict=False))
PY
)"

[[ "${TARGET}" != "/" ]] || fail "la racine du système est une cible interdite."
case "${TARGET}" in
  /Applications|/Library|/System|/Users|/Volumes|/bin|/dev|/etc|/home|/opt|/private|/private/tmp|/proc|/root|/run|/sbin|/srv|/tmp|/usr|/var)
    fail "cible système ou trop large interdite : ${TARGET}"
    ;;
esac

case "${FOUNDATION_ROOT}/" in
  "${TARGET}/"*) fail "la cible ne peut pas contenir Project Foundation." ;;
esac
case "${TARGET}/" in
  "${FOUNDATION_ROOT}/"*) fail "la cible ne peut pas être dans Project Foundation." ;;
esac

[[ ! -e "${TARGET}" && ! -L "${TARGET}" ]] || fail "la cible existe déjà ; aucun écrasement n'est autorisé : ${TARGET}"
TARGET_PARENT="$(dirname -- "${TARGET}")"
TARGET_NAME="$(basename -- "${TARGET}")"
[[ -d "${TARGET_PARENT}" ]] || fail "le dossier parent doit déjà exister : ${TARGET_PARENT}"
[[ "${TARGET_NAME}" != "." && "${TARGET_NAME}" != ".." && -n "${TARGET_NAME}" ]] || fail "nom de cible invalide."

PROFILES=()
if [[ "${PROFILE_CSV}" != "none" ]]; then
  old_ifs="${IFS}"
  IFS=','
  read -r -a requested_profiles <<< "${PROFILE_CSV}"
  IFS="${old_ifs}"
  [[ ${#requested_profiles[@]} -gt 0 ]] || fail "liste de profils vide."

  for raw_profile in "${requested_profiles[@]}"; do
    profile="$(printf '%s' "${raw_profile}" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
    case "${profile}" in
      web|backend-data|infrastructure-production|experiment|generated-artifacts|dependency-change|documentation-nimbus) ;;
      "") fail "profil vide dans --profiles." ;;
      *) fail "profil inconnu : ${profile}" ;;
    esac

    duplicate=0
    for existing_profile in "${PROFILES[@]:-}"; do
      if [[ "${existing_profile}" == "${profile}" ]]; then
        duplicate=1
      fi
    done
    [[ ${duplicate} -eq 1 ]] || PROFILES+=("${profile}")
  done
fi

SOURCES=()
DESTINATIONS=()

add_copy() {
  SOURCES+=("$1")
  DESTINATIONS+=("$2")
}

add_copy "${TEMPLATE_ROOT}/FOUNDATION.md" "FOUNDATION.md"
add_copy "${TEMPLATE_ROOT}/DOCUMENTATION.md" "DOCUMENTATION.md"
add_copy "${TEMPLATE_ROOT}/documentation.json" "documentation.json"

case "${PROJECT_CLASS}" in
  exploration)
    add_copy "${TEMPLATE_ROOT}/README.md" "README.md"
    add_copy "${TEMPLATE_ROOT}/BRIEF.md" "BRIEF.md"
    add_copy "${TEMPLATE_ROOT}/AGENTS-minimal.md" "AGENTS.md"
    ;;
  prototype)
    add_copy "${TEMPLATE_ROOT}/README-standard.md" "README.md"
    add_copy "${TEMPLATE_ROOT}/PROJECT.md" "PROJECT.md"
    add_copy "${TEMPLATE_ROOT}/STATUS.md" "STATUS.md"
    add_copy "${TEMPLATE_ROOT}/ROADMAP.md" "ROADMAP.md"
    add_copy "${TEMPLATE_ROOT}/AGENTS.md" "AGENTS.md"
    ;;
  product)
    add_copy "${TEMPLATE_ROOT}/README-standard.md" "README.md"
    add_copy "${TEMPLATE_ROOT}/PROJECT.md" "PROJECT.md"
    add_copy "${TEMPLATE_ROOT}/STATUS.md" "STATUS.md"
    add_copy "${TEMPLATE_ROOT}/ROADMAP.md" "ROADMAP.md"
    add_copy "${TEMPLATE_ROOT}/AGENTS.md" "AGENTS.md"
    ;;
  critical)
    add_copy "${TEMPLATE_ROOT}/README-standard.md" "README.md"
    add_copy "${TEMPLATE_ROOT}/PROJECT.md" "PROJECT.md"
    add_copy "${TEMPLATE_ROOT}/STATUS.md" "STATUS.md"
    add_copy "${TEMPLATE_ROOT}/ROADMAP.md" "ROADMAP.md"
    add_copy "${TEMPLATE_ROOT}/AGENTS.md" "AGENTS.md"
    add_copy "${TEMPLATE_ROOT}/RUNBOOK.md" "RUNBOOK.md"
    add_copy "${TEMPLATE_ROOT}/DELIVERY-EVIDENCE.md" "DELIVERY-EVIDENCE.md"
    ;;
esac

add_copy "${FOUNDATION_ROOT}/PRINCIPLES.md" "docs/foundation/PRINCIPLES.md"
add_copy "${FOUNDATION_ROOT}/DEFAULTS.md" "docs/foundation/DEFAULTS.md"
add_copy "${FOUNDATION_ROOT}/DEFINITION-OF-DONE.md" "docs/foundation/DEFINITION-OF-DONE.md"

has_web_profile=0
for profile in "${PROFILES[@]:-}"; do
  [[ -n "${profile}" ]] || continue
  add_copy "${FOUNDATION_ROOT}/profiles/${profile}.md" "docs/foundation/profiles/${profile}.md"
  if [[ "${profile}" == "web" ]]; then
    has_web_profile=1
  fi
done

if [[ ${has_web_profile} -eq 1 && ( "${PROJECT_CLASS}" == "product" || "${PROJECT_CLASS}" == "critical" ) ]]; then
  add_copy "${TEMPLATE_ROOT}/DESIGN.md" "DESIGN.md"
fi

if [[ "${PROJECT_CLASS}" == "critical" ]]; then
  has_critical_profile=0
  for profile in "${PROFILES[@]}"; do
    if [[ "${profile}" == "backend-data" || "${profile}" == "infrastructure-production" ]]; then
      has_critical_profile=1
    fi
  done
  [[ ${has_critical_profile} -eq 1 ]] || fail "un projet critical doit sélectionner backend-data ou infrastructure-production."
fi

add_copy "${TEMPLATE_ROOT}/scripts/check_markdown.py" "scripts/check_markdown.py"
add_copy "${TEMPLATE_ROOT}/scripts/verify.sh" "scripts/verify.sh"
add_copy "${FOUNDATION_ROOT}/scripts/documentation_catalog.py" "scripts/documentation_catalog.py"

for source in "${SOURCES[@]}"; do
  [[ -f "${source}" ]] || fail "source de bootstrap absente : ${source#${FOUNDATION_ROOT}/}"
done

FOUNDATION_SOURCE="$("${SCRIPT_DIR}/sanitize_git_remote.py" "${FOUNDATION_ROOT}")" || fail "le chemin du socle ne peut pas être injecté dans FOUNDATION.md en sécurité."
FOUNDATION_COMMIT=""
FOUNDATION_TAG="unreleased"
FOUNDATION_DIRTY=0
FOUNDATION_GIT_ROOT=""
detected_git_root="$(git -C "${FOUNDATION_ROOT}" rev-parse --show-toplevel 2>/dev/null || true)"
if [[ -n "${detected_git_root}" ]]; then
  FOUNDATION_GIT_ROOT="$(cd -- "${detected_git_root}" && pwd -P)"
fi
if [[ "${FOUNDATION_GIT_ROOT}" == "${FOUNDATION_ROOT}" ]]; then
  configured_remote="$(git -C "${FOUNDATION_ROOT}" remote get-url origin 2>/dev/null || true)"
  if [[ -n "${configured_remote}" ]]; then
    sanitized_remote="$("${SCRIPT_DIR}/sanitize_git_remote.py" "${configured_remote}" 2>/dev/null || true)"
    if [[ -n "${sanitized_remote}" ]]; then
      FOUNDATION_SOURCE="${sanitized_remote}"
    fi
  fi
  FOUNDATION_COMMIT="$(git -C "${FOUNDATION_ROOT}" rev-parse HEAD 2>/dev/null || true)"
  exact_tag="$(git -C "${FOUNDATION_ROOT}" describe --tags --exact-match HEAD 2>/dev/null || true)"
  if [[ "${exact_tag}" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    FOUNDATION_TAG="${exact_tag}"
  fi
  if [[ -n "$(git -C "${FOUNDATION_ROOT}" status --porcelain --untracked-files=all)" ]]; then
    FOUNDATION_DIRTY=1
  fi
fi
ADOPTION_DATE="$(date +%F)"
ADOPTION_ACTOR="${USER:-unknown}"
if [[ ! "${ADOPTION_ACTOR}" =~ ^[A-Za-z0-9._-]+$ ]]; then
  ADOPTION_ACTOR="unknown"
fi
if [[ ${#PROFILES[@]} -eq 0 ]]; then
  PROFILE_LIST="none"
else
  PROFILE_LIST="$(IFS=,; echo "${PROFILES[*]}")"
fi

echo "Bootstrap ${PROJECT_CLASS} vers ${TARGET}"
if [[ ${#PROFILES[@]} -eq 0 ]]; then
  echo "Profils : aucun"
else
  echo "Profils : $(IFS=,; echo "${PROFILES[*]}")"
fi

if [[ ${DRY_RUN} -eq 1 ]]; then
  echo "Mode dry-run : aucune écriture."
  for index in "${!SOURCES[@]}"; do
    echo "COPY ${SOURCES[${index}]#${FOUNDATION_ROOT}/} -> ${TARGET}/${DESTINATIONS[${index}]}"
  done
  echo "MKDIR ${TARGET}/docs/decisions"
  if [[ -z "${FOUNDATION_COMMIT}" ]]; then
    echo "WARNING aucun commit du socle disponible ; les champs de version resteront à compléter."
  else
    echo "FOUNDATION source=${FOUNDATION_SOURCE} tag=${FOUNDATION_TAG} commit=${FOUNDATION_COMMIT} profiles=${PROFILE_LIST}"
  fi
  if [[ ${FOUNDATION_DIRTY} -eq 1 ]]; then
    echo "WARNING le worktree du socle est sale ; un bootstrap réel serait refusé."
  fi
  if [[ -n "${FOUNDATION_GIT_ROOT}" && "${FOUNDATION_GIT_ROOT}" != "${FOUNDATION_ROOT}" ]]; then
    echo "WARNING Project Foundation n'est pas la racine Git ; un bootstrap réel serait refusé."
  fi
  exit 0
fi

[[ "${FOUNDATION_GIT_ROOT}" == "${FOUNDATION_ROOT}" ]] || fail "Project Foundation doit être la racine de son propre dépôt Git."
[[ -n "${FOUNDATION_COMMIT}" ]] || fail "le socle doit posséder un commit avant un bootstrap réel."
if [[ ${FOUNDATION_DIRTY} -eq 1 ]]; then
  fail "le worktree du socle est sale ; committer ou retirer les changements avant le bootstrap."
fi

STAGING="$(mktemp -d "${TARGET_PARENT}/.${TARGET_NAME}.foundation.XXXXXX")"
cleanup() {
  if [[ -n "${STAGING:-}" && -d "${STAGING}" ]]; then
    rm -rf "${STAGING}"
  fi
}
trap cleanup EXIT INT TERM

for index in "${!SOURCES[@]}"; do
  destination="${STAGING}/${DESTINATIONS[${index}]}"
  mkdir -p "$(dirname -- "${destination}")"
  cp -p "${SOURCES[${index}]}" "${destination}"
done

mkdir -p "${STAGING}/docs/decisions"
: > "${STAGING}/docs/decisions/.gitkeep"
chmod +x \
  "${STAGING}/scripts/check_markdown.py" \
  "${STAGING}/scripts/documentation_catalog.py" \
  "${STAGING}/scripts/verify.sh"

if [[ -n "${FOUNDATION_COMMIT}" ]]; then
  python3 - \
    "${STAGING}/FOUNDATION.md" \
    "${STAGING}/PROJECT.md" \
    "${FOUNDATION_SOURCE}" \
    "${FOUNDATION_TAG}" \
    "${FOUNDATION_COMMIT}" \
    "${ADOPTION_DATE}" \
    "${ADOPTION_ACTOR}" \
    "${PROFILE_LIST}" \
    "${PROJECT_PACK}" \
    "${PROJECT_CLASS_LABEL}" <<'PY'
import sys
from pathlib import Path

path = Path(sys.argv[1])
project_path = Path(sys.argv[2])
source, tag, commit, adopted_on, actor, profiles_csv, project_pack, project_class_label = sys.argv[3:]
profiles = [] if profiles_csv == "none" else profiles_csv.split(",")
text = path.read_text(encoding="utf-8")
replacements = {
    "| Source | TODO URL ou chemin d'origine |": f"| Source | `{source}` |",
    "| Version lisible | TODO tag |": f"| Version lisible | `{tag}` |",
    "| Commit immuable | TODO SHA complet |": f"| Commit immuable | `{commit}` |",
    "| Pack adopté | TODO minimal, standard, full ou critical |": (
        f"| Pack adopté | `{project_pack}` |"
    ),
    "| Adoptée le | TODO YYYY-MM-DD |": f"| Adoptée le | {adopted_on} |",
    "| Adoptée par | TODO |": f"| Adoptée par | {actor} |",
    "## Profils activés\n\n- TODO": (
        "## Profils activés\n\n- aucun" if not profiles else "## Profils activés\n\n" + "\n".join(f"- `{profile}`" for profile in profiles)
    ),
}
for old, new in replacements.items():
    if old not in text:
        raise SystemExit(f"marqueur FOUNDATION absent : {old!r}")
    text = text.replace(old, new, 1)
path.write_text(text, encoding="utf-8")

if project_path.is_file():
    project_text = project_path.read_text(encoding="utf-8")
    marker = "| Classe | TODO exploration, prototype, produit ou critique |"
    if marker not in project_text:
        raise SystemExit(f"marqueur PROJECT absent : {marker!r}")
    project_text = project_text.replace(
        marker,
        f"| Classe | {project_class_label} |",
        1,
    )
    project_path.write_text(project_text, encoding="utf-8")
PY
else
  echo "Avertissement : aucun commit du socle n'est disponible ; remplir manuellement la version dans FOUNDATION.md." >&2
fi

python3 "${STAGING}/scripts/documentation_catalog.py" --write >/dev/null

[[ ! -e "${TARGET}" && ! -L "${TARGET}" ]] || fail "la cible est apparue pendant le bootstrap ; publication annulée."
mv "${STAGING}" "${TARGET}"
STAGING=""
trap - EXIT INT TERM

echo "Bootstrap créé sans initialiser Git : ${TARGET}"
echo "Remplir les marqueurs de saisie, initialiser Git, puis lancer ./scripts/verify.sh."
