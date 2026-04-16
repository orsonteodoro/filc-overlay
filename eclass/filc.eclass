# Copyright 2026 Orson Teodoro
# Distributed under the terms of the GNU General Public License v2

inherit multilib toolchain-funcs

# Simple mono-slot paths for initial adoption
filc_get_libdir()  { echo "/usr/lib/fil-c"; }
filc_get_yolo_libdir() { echo "/usr/lib/yolo"; }
filc_get_bindir()  { echo "/usr/bin"; }

# For initial version we use a single slot
SLOT="0"

IUSE="elibc_glibc elibc_musl"
REQUIRED_USE="^^ ( elibc_glibc elibc_musl )"

DEPEND="dev-lang/ruby sys-kernel/linux-headers"
RDEPEND="${DEPEND}"
BDEPEND="${DEPEND}"

# Simple install (no symlinks management yet)
filc_src_install() {
    local filc_libdir=$(filc_get_libdir)
    local yolo_libdir=$(filc_get_yolo_libdir)

    dodir "${filc_libdir}"
    dodir "${yolo_libdir}"

    einfo "Fil-C installed to ${filc_libdir}"
    einfo "Yolo glibc installed to ${yolo_libdir}"
}

EXPORT_FUNCTIONS src_install
