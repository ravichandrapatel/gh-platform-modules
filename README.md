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
modules/<name>/     # reusable OpenTofu modules
examples/<name>/    # root modules for CI / local validate
docs/               # branching + GitHub rulesets
```

## Security branching

See [docs/BRANCHING.md](docs/BRANCHING.md). Apply [docs/GITHUB_RULESETS.md](docs/GITHUB_RULESETS.md) after the GitHub remote exists.

## Consume

Pin an annotated tag from a consumer:

```hcl
module "bucket" {
  source = "git::https://github.com/OWNER/gh-platform-modules.git//modules/s3-bucket?ref=v0.1.0"
}
```

Replace `OWNER` with your GitHub org.
