#!/bin/bash
# =============================================================================
# generate-filc-profiles.sh
# Generates Fil-C profiles with elibc_glibc / elibc_musl USE flag awareness
# =============================================================================

set -euo pipefail

OVERLAY_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROFILES_DIR="${OVERLAY_ROOT}/profiles/filc/17.1"

echo "=== Generating Fil-C profiles with elibc_* USE flags ==="

# Create directory structure
mkdir -p "${PROFILES_DIR}"/{merged-usr,split-usr}/cxx20/{glibc,musl}/{unstrict,strict,hardcore}

create_profile() {
    local usr_type="$1"   # merged-usr or split-usr
    local libc="$2"       # glibc or musl
    local level="$3"      # unstrict, strict, hardcore

    local dir="${PROFILES_DIR}/${usr_type}/cxx20/${libc}/${level}"
    mkdir -p "$dir"

    # parent file
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

    # make.defaults - set the correct elibc_* flag + hardening
    cat > "$dir/make.defaults" << EOF
# Fil-C ${level} profile: ${usr_type} / cxx20 / ${libc}
CC="/opt/fil/bin/filcc"
CXX="/opt/fil/bin/fil++"

CXXFLAGS="\${CXXFLAGS} -std=c++20"

# Hardening enabled across the overlay
CFLAGS="\${CFLAGS} -fPIC -fstack-protector-strong"
CXXFLAGS="\${CXXFLAGS} -fPIC -fstack-protector-strong"

# Set the correct elibc flag for this profile
USE="\${USE} elibc_${libc}"
EOF

    # package.mask
    if [[ "$level" == "hardcore" ]]; then
        cat > "$dir/package.mask" << EOF
# Hardcore profile - extreme security
# Mask high-risk non-C/C++ languages
dev-lang/rust
virtual/rust
dev-lang/go
dev-go/*

# Non-essential Python/Perl (keep minimal for Portage/kernel/crypto)
# dev-python/*
# dev-perl/*
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

    echo "✓ Created ${usr_type}/cxx20/${libc}/${level}"
}

# Generate all combinations
echo "Generating all profile combinations..."

for usr in merged-usr split-usr; do
    for libc in glibc musl; do
        create_profile "$usr" "$libc" "unstrict"
        create_profile "$usr" "$libc" "strict"
        create_profile "$usr" "$libc" "hardcore"
    done
done

# Repository metadata
mkdir -p "${OVERLAY_ROOT}/profiles"
echo "filc" > "${OVERLAY_ROOT}/profiles/repo_name"

mkdir -p "${OVERLAY_ROOT}/metadata"
cat > "${OVERLAY_ROOT}/metadata/layout.conf" << EOF
masters = gentoo
auto-sync = false
EOF

echo ""
echo "=== Profile generation completed successfully! ==="
echo "Default profile : filc:17.1/merged-usr/cxx20/glibc/unstrict"
echo ""
echo "To activate the default:"
echo "    eselect profile set filc:17.1/merged-usr/cxx20/glibc/unstrict"
echo ""
echo "Musl profiles and hardcore mode are also available."
