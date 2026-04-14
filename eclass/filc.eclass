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
    SLOT="9999"
else
    SLOT="${PV%.*}"
fi

IUSE="elibc_glibc elibc_musl"
REQUIRED_USE="^^ ( elibc_glibc elibc_musl )"

DEPEND="app-eselect/eselect-filc"
RDEPEND="${DEPEND}"
BDEPEND="${DEPEND}"

# =============================================================================
# Sanity Checks
# =============================================================================

pkg_pretend() {
    # Check if bootstrap has been run (look for key artifacts)
    if [[ ! -x "/opt/fil/bin/filcc" && ! -x "/usr/bin/filcc" ]]; then
        ewarn "===================================================================="
        ewarn "WARNING: Fil-C bootstrap does not appear to have been run yet."
        ewarn "The filc ebuild expects the Fil-C toolchain to be built by the bootstrap."
        ewarn ""
        ewarn "Please run the bootstrap first:"
        ewarn "    cd /path/to/filc-bootstrap"
        ewarn "    ./bootstrap.sh --clean-slate   # or --test-debian"
        ewarn ""
        ewarn "After the bootstrap completes successfully, you can emerge filc."
        ewarn "===================================================================="
    fi

    # Downgrade protection
    if has_version ">${CATEGORY}/${PN}-r1000"
        eerror "Downgrading Fil-C from ${oldver} to ${PV} is not allowed."
        eerror "This would break the yolo-glibc ABI."
        die "Downgrade of Fil-C is not permitted."
    fi
}

pkg_setup() {
    # Mixing glibc/musl check
    if use elibc_glibc && has_version "sys-libs/musl"; then
        eerror "Cannot install glibc-based Fil-C on a musl system."
        die "glibc/musl conflict detected."
    fi

    if use elibc_musl && has_version "sys-libs/glibc"; then
        eerror "Cannot install musl-based Fil-C on a glibc system."
        die "glibc/musl conflict detected."
    fi
}

# Create LLVM-style symlinks
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

# Update ld.so.conf with versioned file
filc_update_ld_so_conf() {
    local yolo_libdir=$(filc_get_yolo_libdir)
    local conf_d="/etc/ld.so.conf.d"
    local conf_file="filc-yolo-${PV}.conf"

    dodir "${conf_d}"

    cat > "${D}${conf_d}/${conf_file}" << EOF
# Fil-C yolo-glibc for version ${PV}
${yolo_libdir}/lib
EOF

    einfo "Added versioned yolo-glibc config: ${conf_file}"
}

# Safe cleanup
filc_pkg_prerm() {
    if [[ -z "${REPLACED_BY_VERSION}" ]]; then
        rm -f "${ROOT}"/usr/bin/filcc "${ROOT}"/usr/bin/fil++ 2>/dev/null || true
        rm -f "${ROOT}"/usr/bin/filcc-* "${ROOT}"/usr/bin/*filcc-* 2>/dev/null || true
        rm -f "${ROOT}"/usr/bin/fil++-* "${ROOT}"/usr/bin/*fil++-* 2>/dev/null || true

        rm -f "${ROOT}/etc/ld.so.conf.d/filc-yolo-${PV}.conf" 2>/dev/null || true

        einfo "Cleaned up Fil-C symlinks and ld.so.conf for version ${PV}"
    fi
}

EXPORT_FUNCTIONS pkg_prerm pkg_pretend pkg_setup
