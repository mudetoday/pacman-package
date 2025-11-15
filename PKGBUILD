# Maintainer: Denis "mudetoday" Kiselev <mudetoday@gmail.com>
pkgname=template
pkgver=1.0
pkgrel=1
pkgdesc="Base template for any package written in C."
arch=('x86_64')
url="https://example.com/"
license=('MIT')
depends=('glibc')
makedepends=('make')

build() {
    cd "$startdir"
    make
}

package() {
    cd "$startdir"
    make DESTDIR="$pkgdir" install
}
