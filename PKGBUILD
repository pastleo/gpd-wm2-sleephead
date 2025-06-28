# Maintainer: PastLeo <chgu82837@gmail.com>
pkgname=gpd-wm2-sleephead
pkgver=1.0.0
pkgrel=1
pkgdesc="Suspend/hibernation management script for GPD Win Max 2"
arch=('any')
url="https://github.com/pastleo/gpd-wm2-sleephead"
license=('MIT')
depends=('systemd')
source=("gpd-wm2-sleephead.sh" "gpd-wm2-crawl-back-to-sleep.sh" "gpd-wm2-crawl-back-to-sleep.service")
sha256sums=('SKIP' 'SKIP' 'SKIP')

package() {
  install -Dm755 "$srcdir/gpd-wm2-sleephead.sh" "$pkgdir/usr/lib/systemd/system-sleep/gpd-wm2-sleephead"
  install -Dm755 "$srcdir/gpd-wm2-crawl-back-to-sleep.sh" "$pkgdir/usr/local/bin/gpd-wm2-crawl-back-to-sleep"
  install -Dm644 "$srcdir/gpd-wm2-crawl-back-to-sleep.service" "$pkgdir/usr/lib/systemd/system/gpd-wm2-crawl-back-to-sleep.service"
}
