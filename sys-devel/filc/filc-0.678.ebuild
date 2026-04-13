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

DEPEND="${DEPEND}"
RDEPEND="${RDEPEND}"
BDEPEND="${BDEPEND}"

S="${WORKDIR}/fil-c-0.678"

src_configure() {
    einfo "Fil-C 0.678 source ready at ${S}"
}

src_compile() {
    einfo "Building Fil-C 0.678..."
    # TODO: Integrate build scripts
    die "Full build integration coming soon"
}

src_install() {
    filc_src_install
}

pkg_postinst() {
    elog "Fil-C version 0.678 installed."
    elog ""
    elog "To activate it:"
    elog "    eselect filc set 0.678"
}
