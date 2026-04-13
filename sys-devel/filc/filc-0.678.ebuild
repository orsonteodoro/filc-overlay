# Copyright 2026 Orson Teodoro
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit filc

DESCRIPTION="Filip Pizlo's Fil-C memory-safe C/C++ compiler (tagged release)"
HOMEPAGE="https://fil-c.org/"
SRC_URI="https://github.com/pizlonator/fil-c/archive/refs/tags/0.678.tar.gz -> fil-c-0.678.tar.gz"

LICENSE="Apache-2 BSD-2 LGPL-2.1+ MIT"
SLOT="0.678"
KEYWORDS="~amd64"
RESTRICT="sandbox"

IUSE="glibc musl"
REQUIRED_USE="^^ ( glibc musl )"

DEPEND="
    dev-libs/libxml2
    net-misc/curl
    sys-devel/clang
    sys-devel/llvm
    dev-util/cmake
    dev-util/ninja
    sys-devel/gcc
    app-eselect/eselect-filc
"

RDEPEND="${DEPEND}"
BDEPEND="${DEPEND}"

S="${WORKDIR}/fil-c-0.678"

src_configure() {
    einfo "Fil-C 0.678 source ready at ${S}"
    einfo "Building with $(usex glibc 'glibc' 'musl') backend"
}

src_compile() {
    einfo "Building Fil-C 0.678..."

    cd "${S}" || die

    if use glibc; then
        if [[ -x "./build_all_fast_glibc.sh" ]]; then
            ./build_all_fast_glibc.sh || die
        else
            die "build_all_fast_glibc.sh not found"
        fi
    elif use musl; then
        if [[ -x "./build_all_fast_musl.sh" ]]; then
            ./build_all_fast_musl.sh || die
        else
            die "build_all_fast_musl.sh not found"
        fi
    fi
}

src_install() {
    filc_src_install
    filc_create_symlinks
}

pkg_prerm() {
    filc_pkg_prerm
}

pkg_postinst() {
    elog "Fil-C version 0.678 installed to $(filc_get_libdir)"
    elog ""
    elog "To activate this version:"
    elog "    eselect filc set 0.678"
}
