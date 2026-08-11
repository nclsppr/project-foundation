#!/usr/bin/env bash
set -euo pipefail

if (( BASH_VERSINFO[0] < 3 || (BASH_VERSINFO[0] == 3 && BASH_VERSINFO[1] < 2) )); then
  echo "Bash >= 3.2 is required." >&2
  exit 1
fi

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
PROJECT_ROOT="$(cd -- "${SCRIPT_DIR}/.." && pwd -P)"

git_root="$(git -C "${PROJECT_ROOT}" rev-parse --show-toplevel 2>/dev/null)" || {
  echo "The project must be a Git repository before hook installation." >&2
  exit 1
}
git_root="$(cd -- "${git_root}" && pwd -P)"
if [[ "${git_root}" != "${PROJECT_ROOT}" ]]; then
  echo "The project must be its Git repository root: ${PROJECT_ROOT}" >&2
  echo "Detected Git root: ${git_root}" >&2
  exit 1
fi

configured="$(git -C "${PROJECT_ROOT}" config --local --get core.hooksPath || true)"
if [[ -n "${configured}" && "${configured}" != ".githooks" ]]; then
  echo "A different core.hooksPath is already configured: ${configured}" >&2
  echo "Move or chain the existing hooks before you activate .githooks." >&2
  exit 1
fi

default_hook="$(git -C "${PROJECT_ROOT}" rev-parse --git-path hooks/pre-commit)"
case "${default_hook}" in
  /*) ;;
  *) default_hook="${PROJECT_ROOT}/${default_hook}" ;;
esac
if [[ -z "${configured}" && -f "${default_hook}" && "${default_hook}" != *.sample ]]; then
  echo "An existing pre-commit hook would be bypassed: ${default_hook}" >&2
  echo "Move its command to .githooks/pre-commit.local, then run this installer again." >&2
  exit 1
fi

chmod +x "${PROJECT_ROOT}/.githooks/pre-commit"
git -C "${PROJECT_ROOT}" config --local core.hooksPath .githooks
python3 "${PROJECT_ROOT}/scripts/foundation_sync.py" hook-status

echo "Foundation pre-commit verification is installed."
