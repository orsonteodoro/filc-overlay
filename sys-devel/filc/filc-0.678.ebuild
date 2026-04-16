# Copyright 2026 Orson Teodoro
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit filc

DESCRIPTION="Filip Pizlo's Fil-C memory-safe C/C++ compiler (tagged 0.678)"
HOMEPAGE="https://fil-c.org/"
SRC_URI="https://github.com/pizlonator/fil-c/archive/refs/tags/v${PV}.tar.gz -> fil-c-${PV}.tar.gz"

LICENSE="Apache-2.0 BSD-2 LGPL-2.1+ MIT"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="sandbox"

IUSE="elibc_glibc elibc_musl"
REQUIRED_USE="^^ ( elibc_glibc elibc_musl )"

DEPEND="
    dev-libs/libxml2
    net-misc/curl
    sys-devel/clang
    sys-devel/llvm
    dev-util/cmake
    dev-util/ninja
    sys-devel/gcc
    dev-lang/ruby
    sys-kernel/linux-headers
"

RDEPEND="${DEPEND}"
BDEPEND="${DEPEND}"

S="${WORKDIR}/fil-c-0.678"

src_configure() {
    einfo "Fil-C 0.678 source ready at ${S}"
    einfo "Building with $(usex elibc_glibc 'glibc' 'musl') backend"
}

src_compile() {
    einfo "Running Fil-C 0.678 bootstrap (pizlix style)..."

    cd "${S}" || die

    if use elibc_glibc; then
        if [[ -x "./build_all_fast_glibc.sh" ]]; then
            ./build_all_fast_glibc.sh || die "Fil-C glibc bootstrap failed"
        else
            die "build_all_fast_glibc.sh not found"
        fi
    elif use elibc_musl; then
        if [[ -x "./build_all_fast_musl.sh" ]]; then
            ./build_all_fast_musl.sh || die "Fil-C musl bootstrap failed"
        else
            die "build_all_fast_musl.sh not found"
        fi
    fi
}

src_install() {
    filc_src_install
}

pkg_postinst() {
    elog "Fil-C 0.678 has been installed using pizlix paths."
    elog ""
    elog "To use it as your compiler:"
    elog "    export CC=/usr/bin/filcc"
    elog "    export CXX=/usr/bin/fil++"
    elog ""
    elog "Recommended next step:"
    elog "    emerge -e @system"
}
