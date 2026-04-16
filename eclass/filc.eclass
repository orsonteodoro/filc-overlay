# Copyright 2026 Orson Teodoro
# Distributed under the terms of the GNU General Public License v2

# filc.eclass - Simple mono-slot support for Fil-C bootstrap (Option A)

inherit multilib toolchain-funcs

# Use default pizlix paths produced by the bootstrap
filc_get_filc_bindir() { echo "/usr/bin"; }
filc_get_yolo_libdir() { echo "/usr/lib/yolo"; }
filc_get_yolo_bindir() { echo "/usr/lib/yolo/bin"; }

SLOT="0"

IUSE="elibc_glibc elibc_musl"
REQUIRED_USE="^^ ( elibc_glibc elibc_musl )"

DEPEND="
    dev-lang/ruby
    sys-kernel/linux-headers
"

RDEPEND="${DEPEND}"
BDEPEND="${DEPEND}"

filc_src_install() {
    local filc_bindir=$(filc_get_filc_bindir)
    local yolo_libdir=$(filc_get_yolo_libdir)
    local yolo_bindir=$(filc_get_yolo_bindir)

    # Copy compiler binaries (clang-20, filcc, etc.)
    if [[ -d "/usr/bin" ]]; then
        dodir "${filc_bindir}"
        cp -a /usr/bin/clang-20 "${D}${filc_bindir}/" 2>/dev/null || true
        cp -a /usr/bin/filcc "${D}${filc_bindir}/" 2>/dev/null || true
        cp -a /usr/bin/fil++ "${D}${filc_bindir}/" 2>/dev/null || true
    fi

    # Copy yolo libc and related files
    if [[ -d "/yolo/lib" ]]; then
        dodir "${yolo_libdir}"
        cp -a /yolo/lib/. "${D}${yolo_libdir}/" 2>/dev/null || true
    fi

    # Copy yolo bin (perl, etc.)
    if [[ -d "/yolo/bin" ]]; then
        dodir "${yolo_bindir}"
        cp -a /yolo/bin/. "${D}${yolo_bindir}/" 2>/dev/null || true
    fi

    einfo "Fil-C installed using pizlix paths:"
    einfo "  Compiler binaries → ${filc_bindir}"
    einfo "  Yolo libc        → ${yolo_libdir}"
}

EXPORT_FUNCTIONS src_install
