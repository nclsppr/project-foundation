#!/usr/bin/env bash
set -euo pipefail

if (( BASH_VERSINFO[0] < 3 || (BASH_VERSINFO[0] == 3 && BASH_VERSINFO[1] < 2) )); then
  echo "Bash >= 3.2 is required." >&2
  exit 1
fi

RELEASE_MODE=0
if [[ $# -gt 1 ]]; then
  echo "Usage: ./scripts/verify.sh [--release]" >&2
  exit 2
fi
if [[ $# -eq 1 ]]; then
  [[ "$1" == "--release" ]] || {
    echo "Usage: ./scripts/verify.sh [--release]" >&2
    exit 2
  }
  RELEASE_MODE=1
fi

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
PROJECT_ROOT="$(cd -- "${SCRIPT_DIR}/.." && pwd -P)"

command -v git >/dev/null 2>&1 || {
  echo "Git is required to verify Project Foundation." >&2
  exit 1
}

command -v python3 >/dev/null 2>&1 || {
  echo "Python >= 3.9 is required to verify Project Foundation." >&2
  exit 1
}

command -v node >/dev/null 2>&1 || {
  echo "Node >= 22.12.0 is required to verify Nimbus." >&2
  exit 1
}

command -v npm >/dev/null 2>&1 || {
  echo "npm is required to verify Nimbus." >&2
  exit 1
}

node -e 'const [major, minor] = process.versions.node.split(".").map(Number); process.exit(major > 22 || (major === 22 && minor >= 12) ? 0 : 1)' || {
  echo "Node >= 22.12.0 is required. Detected version: $(node --version)." >&2
  exit 1
}

python3 -c 'import sys; raise SystemExit(0 if sys.version_info >= (3, 9) else 1)' || {
  detected_version="$(python3 -c 'import platform; print(platform.python_version())')"
  echo "Python >= 3.9 is required. Detected version: ${detected_version}." >&2
  exit 1
}

git_root="$(git -C "${PROJECT_ROOT}" rev-parse --show-toplevel 2>/dev/null)" || {
  echo "Project Foundation must be an independent Git repository before verification." >&2
  exit 1
}

git_root="$(cd -- "${git_root}" && pwd -P)"
if [[ "${git_root}" != "${PROJECT_ROOT}" ]]; then
  echo "Project Foundation must be the Git repository root: ${PROJECT_ROOT}" >&2
  echo "Detected Git root: ${git_root}" >&2
  exit 1
fi

python3 "${SCRIPT_DIR}/documentation_catalog.py" --check
python3 "${SCRIPT_DIR}/check_markdown.py"
python3 "${SCRIPT_DIR}/check_compose.py"
python3 "${SCRIPT_DIR}/test_foundation_sync.py"
npm ci --prefix "${PROJECT_ROOT}/docs-nimbus" --ignore-scripts --no-audit --no-fund
npm run check --prefix "${PROJECT_ROOT}/docs-nimbus"
if [[ -n "$(git -C "${PROJECT_ROOT}" ls-files -- docs-nimbus/src/content/docs)" ]]; then
  echo "Git must not track the generated Nimbus collection." >&2
  exit 1
fi
bash "${SCRIPT_DIR}/test_bootstrap.sh"
git -C "${PROJECT_ROOT}" diff --check
git -C "${PROJECT_ROOT}" diff --cached --check

worktree_status="$(git -C "${PROJECT_ROOT}" status --porcelain --untracked-files=all)"
expected_tag="v$(tr -d '[:space:]' < "${PROJECT_ROOT}/VERSION")"

if [[ ${RELEASE_MODE} -eq 1 ]]; then
  [[ -z "${worktree_status}" ]] || {
    echo "A release requires a clean worktree." >&2
    exit 1
  }
  tag_type="$(git -C "${PROJECT_ROOT}" cat-file -t "refs/tags/${expected_tag}" 2>/dev/null || true)"
  [[ "${tag_type}" == "tag" ]] || {
    echo "The annotated tag ${expected_tag} is missing." >&2
    exit 1
  }
  tagged_commit="$(git -C "${PROJECT_ROOT}" rev-parse "refs/tags/${expected_tag}^{}" 2>/dev/null || true)"
  head_commit="$(git -C "${PROJECT_ROOT}" rev-parse HEAD)"
  [[ "${tagged_commit}" == "${head_commit}" ]] || {
    echo "The tag ${expected_tag} does not point to HEAD." >&2
    exit 1
  }
  echo "Release ${expected_tag} verified."
elif [[ -z "${worktree_status}" ]]; then
  exact_tag="$(git -C "${PROJECT_ROOT}" describe --tags --exact-match HEAD 2>/dev/null || true)"
  if [[ -n "${exact_tag}" && "${exact_tag}" != "${expected_tag}" ]]; then
    echo "Current tag ${exact_tag} differs from VERSION (${expected_tag})." >&2
    exit 1
  fi
fi

echo "Verification complete."
