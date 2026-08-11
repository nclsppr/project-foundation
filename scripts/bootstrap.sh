#!/usr/bin/env bash
set -euo pipefail

if (( BASH_VERSINFO[0] < 3 || (BASH_VERSINFO[0] == 3 && BASH_VERSINFO[1] < 2) )); then
  echo "Bash >= 3.2 is required." >&2
  exit 1
fi

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
FOUNDATION_ROOT="$(cd -- "${SCRIPT_DIR}/.." && pwd -P)"
TEMPLATE_ROOT="${FOUNDATION_ROOT}/templates"

usage() {
  cat <<'USAGE'
Usage:
  ./scripts/bootstrap.sh \
    --target /absolute/path/new-project \
    --class exploration|prototype|product|critical \
    --profiles web,backend-data,infrastructure-production,experiment,generated-artifacts,dependency-change|none \
    [--dry-run]

The target path must be absolute. Its parent directory must exist. The target
must not exist. The bootstrap does not replace files, initialize Git, or publish
content. The documentation-nimbus profile is always active. --profiles selects
only additional profiles.
USAGE
}

fail() {
  echo "Error: $*" >&2
  exit 1
}

TARGET_INPUT=""
PROJECT_CLASS=""
PROFILE_CSV=""
DRY_RUN=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --target)
      [[ $# -ge 2 ]] || fail "--target requires a value."
      TARGET_INPUT="$2"
      shift 2
      ;;
    --class)
      [[ $# -ge 2 ]] || fail "--class requires a value."
      PROJECT_CLASS="$2"
      shift 2
      ;;
    --profiles)
      [[ $# -ge 2 ]] || fail "--profiles requires a CSV value or 'none'."
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
      fail "unknown option: $1"
      ;;
  esac
done

[[ -n "${TARGET_INPUT}" ]] || fail "--target is required."
[[ -n "${PROJECT_CLASS}" ]] || fail "--class is required."
[[ -n "${PROFILE_CSV}" ]] || fail "--profiles is required. Use 'none' when necessary."
[[ "${TARGET_INPUT}" = /* ]] || fail "--target must be an absolute path."
[[ "${TARGET_INPUT}" != *$'\n'* ]] || fail "--target cannot contain a line break."

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
    PROJECT_CLASS_LABEL="Product"
    PROJECT_PACK="full"
    ;;
  critical)
    PROJECT_CLASS_LABEL="Critical"
    PROJECT_PACK="critical"
    ;;
  *) fail "invalid class: ${PROJECT_CLASS}" ;;
esac

command -v python3 >/dev/null 2>&1 || fail "Python >= 3.9 is required."
python3 -c 'import sys; raise SystemExit(0 if sys.version_info >= (3, 9) else 1)' || {
  detected_version="$(python3 -c 'import platform; print(platform.python_version())')"
  fail "Python >= 3.9 is required. Detected version: ${detected_version}."
}

TARGET="$(python3 - "${TARGET_INPUT}" <<'PY'
import sys
from pathlib import Path

print(Path(sys.argv[1]).expanduser().resolve(strict=False))
PY
)"

[[ "${TARGET}" != "/" ]] || fail "the system root is a forbidden target."
case "${TARGET}" in
  /Applications|/Library|/System|/Users|/Volumes|/bin|/dev|/etc|/home|/opt|/private|/private/tmp|/proc|/root|/run|/sbin|/srv|/tmp|/usr|/var)
    fail "system target or broad target is forbidden: ${TARGET}"
    ;;
esac

case "${FOUNDATION_ROOT}/" in
  "${TARGET}/"*) fail "the target cannot contain Project Foundation." ;;
esac
case "${TARGET}/" in
  "${FOUNDATION_ROOT}/"*) fail "the target cannot be inside Project Foundation." ;;
esac

[[ ! -e "${TARGET}" && ! -L "${TARGET}" ]] || fail "the target already exists. Overwrite is not allowed: ${TARGET}"
TARGET_PARENT="$(dirname -- "${TARGET}")"
TARGET_NAME="$(basename -- "${TARGET}")"
[[ -d "${TARGET_PARENT}" ]] || fail "the parent directory must already exist: ${TARGET_PARENT}"
[[ "${TARGET_NAME}" != "." && "${TARGET_NAME}" != ".." && -n "${TARGET_NAME}" ]] || fail "invalid target name."

PROFILES=("documentation-nimbus")
if [[ "${PROFILE_CSV}" != "none" ]]; then
  old_ifs="${IFS}"
  IFS=','
  read -r -a requested_profiles <<< "${PROFILE_CSV}"
  IFS="${old_ifs}"
  [[ ${#requested_profiles[@]} -gt 0 ]] || fail "the profile list is empty."

  for raw_profile in "${requested_profiles[@]}"; do
    profile="$(printf '%s' "${raw_profile}" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
    case "${profile}" in
      web|backend-data|infrastructure-production|experiment|generated-artifacts|dependency-change|documentation-nimbus) ;;
      "") fail "--profiles contains an empty profile." ;;
      *) fail "unknown profile: ${profile}" ;;
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

add_nimbus_scaffold() {
  while IFS= read -r -d '' source; do
    relative="${source#${FOUNDATION_ROOT}/}"
    case "${relative}" in
      docs-nimbus/node_modules/*|docs-nimbus/dist/*|docs-nimbus/.astro/*|docs-nimbus/.nimbus/*|docs-nimbus/.wrangler/*|docs-nimbus/src/content/docs/*) continue ;;
      docs-nimbus/.env|docs-nimbus/.env.local|docs-nimbus/.env.*.local|docs-nimbus/.env.production|docs-nimbus/.dev.vars|docs-nimbus/.dev.vars.*) continue ;;
      docs-nimbus/npm-debug.log*|docs-nimbus/yarn-debug.log*|docs-nimbus/yarn-error.log*|docs-nimbus/pnpm-debug.log*) continue ;;
    esac
    add_copy "${source}" "${relative}"
  done < <(find "${FOUNDATION_ROOT}/docs-nimbus" -type f -print0)
}

add_copy "${TEMPLATE_ROOT}/FOUNDATION.md" "FOUNDATION.md"
add_copy "${TEMPLATE_ROOT}/CHANGELOG.md" "CHANGELOG.md"
add_copy "${TEMPLATE_ROOT}/DOCUMENTATION.md" "DOCUMENTATION.md"
add_copy "${TEMPLATE_ROOT}/documentation.json" "documentation.json"
add_copy "${TEMPLATE_ROOT}/compose.yaml" "compose.yaml"
add_copy "${TEMPLATE_ROOT}/.github/workflows/verify.yml" ".github/workflows/verify.yml"
add_copy "${TEMPLATE_ROOT}/.github/workflows/foundation-sync.yml" ".github/workflows/foundation-sync.yml"
add_copy "${TEMPLATE_ROOT}/.githooks/pre-commit" ".githooks/pre-commit"
add_copy "${TEMPLATE_ROOT}/scripts/install_foundation_hook.sh" "scripts/install_foundation_hook.sh"
add_copy "${FOUNDATION_ROOT}/scripts/foundation_sync.py" "scripts/foundation_sync.py"
add_nimbus_scaffold

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
  [[ ${has_critical_profile} -eq 1 ]] || fail "a critical project must select backend-data or infrastructure-production."
fi

add_copy "${TEMPLATE_ROOT}/scripts/check_markdown.py" "scripts/check_markdown.py"
add_copy "${FOUNDATION_ROOT}/scripts/check_compose.py" "scripts/check_compose.py"
add_copy "${TEMPLATE_ROOT}/scripts/verify.sh" "scripts/verify.sh"
add_copy "${FOUNDATION_ROOT}/scripts/documentation_catalog.py" "scripts/documentation_catalog.py"

for source in "${SOURCES[@]}"; do
  [[ -f "${source}" ]] || fail "bootstrap source is missing: ${source#${FOUNDATION_ROOT}/}"
done

OFFICIAL_FOUNDATION_SOURCE="https://github.com/nclsppr/project-foundation.git"
FOUNDATION_SOURCE="${PROJECT_FOUNDATION_TRUSTED_SOURCE:-${OFFICIAL_FOUNDATION_SOURCE}}"
FOUNDATION_SOURCE="$("${SCRIPT_DIR}/sanitize_git_remote.py" "${FOUNDATION_SOURCE}")" || fail "cannot safely insert the Foundation source into FOUNDATION.md."
FOUNDATION_COMMIT=""
FOUNDATION_TAG="unreleased"
FOUNDATION_DIRTY=0
FOUNDATION_GIT_ROOT=""
detected_git_root="$(git -C "${FOUNDATION_ROOT}" rev-parse --show-toplevel 2>/dev/null || true)"
if [[ -n "${detected_git_root}" ]]; then
  FOUNDATION_GIT_ROOT="$(cd -- "${detected_git_root}" && pwd -P)"
fi
if [[ "${FOUNDATION_GIT_ROOT}" == "${FOUNDATION_ROOT}" ]]; then
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

echo "Bootstrap ${PROJECT_CLASS} to ${TARGET}"
if [[ ${#PROFILES[@]} -eq 0 ]]; then
  echo "Profiles: none"
else
  echo "Profiles: $(IFS=,; echo "${PROFILES[*]}")"
fi

if [[ ${DRY_RUN} -eq 1 ]]; then
  echo "Dry-run mode: no writes."
  for index in "${!SOURCES[@]}"; do
    echo "COPY ${SOURCES[${index}]#${FOUNDATION_ROOT}/} -> ${TARGET}/${DESTINATIONS[${index}]}"
  done
  echo "GENERATE foundation.lock.json"
  echo "MKDIR ${TARGET}/docs/decisions"
  if [[ -z "${FOUNDATION_COMMIT}" ]]; then
    echo "WARNING: no Foundation commit is available. Version fields will remain incomplete."
  else
    echo "FOUNDATION source=${FOUNDATION_SOURCE} tag=${FOUNDATION_TAG} commit=${FOUNDATION_COMMIT} profiles=${PROFILE_LIST}"
  fi
  if [[ ${FOUNDATION_DIRTY} -eq 1 ]]; then
    echo "WARNING: the Foundation worktree is dirty. A real bootstrap would fail."
  fi
  if [[ -n "${FOUNDATION_GIT_ROOT}" && "${FOUNDATION_GIT_ROOT}" != "${FOUNDATION_ROOT}" ]]; then
    echo "WARNING: Project Foundation is not the Git root. A real bootstrap would fail."
  fi
  exit 0
fi

[[ "${FOUNDATION_GIT_ROOT}" == "${FOUNDATION_ROOT}" ]] || fail "Project Foundation must be its own Git repository root."
[[ -n "${FOUNDATION_COMMIT}" ]] || fail "the Foundation must have a commit before a real bootstrap."
[[ "${FOUNDATION_TAG}" != "unreleased" ]] || fail "bootstrap requires an exact stable Foundation release tag."
if [[ ${FOUNDATION_DIRTY} -eq 1 ]]; then
  fail "the Foundation worktree is dirty. Commit or remove changes before bootstrap."
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
  "${STAGING}/.githooks/pre-commit" \
  "${STAGING}/scripts/check_markdown.py" \
  "${STAGING}/scripts/check_compose.py" \
  "${STAGING}/scripts/documentation_catalog.py" \
  "${STAGING}/scripts/foundation_sync.py" \
  "${STAGING}/scripts/install_foundation_hook.sh" \
  "${STAGING}/scripts/verify.sh"

if [[ -n "${FOUNDATION_COMMIT}" ]]; then
  python3 - \
    "${STAGING}/FOUNDATION.md" \
    "${STAGING}/PROJECT.md" \
    "${STAGING}/compose.yaml" \
    "${TARGET_NAME}" \
    "${FOUNDATION_SOURCE}" \
    "${FOUNDATION_TAG}" \
    "${FOUNDATION_COMMIT}" \
    "${ADOPTION_DATE}" \
    "${ADOPTION_ACTOR}" \
    "${PROFILE_LIST}" \
    "${PROJECT_PACK}" \
    "${PROJECT_CLASS_LABEL}" <<'PY'
import re
import sys
from pathlib import Path

path = Path(sys.argv[1])
project_path = Path(sys.argv[2])
compose_path = Path(sys.argv[3])
target_name = sys.argv[4]
source, tag, commit, adopted_on, actor, profiles_csv, project_pack, project_class_label = sys.argv[5:]
profiles = [] if profiles_csv == "none" else profiles_csv.split(",")
text = path.read_text(encoding="utf-8")
replacements = {
    "| Source | TODO origin URL or path |": f"| Source | `{source}` |",
    "| Readable version | TODO tag |": f"| Readable version | `{tag}` |",
    "| Immutable commit | TODO full SHA |": f"| Immutable commit | `{commit}` |",
    "| Adopted pack | TODO minimal, standard, full, or critical |": (
        f"| Adopted pack | `{project_pack}` |"
    ),
    "| Adopted on | TODO YYYY-MM-DD |": f"| Adopted on | {adopted_on} |",
    "| Adopted by | TODO |": f"| Adopted by | {actor} |",
    "## Activated profiles\n\n- TODO": (
        "## Activated profiles\n\n- none" if not profiles else "## Activated profiles\n\n" + "\n".join(f"- `{profile}`" for profile in profiles)
    ),
}
for old, new in replacements.items():
    if old not in text:
        raise SystemExit(f"missing FOUNDATION marker: {old!r}")
    text = text.replace(old, new, 1)
path.write_text(text, encoding="utf-8")

if project_path.is_file():
    project_text = project_path.read_text(encoding="utf-8")
    marker = "| Class | TODO exploration, prototype, product, or critical |"
    if marker not in project_text:
        raise SystemExit(f"missing PROJECT marker: {marker!r}")
    project_text = project_text.replace(
        marker,
        f"| Class | {project_class_label} |",
        1,
    )
    project_path.write_text(project_text, encoding="utf-8")

compose_text = compose_path.read_text(encoding="utf-8")
compose_marker = "name: foundation-project"
if compose_marker not in compose_text:
    raise SystemExit(f"missing Compose marker: {compose_marker!r}")
compose_name = re.sub(r"[^a-z0-9_-]+", "-", target_name.lower()).strip("-_")
if not compose_name:
    compose_name = "foundation-project"
compose_text = compose_text.replace(
    compose_marker,
    f"name: {compose_name[:63]}",
    1,
)
compose_path.write_text(compose_text, encoding="utf-8")
PY
else
  echo "Warning: no Foundation commit is available. Complete the version in FOUNDATION.md manually." >&2
fi

python3 "${STAGING}/scripts/foundation_sync.py" init-lock \
  --source "${FOUNDATION_SOURCE}" \
  --tag "${FOUNDATION_TAG}" \
  --commit "${FOUNDATION_COMMIT}" \
  --pack "${PROJECT_PACK}" \
  --profiles "${PROFILE_LIST}" \
  --upstream-root "${FOUNDATION_ROOT}"

python3 "${STAGING}/scripts/documentation_catalog.py" --write >/dev/null

[[ ! -e "${TARGET}" && ! -L "${TARGET}" ]] || fail "the target appeared during bootstrap. Publication is canceled."
mv "${STAGING}" "${TARGET}"
STAGING=""
trap - EXIT INT TERM

echo "Bootstrap created without Git initialization: ${TARGET}"
echo "Complete the input markers and initialize Git."
echo "Then run ./scripts/install_foundation_hook.sh and ./scripts/verify.sh."
