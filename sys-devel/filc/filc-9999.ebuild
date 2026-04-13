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
    einfo "Building Fil-C live version (this will take a long time)..."
    # TODO: Integrate actual bootstrap build here later
    die "Build integration coming in next iteration"
}

src_install() {
    filc_src_install
}

pkg_postinst() {
    elog "Fil-C live version installed."
    elog ""
    elog "To activate:"
    elog "    eselect filc set live"
    elog ""
    elog "Compile with: filcc hello.c -o hello"
}
