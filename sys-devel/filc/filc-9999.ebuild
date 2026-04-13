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

DEPEND="${DEPEND}"
RDEPEND="${RDEPEND}"
BDEPEND="${BDEPEND}"

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
    # TODO: Integrate bootstrap build scripts here in future iteration
    die "Full build integration coming soon"
}

src_install() {
    filc_src_install
}

pkg_postinst() {
    elog "Fil-C live version installed."
    elog ""
    elog "To activate it:"
    elog "    eselect filc set live"
    elog ""
    elog "After activation you can compile with:"
    elog "    filcc hello.c -o hello"
}
