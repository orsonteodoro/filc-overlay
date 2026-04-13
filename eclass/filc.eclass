# Copyright 2026 Orson Teodoro
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: filc.eclass
# @MAINTAINER: Orson Teodoro <orsonteodoro@gmail.com>
# @SUPPORTED_EAPIS: 8
# @DESCRIPTION:
# Common functions for Fil-C ebuilds. Provides consistent multi-slot paths.

inherit multilib

# =============================================================================
# Path Helpers (Easy for Gentoo users)
# =============================================================================

# @FUNCTION: filc_get_version
filc_get_version() {
    echo "${PV}"
}

# @FUNCTION: filc_get_libdir
# Returns base path for Fil-C toolchain
filc_get_libdir() {
    echo "/usr/lib/fil-c/$(filc_get_version)"
}

# @FUNCTION: filc_get_yolo_libdir
# Returns base path for Yolo glibc layer
filc_get_yolo_libdir() {
    echo "/usr/lib/yolo/$(filc_get_version)"
}

# @FUNCTION: filc_get_bindir
filc_get_bindir() {
    echo "$(filc_get_libdir)/bin"
}

# =============================================================================
# Slotting (Simple and intuitive)
# =============================================================================

if [[ "${PV}" == "9999" ]]; then
    SLOT="live"
else
    SLOT="${PV%.*}"          # e.g. 0.678 → SLOT="0.678"
fi

# =============================================================================
# Common Dependencies
# =============================================================================

DEPEND="
    dev-libs/libxml2
    net-misc/curl
    sys-devel/clang
    sys-devel/llvm
    dev-util/cmake
    dev-util/ninja
    sys-devel/gcc
"

RDEPEND="${DEPEND}"
BDEPEND="${DEPEND}"

# =============================================================================
# Default src_install (can be overridden)
# =============================================================================

filc_src_install() {
    local filc_libdir=$(filc_get_libdir)
    local yolo_libdir=$(filc_get_yolo_libdir)
    local bindir=$(filc_get_bindir)

    dodir "${bindir}"
    dodir "${filc_libdir}/lib"
    dodir "${yolo_libdir}"

    einfo "Fil-C ${PV} installed to ${filc_libdir}"
    einfo "Yolo glibc installed to ${yolo_libdir}"
}

EXPORT_FUNCTIONS src_install
