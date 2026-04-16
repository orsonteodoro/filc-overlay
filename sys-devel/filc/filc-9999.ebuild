# Copyright 2026 Orson Teodoro
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit filc git-r3

DESCRIPTION="Filip Pizlo's Fil-C memory-safe C/C++ compiler (live deluge branch)"
HOMEPAGE="https://fil-c.org/"
EGIT_REPO_URI="https://github.com/pizlonator/fil-c.git"
EGIT_BRANCH="deluge"

LICENSE="Apache-2.0 BSD-2 LGPL-2.1+ MIT"
SLOT="0"
KEYWORDS=""
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

src_unpack() {
    git-r3_src_unpack
}

src_prepare() {
    default
}

src_configure() {
    einfo "Fil-C live source ready at ${S}"
    einfo "Building with $(usex elibc_glibc 'glibc' 'musl') backend"
}

src_compile() {
    einfo "Building Fil-C live version..."

    cd "${S}" || die

    if use elibc_glibc; then
        if [[ -x "./build_all_fast_glibc.sh" ]]; then
            ./build_all_fast_glibc.sh || die "Fil-C glibc build failed"
        else
            die "build_all_fast_glibc.sh not found"
        fi
    elif use elibc_musl; then
        if [[ -x "./build_all_fast_musl.sh" ]]; then
            ./build_all_fast_musl.sh || die "Fil-C musl build failed"
        else
            die "build_all_fast_musl.sh not found"
        fi
    fi
}

src_install() {
    filc_src_install

    # Copy artifacts from bootstrap output to final locations
    if [[ -d "/opt/fil" ]]; then
        cp -a /opt/fil/. "${D}/usr/lib/fil-c/" || true
    fi

    if [[ -d "/usr/lib/yolo" ]]; then
        cp -a /usr/lib/yolo/. "${D}/usr/lib/yolo/" || true
    fi
}

pkg_postinst() {
    elog "Fil-C installed."
    elog ""
    elog "To use Fil-C as compiler:"
    elog "    export CC=/usr/lib/fil-c/bin/filcc"
    elog "    export CXX=/usr/lib/fil-c/bin/fil++"
    elog ""
    elog "Then rebuild packages with:"
    elog "    emerge -e @system"
}
