#!/usr/bin/env bash
# FILE: run-suite.sh
# DESCRIPTION: Apply + destroy one Floci OpenTofu suite against a running emulator.
# VERSION: 0.2.0
set -euo pipefail

SUITE="${1:-}"
if [[ -z "${SUITE}" ]]; then
  echo "usage: $0 <suite-name>" >&2
  exit 1
fi

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SUITE_DIR="${ROOT}/suites/${SUITE}"
SHARED_DIR="${ROOT}/_shared"
FLOCI_ENDPOINT="${FLOCI_ENDPOINT:-http://localhost:4566}"
TOFU_BIN="${TOFU_BIN:-tofu}"

if [[ ! -d "${SUITE_DIR}" ]]; then
  echo "ERROR: suite not found: ${SUITE_DIR}" >&2
  exit 1
fi

command -v "${TOFU_BIN}" >/dev/null || { echo "ERROR: ${TOFU_BIN} not on PATH" >&2; exit 1; }

# Link shared provider/versions into the suite dir so module sources stay relative.
ln -sfn "${SHARED_DIR}/provider.tf" "${SUITE_DIR}/provider.tf"
ln -sfn "${SHARED_DIR}/versions.tf" "${SUITE_DIR}/versions.tf"

cleanup() {
  rm -f "${SUITE_DIR}/provider.tf" "${SUITE_DIR}/versions.tf"
  rm -rf "${SUITE_DIR}/.terraform" "${SUITE_DIR}/.terraform.lock.hcl" "${SUITE_DIR}/terraform.tfstate" "${SUITE_DIR}/terraform.tfstate.backup" 2>/dev/null || true
}
trap cleanup EXIT

echo "::group::floci suite=${SUITE} endpoint=${FLOCI_ENDPOINT}"
(
  cd "${SUITE_DIR}"
  export AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID:-test}"
  export AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY:-test}"
  export AWS_DEFAULT_REGION="${AWS_DEFAULT_REGION:-us-east-1}"
  export AWS_REGION="${AWS_REGION:-us-east-1}"
  export AWS_ENDPOINT_URL="${FLOCI_ENDPOINT}"

  "${TOFU_BIN}" init -backend=false -input=false
  "${TOFU_BIN}" validate
  "${TOFU_BIN}" apply -auto-approve -input=false \
    -var="floci_endpoint=${FLOCI_ENDPOINT}"
  "${TOFU_BIN}" destroy -auto-approve -input=false \
    -var="floci_endpoint=${FLOCI_ENDPOINT}"
)
echo "::endgroup::"
echo "OK: suite ${SUITE} apply/destroy against Floci succeeded"
