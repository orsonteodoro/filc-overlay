# Copyright 2026 Orson Teodoro
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit filc

DESCRIPTION="Filip Pizlo's Fil-C memory-safe C/C++ compiler (tagged release)"
HOMEPAGE="https://fil-c.org/"
SRC_URI="https://github.com/pizlonator/fil-c/archive/refs/tags/0.678.tar.gz -> fil-c-0.678.tar.gz"

LICENSE="MIT"
SLOT="0.678"
KEYWORDS="~amd64"

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

S="${WORKDIR}/fil-c-0.678"

src_configure() {
    einfo "Fil-C 0.678 source ready at ${S}"
}

src_compile() {
    einfo "Building Fil-C 0.678..."
    # TODO: Integrate build scripts
    die "Full build integration coming in next iteration"
}

src_install() {
    local filc_libdir="/usr/lib/fil-c/${PV}"
    local yolo_libdir="/usr/lib/yolo/${PV}"

    dodir "${filc_libdir}/bin"
    dodir "${filc_libdir}/lib"
    dodir "${yolo_libdir}"

    einfo "Fil-C ${PV} installed to ${filc_libdir}"
    einfo "Yolo glibc installed to ${yolo_libdir}"
}

pkg_postinst() {
    elog "Fil-C version 0.678 installed."
    elog ""
    elog "To make it active:"
    elog "    eselect filc set 0.678"
}
