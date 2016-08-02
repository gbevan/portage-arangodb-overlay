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
PN=arangodb

SRC_URI="https://github.com/${GITHUB_USER}/${PN}/archive/${GITHUB_TAG}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=sys-libs/readline-6.2_p1
    >=dev-libs/openssl-1.0.1g
    ${PYTHON_DEPEND}"
RDEPEND="${DEPEND}"

pkg_setup() {
  python-any-r1_pkg_setup
  ebegin "Ensuring arangodb3 user and group exist"
  enewgroup arangodb3
  enewuser arangodb3 -1 -1 -1 arangodb3
  eend $?
}

src_prepare() {
    cmake-utils_src_prepare
}

src_configure() {

  local mycmakeargs=(
    -DVERBOSE=On
    -DUSE_OPTIMIZE_FOR_ARCHITECTURE=Off
    -DCMAKE_BUILD_TYPE=RelWithDebInfo
    #-DCMAKE_C_FLAGS="$(CFLAGS)"
    #-DCMAKE_CXX_FLAGS="$(CXXFLAGS)"
    -DETCDIR=/etc
    -DVARDIR=/var
    -DCMAKE_INSTALL_PREFIX:PATH=/usr
    -DCMAKE_SKIP_RPATH:BOOL=ON
  )
  cmake-utils_src_configure
}

src_install() {
  cmake-utils_src_install

  newinitd "${FILESDIR}"/arangodb3.initd arangodb

  systemd_dounit "${FILESDIR}"/arangodb3.service
}
