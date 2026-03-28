# teleport-alpine-builder

Builds and publishes a statically linked Teleport binary for Alpine Linux hosts.

## What it publishes

Running the GitHub Actions workflow creates two release assets under a tag such as `teleport-v18.7.0`:

- `teleport-v18.7.0-linux-amd64-musl`
- `teleport-v18.7.0-linux-amd64-musl.sha256`

The asset naming matches the expectations in the Ansible `setup-teleport` role.

## Usage

Trigger the workflow from GitHub Actions:

```bash
gh workflow run build-teleport-alpine.yaml -f teleport_tag=v18.7.0
```

The workflow:

1. clones the upstream `gravitational/teleport` repository at the requested tag
2. builds `build/teleport` with static linker flags
3. uploads the binary and checksum as workflow artifacts
4. publishes the same files as GitHub release assets

## Local build

You can reproduce the release artifact locally:

```bash
./scripts/build-teleport-binary.sh v18.7.0
```
