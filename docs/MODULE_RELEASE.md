# Module release (techpivot)

`gh-platform-modules` uses [techpivot/terraform-module-releaser](https://github.com/techpivot/terraform-module-releaser) **v2.1.0** (commit-pinned) for per-module SemVer on pull requests to `main`.

## One-time setup

1. Repo **Settings → Features → Wikis** → enable (already on for this repo).
2. Open the **Wiki** tab → **Create the first page** titled `Home` and save.  
   Until that exists, the wiki git remote 404s and the releaser fails if wiki is enabled.  
   Current workflow sets `disable-wiki: true` until Home exists — then flip it to `false`.
3. Ensure branch ruleset on `main` allows GitHub Actions to create tags/releases (`contents: write` via `GITHUB_TOKEN`).

## How it works

1. Open a PR to `main` that changes one or more module directories.
2. The action comments a **Release Plan** (which modules will bump).
3. On PR **merge** (`closed` + merged), it creates:
   - Annotated tags: `{module}/vX.Y.Z` (e.g. `s3/v1.0.0`)
   - GitHub Releases (module-scoped assets)
   - Wiki pages (terraform-docs + changelog), unless disabled

## SemVer (conventional commits)

| Commit | Bump |
| --- | --- |
| `feat:` | minor |
| `fix:` / other conventional types | patch |
| `type!:` or `BREAKING CHANGE` | major |
| First release | `v1.0.0` |

## Consume a module

```hcl
module "s3" {
  source = "git::https://github.com/ravichandrapatel/gh-platform-modules.git//s3?ref=s3/v1.0.0"
}
```

## Ignored paths

`examples/`, `modules/` (legacy scaffold), and `docs/` are excluded from module discovery.

## Related

- Workflow: [`.github/workflows/terraform-module-releaser.yml`](../.github/workflows/terraform-module-releaser.yml)
- Validate CI: [`.github/workflows/validate.yml`](../.github/workflows/validate.yml)
- Branching: [BRANCHING.md](BRANCHING.md)
