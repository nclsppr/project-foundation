#!/usr/bin/env bash
set -euo pipefail

if (( BASH_VERSINFO[0] < 3 || (BASH_VERSINFO[0] == 3 && BASH_VERSINFO[1] < 2) )); then
  echo "Bash >= 3.2 est requis." >&2
  exit 1
fi

RELEASE_MODE=0
if [[ $# -gt 1 ]]; then
  echo "Usage : ./scripts/verify.sh [--release]" >&2
  exit 2
fi
if [[ $# -eq 1 ]]; then
  [[ "$1" == "--release" ]] || {
    echo "Usage : ./scripts/verify.sh [--release]" >&2
    exit 2
  }
  RELEASE_MODE=1
fi

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
PROJECT_ROOT="$(cd -- "${SCRIPT_DIR}/.." && pwd -P)"

command -v git >/dev/null 2>&1 || {
  echo "git est requis pour vérifier Project Foundation." >&2
  exit 1
}

command -v python3 >/dev/null 2>&1 || {
  echo "Python >= 3.9 est requis pour vérifier Project Foundation." >&2
  exit 1
}

python3 -c 'import sys; raise SystemExit(0 if sys.version_info >= (3, 9) else 1)' || {
  detected_version="$(python3 -c 'import platform; print(platform.python_version())')"
  echo "Python >= 3.9 est requis (version détectée : ${detected_version})." >&2
  exit 1
}

git_root="$(git -C "${PROJECT_ROOT}" rev-parse --show-toplevel 2>/dev/null)" || {
  echo "Project Foundation doit être un dépôt Git autonome avant vérification." >&2
  exit 1
}

git_root="$(cd -- "${git_root}" && pwd -P)"
if [[ "${git_root}" != "${PROJECT_ROOT}" ]]; then
  echo "Project Foundation doit être la racine du dépôt Git : ${PROJECT_ROOT}" >&2
  echo "Racine Git détectée : ${git_root}" >&2
  exit 1
fi

python3 "${SCRIPT_DIR}/check_markdown.py"
bash "${SCRIPT_DIR}/test_bootstrap.sh"
git -C "${PROJECT_ROOT}" diff --check
git -C "${PROJECT_ROOT}" diff --cached --check

worktree_status="$(git -C "${PROJECT_ROOT}" status --porcelain --untracked-files=all)"
expected_tag="v$(tr -d '[:space:]' < "${PROJECT_ROOT}/VERSION")"

if [[ ${RELEASE_MODE} -eq 1 ]]; then
  [[ -z "${worktree_status}" ]] || {
    echo "Une release exige un worktree propre." >&2
    exit 1
  }
  tag_type="$(git -C "${PROJECT_ROOT}" cat-file -t "refs/tags/${expected_tag}" 2>/dev/null || true)"
  [[ "${tag_type}" == "tag" ]] || {
    echo "Le tag annoté ${expected_tag} est absent." >&2
    exit 1
  }
  tagged_commit="$(git -C "${PROJECT_ROOT}" rev-parse "refs/tags/${expected_tag}^{}" 2>/dev/null || true)"
  head_commit="$(git -C "${PROJECT_ROOT}" rev-parse HEAD)"
  [[ "${tagged_commit}" == "${head_commit}" ]] || {
    echo "Le tag ${expected_tag} ne pointe pas vers HEAD." >&2
    exit 1
  }
  echo "Release ${expected_tag} vérifiée."
elif [[ -z "${worktree_status}" ]]; then
  exact_tag="$(git -C "${PROJECT_ROOT}" describe --tags --exact-match HEAD 2>/dev/null || true)"
  if [[ -n "${exact_tag}" && "${exact_tag}" != "${expected_tag}" ]]; then
    echo "Tag courant ${exact_tag} différent de VERSION (${expected_tag})." >&2
    exit 1
  fi
fi

echo "Vérification terminée."
