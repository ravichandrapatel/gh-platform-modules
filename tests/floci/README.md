# Floci module tests

Integration tests that `tofu apply` / `tofu destroy` selected modules against
[Floci](https://github.com/floci-io/floci) (local AWS emulator on `:4566`).

## Suites (v1)

| Suite | Module |
| --- | --- |
| `s3` | `s3/` |
| `sns-topic` | `sns-topic/` |
| `secrets-manager` | `secrets-manager/` |
| `cloudwatch-logs` | `cloudwatch-logs/` |
| `ecr` | `ecr/` |

VPC/ALB/RDS/Orgs modules are out of scope until Floci coverage is proven for them.

## Local

```bash
docker compose -f tests/floci/compose.yaml up -d
# wait until http://localhost:4566/_localstack/health is ready

export PATH="$HOME/.local/bin:$PATH"   # if needed
./tests/floci/scripts/run-suite.sh s3
```

## CI

`.github/workflows/floci-test.yml` starts Floci and runs the matrix on PRs that
touch `tests/floci/**` or the covered modules.
