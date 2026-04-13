# Copyright 2026 Orson Teodoro
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit filc git-r3

DESCRIPTION="Filip Pizlo's Fil-C memory-safe C/C++ compiler (live deluge branch)"
HOMEPAGE="https://fil-c.org/"
EGIT_REPO_URI="https://github.com/pizlonator/fil-c.git"
EGIT_BRANCH="deluge"

LICENSE="MIT"
SLOT="live"
KEYWORDS=""

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

src_unpack() {
    git-r3_src_unpack
}

src_prepare() {
    default
}

src_configure() {
    einfo "Fil-C live source ready at ${S}"
}

src_compile() {
    einfo "Building Fil-C (this will take a long time)..."
    # TODO: Integrate actual bootstrap build scripts here
    # For now we leave a placeholder
    die "Full build integration coming in next iteration"
}

src_install() {
    local filc_libdir="/usr/lib/fil-c/${PV}"
    local yolo_libdir="/usr/lib/yolo/${PV}"

    dodir "${filc_libdir}/bin"
    dodir "${filc_libdir}/lib"
    dodir "${yolo_libdir}"

    # Placeholder install
    einfo "Fil-C ${PV} installed to ${filc_libdir}"
    einfo "Yolo glibc installed to ${yolo_libdir}"
}

pkg_postinst() {
    elog "Fil-C live version installed."
    elog ""
    elog "To make it active:"
    elog "    eselect filc set live"
    elog ""
    elog "After activation you can compile with:"
    elog "    filcc hello.c -o hello"
}
