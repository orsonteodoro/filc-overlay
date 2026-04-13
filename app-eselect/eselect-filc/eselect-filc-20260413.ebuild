# Copyright 2026 Orson Teodoro
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="eselect module for managing Fil-C compiler versions"
HOMEPAGE="https://github.com/OrsonTeodoro/filc-overlay"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="app-eselect/eselect"

S="${WORKDIR}"

src_install() {
    # Install timestamped source as standard module name
    insinto /usr/share/eselect/modules
    newins "${FILESDIR}/filc-${PV}.eselect" filc.eselect
}

pkg_postinst() {
    elog "eselect filc module installed."
    elog ""
    elog "Useful commands:"
    elog "    eselect filc list"
    elog "    eselect filc set live"
    elog "    eselect filc set 0.678"
    elog "    eselect filc show"
}
