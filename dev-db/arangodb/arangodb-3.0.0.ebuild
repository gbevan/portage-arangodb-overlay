# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
CMAKE_BUILD_TYPE=Release
PYTHON_COMPAT=( python2_7 )

inherit eutils user vcs-snapshot systemd python-any-r1 cmake-utils

DESCRIPTION="The multi-purpose multi-model NoSQL DB"
HOMEPAGE="http://www.arangodb.org/"

GITHUB_USER="arangodb"
GITHUB_TAG="v${PV}"

SRC_URI="https://github.com/${GITHUB_USER}/${PN}/archive/${GITHUB_TAG}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=sys-libs/readline-6.2_p1
    >=dev-libs/openssl-1.0.1g
    >=dev-lang/go-1.2
    ${PYTHON_DEPEND}"
RDEPEND="${DEPEND}"

#BUILD_DIR="${WORKDIR}/arangodb/build"

pkg_setup() {
  python-any-r1_pkg_setup
  ebegin "Ensuring arangodb user and group exist"
  enewgroup arangodb
  enewuser arangodb -1 -1 -1 arangodb
  eend $?
}

src_prepare() {
    #epatch here
    cmake-utils_src_prepare
}

src_configure() {
  #econf --localstatedir="${EPREFIX}"/var --enable-all-in-one-v8 --enable-all-in-one-libev --enable-all-in-one-icu || die "configure failed"

  local mycmakeargs=(
    -DLOCALSTATEDIR=/var
    -DUSE_BOOST_SYSTEM_LIBS=on
  )
  cmake-utils_src_configure
}

src_install() {
  #emake DESTDIR="${D}" install

  mkdir -p ${D}/var/lib/arangodb
  mkdir -p ${D}/var/lib/arangodb-apps
  mkdir -p ${D}/var/log/arangodb

  cmake-utils_src_install

  newinitd "${FILESDIR}"/arangodb.initd arangodb

  fowners arangodb:arangodb /var/lib/arangodb /var/lib/arangodb-apps /var/log/arangodb

  systemd_dounit "${FILESDIR}"/arangodb.service
}
