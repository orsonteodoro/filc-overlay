# Copyright 2026 Orson Teodoro
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: filc.eclass
# @MAINTAINER: Orson Teodoro <orsonteodoro@gmail.com>
# @SUPPORTED_EAPIS: 8
# @PROVIDES: filc
# @DESCRIPTION:
# Common functions and defaults for Fil-C ebuilds.
# Provides consistent multi-slot installation paths and helper functions.

inherit multilib

# =============================================================================
# Version and Path Helpers
# =============================================================================

# @FUNCTION: filc_get_version
# @DESCRIPTION:
# Returns the version string used for installation directories
filc_get_version() {
    echo "${PV}"
}

# @FUNCTION: filc_get_libdir
# @DESCRIPTION:
# Returns the base directory for Fil-C toolchain
filc_get_libdir() {
    echo "/usr/lib/fil-c/$(filc_get_version)"
}

# @FUNCTION: filc_get_yolo_libdir
# @DESCRIPTION:
# Returns the base directory for the Yolo glibc layer
filc_get_yolo_libdir() {
    echo "/usr/lib/yolo/$(filc_get_version)"
}

# @FUNCTION: filc_get_bindir
# @DESCRIPTION:
# Returns the bin directory for this Fil-C version
filc_get_bindir() {
    echo "$(filc_get_libdir)/bin"
}

# =============================================================================
# Default Slotting
# =============================================================================

# Use "live" for 9999, otherwise use major.minor (e.g. 0.678)
if [[ "${PV}" == "9999" ]]; then
    SLOT="live"
else
    SLOT="${PV%.*}"
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
# Default src_install stub (can be overridden)
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

# Export the default function so ebuilds can call it with "default"
EXPORT_FUNCTIONS src_install
