# Floci testing

Module integration tests use [Floci](https://floci.io/) as a local AWS emulator
(`http://localhost:4566`) so OpenTofu can `apply` / `destroy` without a real account.

## Layout

- Harness: [`tests/floci/`](../tests/floci/)
- CI: [`.github/workflows/floci-test.yml`](../.github/workflows/floci-test.yml)
- Emulator image: `floci/floci:1.5.34` (digest-pinned)

## Adding a suite

1. Create `tests/floci/suites/<name>/main.tf` calling `../../../../<module>`.
2. Add `<name>` to the matrix in `floci-test.yml`.
3. Add module path filters under `on.pull_request.paths`.

Prefer modules with solid Floci service coverage (S3, SNS, Secrets Manager, Logs, ECR, …).
