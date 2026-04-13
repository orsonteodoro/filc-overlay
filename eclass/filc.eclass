# Copyright 2026 Orson Teodoro
# Distributed under the terms of the GNU General Public License v2

inherit multilib toolchain-funcs

# Path helpers
filc_get_version() { echo "${PV}"; }
filc_get_libdir()  { echo "/usr/lib/fil-c/$(filc_get_version)"; }
filc_get_yolo_libdir() { echo "/usr/lib/yolo/$(filc_get_version)"; }
filc_get_bindir()  { echo "$(filc_get_libdir)/bin"; }

# Slotting
if [[ "${PV}" == "9999" ]]; then
    SLOT="live"
else
    SLOT="${PV%.*}"
fi

# Use standard Gentoo elibc_* flags
IUSE="elibc_glibc elibc_musl"
REQUIRED_USE="^^ ( elibc_glibc elibc_musl )"

DEPEND="app-eselect/eselect-filc"
RDEPEND="${DEPEND}"
BDEPEND="${DEPEND}"

# Default to glibc if neither flag is explicitly disabled
pkg_setup() {
    if ! use elibc_glibc && ! use elibc_musl; then
        einfo "No elibc_* flag selected, defaulting to glibc"
    fi
}

# Create LLVM-style symlinks for compatibility
filc_create_symlinks() {
    local bindir=$(filc_get_bindir)
    local chost=$(tc-getCC)

    dodir /usr/bin

    dosym "${bindir}/filcc" /usr/bin/filcc
    dosym "${bindir}/fil++" /usr/bin/fil++

    dosym "${bindir}/filcc" /usr/bin/filcc-${PV}
    dosym "${bindir}/fil++" /usr/bin/fil++-${PV}

    dosym "${bindir}/filcc" /usr/bin/${chost}-filcc
    dosym "${bindir}/fil++" /usr/bin/${chost}-fil++

    dosym "${bindir}/filcc" /usr/bin/${chost}-filcc-${PV}
    dosym "${bindir}/fil++" /usr/bin/${chost}-fil++-${PV}

    einfo "Created LLVM-style symlinks for Fil-C ${PV}"
}

# Safe cleanup respecting parallel versions
filc_pkg_prerm() {
    if [[ -z "${REPLACED_BY_VERSION}" ]]; then
        rm -f "${ROOT}"/usr/bin/filcc "${ROOT}"/usr/bin/fil++ 2>/dev/null || true
        rm -f "${ROOT}"/usr/bin/filcc-* "${ROOT}"/usr/bin/*filcc-* 2>/dev/null || true
        rm -f "${ROOT}"/usr/bin/fil++-* "${ROOT}"/usr/bin/*fil++-* 2>/dev/null || true
        einfo "Cleaned up Fil-C symlinks for version ${PV}"
    else
        einfo "Preserving symlinks (replaced by version ${REPLACED_BY_VERSION})"
    fi
}

EXPORT_FUNCTIONS pkg_prerm
