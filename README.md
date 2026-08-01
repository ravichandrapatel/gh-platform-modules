# gh-platform-modules

OpenTofu / AWS module library for **gh-platform**.

This repo is the **IaC layer**: versioned modules only. It does not orchestrate cloud applies.

## Related repos

| Repo | Role |
| --- | --- |
| `gh-platform-actions` | Commons + deploy actions / reusable workflows |
| `gh-platform-control` | Control plane (dispatch, pins, OIDC, environments) |

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
