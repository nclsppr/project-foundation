#!/usr/bin/env bash
set -euo pipefail

if (( BASH_VERSINFO[0] < 3 || (BASH_VERSINFO[0] == 3 && BASH_VERSINFO[1] < 2) )); then
  echo "Bash >= 3.2 is required." >&2
  exit 1
fi

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
PROJECT_ROOT="$(cd -- "${SCRIPT_DIR}/.." && pwd -P)"

command -v git >/dev/null 2>&1 || {
  echo "Git is required to verify the project." >&2
  exit 1
}

command -v python3 >/dev/null 2>&1 || {
  echo "Python >= 3.9 is required to verify the project." >&2
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
  echo "The project must be a Git repository before verification." >&2
  exit 1
}
git_root="$(cd -- "${git_root}" && pwd -P)"
if [[ "${git_root}" != "${PROJECT_ROOT}" ]]; then
  echo "The project must be its Git repository root: ${PROJECT_ROOT}" >&2
  exit 1
fi

if [[ "${CI:-}" == "true" ]]; then
  python3 "${SCRIPT_DIR}/foundation_sync.py" check
else
  python3 "${SCRIPT_DIR}/foundation_sync.py" hook-status
  python3 "${SCRIPT_DIR}/foundation_sync.py" enforce
fi

python3 "${SCRIPT_DIR}/documentation_catalog.py" --check
python3 "${SCRIPT_DIR}/check_markdown.py"
python3 "${SCRIPT_DIR}/check_compose.py"
npm ci --prefix "${PROJECT_ROOT}/docs-nimbus" --ignore-scripts --no-audit --no-fund
npm run check --prefix "${PROJECT_ROOT}/docs-nimbus"
if [[ -n "$(git -C "${PROJECT_ROOT}" ls-files -- docs-nimbus/src/content/docs)" ]]; then
  echo "Git must not track the generated Nimbus collection." >&2
  exit 1
fi
git -C "${PROJECT_ROOT}" diff --check
git -C "${PROJECT_ROOT}" diff --cached --check

echo "Baseline verification complete. Add project-specific gates here."
