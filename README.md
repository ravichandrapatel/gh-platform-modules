# gh-platform-modules

**IaC module library** for gh-platform: versioned OpenTofu modules for AWS (and related) resources.

This repo ships **building blocks only** (e.g. `s3/`, `vpc/`). It does not run applies, IssueOps, or CI deploy orchestration — callers compose modules from workload stacks or codegen templates.

## Related repos

| Repo | What it does |
| --- | --- |
| [`gh-platform-actions`](https://github.com/ravichandrapatel/gh-platform-actions) | Reusable `tofu-pipeline` + Conftest policies for callers |
| [`gh-platform-control`](https://github.com/ravichandrapatel/gh-platform-control) | IssueOps control plane (forms, codegen, env registry) |
| Workload repos (`infra-dev` / `infra-prod`) | Own stacks that source these modules by tag |

## Layout

```text
<module-name>/              # OpenTofu modules at repo root (e.g. s3/, vpc/)
  examples/                 # per-module usage examples (not released)
docs/                       # branching, rulesets, release docs
tests/                      # integration harnesses (e.g. Floci)
```

## Module release (SemVer)

Per-module tags and releases are automated by
[techpivot/terraform-module-releaser](https://github.com/techpivot/terraform-module-releaser)
on pull requests to `main`.

See [docs/MODULE_RELEASE.md](docs/MODULE_RELEASE.md) (includes Wiki one-time setup).

Tag format: `{module}/vX.Y.Z` (example: `s3/v1.0.0`).

## Floci testing

Selected modules are integration-tested with OpenTofu against
[Floci](https://floci.io/) (local AWS emulator). See [docs/FLOCI_TESTING.md](docs/FLOCI_TESTING.md)
and [`tests/floci/`](tests/floci/).

## Security branching

See [docs/BRANCHING.md](docs/BRANCHING.md). Ruleset: [docs/GITHUB_RULESETS.md](docs/GITHUB_RULESETS.md).

## Consume

```hcl
module "s3" {
  source = "git::https://github.com/ravichandrapatel/gh-platform-modules.git//s3?ref=s3/v1.0.0"
}
```
