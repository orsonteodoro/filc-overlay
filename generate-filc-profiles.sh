#!/bin/bash
# =============================================================================
# generate-filc-profiles.sh - Generate Fil-C Gentoo profiles (glibc primary)
# =============================================================================

set -euo pipefail

OVERLAY_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROFILES_DIR="${OVERLAY_ROOT}/profiles/filc/17.1"

echo "=== Generating Fil-C profiles (glibc primary, musl secondary) ==="

mkdir -p "${PROFILES_DIR}"/{merged-usr,split-usr}/cxx20/{glibc,musl}/{unstrict,strict}

create_profile() {
    local usr_type="$1"      # merged-usr or split-usr
    local libc="$2"          # glibc or musl
    local level="$3"         # unstrict or strict

    local dir="${PROFILES_DIR}/${usr_type}/cxx20/${libc}/${level}"
    mkdir -p "$dir"

    # parent
    if [[ "$libc" == "musl" ]]; then
        cat > "$dir/parent" << EOF
gentoo:default/linux/amd64/17.1/musl
filc:17.1/${usr_type}/cxx20/${libc}/${level}
EOF
    else
        cat > "$dir/parent" << EOF
gentoo:default/linux/amd64/17.1
filc:17.1/${usr_type}/cxx20/${libc}/${level}
EOF
    fi

    # make.defaults
    cat > "$dir/make.defaults" << EOF
# Fil-C ${level} profile: ${usr_type} / cxx20 / ${libc}
CC="/opt/fil/bin/filcc"
CXX="/opt/fil/bin/fil++"

CXXFLAGS="\${CXXFLAGS} -std=c++20"

# Hardening enabled across the overlay (safe with libpizlo.so)
CFLAGS="\${CFLAGS} -fPIC -fstack-protector-strong"
CXXFLAGS="\${CXXFLAGS} -fPIC -fstack-protector-strong"
EOF

    # package.mask
    if [[ "$level" == "strict" ]]; then
        cat > "$dir/package.mask" << EOF
# Strict profile: C/C++ focused (full mitigation)
dev-lang/rust
virtual/rust
dev-lang/go
dev-go/*
EOF
    else
        cat > "$dir/package.mask" << EOF
# unstrict profile: full compatibility (allows Rust, Go, etc.)
EOF
    fi

    echo "✓ ${usr_type}/cxx20/${libc}/${level}"
}

# Generate all combinations
create_profile "merged-usr" "glibc" "unstrict"
create_profile "merged-usr" "glibc" "strict"
create_profile "merged-usr" "musl"   "unstrict"
create_profile "merged-usr" "musl"   "strict"
create_profile "split-usr"  "glibc"  "unstrict"
create_profile "split-usr"  "glibc"  "strict"
create_profile "split-usr"  "musl"   "unstrict"
create_profile "split-usr"  "musl"   "strict"

# repo metadata
mkdir -p "${OVERLAY_ROOT}/profiles"
echo "filc" > "${OVERLAY_ROOT}/profiles/repo_name"

mkdir -p "${OVERLAY_ROOT}/metadata"
cat > "${OVERLAY_ROOT}/metadata/layout.conf" << EOF
masters = gentoo
auto-sync = false
EOF

echo ""
echo "=== Profile generation completed ==="
echo "Default (recommended): filc:17.1/merged-usr/cxx20/glibc/unstrict"
echo "Musl support is included but marked secondary."
echo ""
echo "To activate the default:"
echo "    eselect profile set filc:17.1/merged-usr/cxx20/glibc/unstrict"
