# teleport-alpine-builder

Builds and publishes a statically linked Teleport binary for Alpine Linux hosts.

## What it publishes

Running the GitHub Actions workflow creates two release assets under a tag such as `teleport-v18.7.0`:

- `teleport-v18.7.0-linux-amd64-musl`
- `teleport-v18.7.0-linux-amd64-musl.sha256`

The asset naming matches the expectations in the Ansible `setup-teleport` role.

## Automatic upstream release detection

The workflow runs every 24 hours at midnight UTC and checks `gravitational/teleport` for the latest stable GitHub release.
If this repository does not already have a matching `teleport-<tag>` release, it builds and publishes a new static binary automatically.

## Usage

You can still trigger the workflow manually from GitHub Actions:

```bash
gh workflow run build-teleport-alpine.yaml -f teleport_tag=v18.7.0
```

If you omit `teleport_tag` in the manual run, the workflow auto-selects the latest stable upstream Teleport release.

The workflow:

1. resolves the requested tag (manual input or latest stable upstream release)
2. checks whether this repository already has a corresponding release tag
3. clones the upstream `gravitational/teleport` repository at the requested tag
4. builds `build/teleport` with static linker flags
5. uploads the binary and checksum as workflow artifacts
6. publishes the same files as GitHub release assets

## Local build

You can reproduce the release artifact locally:

```bash
./scripts/build-teleport-binary.sh v18.7.0
```
