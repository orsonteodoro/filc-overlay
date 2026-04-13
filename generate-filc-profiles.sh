#!/bin/bash
# =============================================================================
# generate-filc-profiles.sh - Full Fil-C profile generator (unstrict/strict/hardcore)
# =============================================================================

set -euo pipefail

OVERLAY_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROFILES_DIR="${OVERLAY_ROOT}/profiles/filc/17.1"

echo "=== Generating Fil-C profiles (unstrict / strict / hardcore) ==="

# Base directories
mkdir -p "${PROFILES_DIR}"/{merged-usr,split-usr}/cxx20/{glibc,musl}/{unstrict,strict,hardcore}

create_profile() {
    local usr_type="$1"
    local libc="$2"
    local level="$3"

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

    # make.defaults - hardening always enabled
    cat > "$dir/make.defaults" << EOF
# Fil-C ${level} profile: ${usr_type} / cxx20 / ${libc}
CC="/opt/fil/bin/filcc"
CXX="/opt/fil/bin/fil++"

CXXFLAGS="\${CXXFLAGS} -std=c++20"

# Hardening enabled across all profiles
CFLAGS="\${CFLAGS} -fPIC -fstack-protector-strong"
CXXFLAGS="\${CXXFLAGS} -fPIC -fstack-protector-strong"
EOF

    # package.mask
    if [[ "$level" == "hardcore" ]]; then
        cat > "$dir/package.mask" << EOF
# Hardcore profile - extreme security + adventurous setup
# High-risk languages
dev-lang/rust
virtual/rust
dev-lang/go
dev-go/*

# Non-essential Python/Perl
dev-python/* 
dev-perl/*
# Keep minimal Python/Perl for Portage, kernel, crypto, browsers
# (full ban would break system)
EOF
    elif [[ "$level" == "strict" ]]; then
        cat > "$dir/package.mask" << EOF
# Strict profile - C/C++ focused
dev-lang/rust
virtual/rust
dev-lang/go
dev-go/*
EOF
    else
        cat > "$dir/package.mask" << EOF
# unstrict profile - maximum compatibility
EOF
    fi

    echo "✓ ${usr_type}/cxx20/${libc}/${level}"
}

# Generate all combinations
echo "Generating profiles..."

for usr in merged-usr split-usr; do
    for libc in glibc musl; do
        create_profile "$usr" "$libc" "unstrict"
        create_profile "$usr" "$libc" "strict"
        create_profile "$usr" "$libc" "hardcore"
    done
done

# Metadata
mkdir -p "${OVERLAY_ROOT}/profiles"
echo "filc" > "${OVERLAY_ROOT}/profiles/repo_name"

mkdir -p "${OVERLAY_ROOT}/metadata"
cat > "${OVERLAY_ROOT}/metadata/layout.conf" << EOF
masters = gentoo
auto-sync = false
EOF

echo ""
echo "=== Generation completed! ==="
echo "Default profile: filc:17.1/merged-usr/cxx20/glibc/unstrict"
echo "Hardcore profile example: filc:17.1/merged-usr/cxx20/glibc/hardcore"
echo ""
echo "To activate default:"
echo "    eselect profile set filc:17.1/merged-usr/cxx20/glibc/unstrict"
