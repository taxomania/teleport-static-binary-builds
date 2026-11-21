#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "usage: $0 <teleport_tag>" >&2
  exit 1
fi

teleport_tag="$1"
release_asset_name="teleport-${teleport_tag}-linux-amd64-musl"

rm -rf dist teleport
mkdir -p dist

git clone https://github.com/gravitational/teleport.git \
  --branch "${teleport_tag}" \
  --depth 1 \
  teleport

cd teleport

rust_version="$(awk '$1 == "channel" && $2 == "=" { gsub(/"/, "", $3); print $3 }' rust-toolchain.toml)"
rustup toolchain install "${rust_version}" --profile minimal
rustup override set "${rust_version}"

CGO_LDFLAGS_ALLOW='-l:librdp_client\.a' \
CARGO_PROFILE_RELEASE_LTO=off \
RUSTFLAGS='-C embed-bitcode=no' \
WEBASSETS_SKIP_BUILD=1 \
BUILDFLAGS="-ldflags '-extldflags=-static' -trimpath" \
make build/teleport

mv build/teleport "../dist/${release_asset_name}"
cd ..

sha256sum "dist/${release_asset_name}" | cut -d ' ' -f 1 \
  > "dist/${release_asset_name}.sha256"
