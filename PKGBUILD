pkgname=potato
pkgver=6
pkgrel=2
pkgdesc="A pomodoro timer for the shell"
arch=('any')
url="https://github.com/Bladtman242/potato"
license=('MIT')
depends=('libpulse')
source=('potato.sh'
        'notification.wav'
        'metronome.wav'
        'LICENSE')
md5sums=('e8de97aee5087e2f8917af5564d20633'
         'b01bacb54937c9bdd831f4d4ffd2e31c'
         '3865eafc6c3049831adb95b46c357e51'
         '1ddcbd2862764b43d75fb1e484bf8912')
package() {
	install -D $srcdir/potato.sh $pkgdir/usr/bin/$pkgname
	install -D -m644 $srcdir/LICENSE $pkgdir/usr/share/licenses/$pkgname/LICENSE
	install -D $srcdir/notification.wav $pkgdir/usr/lib/$pkgname/notification.wav
	install -D $srcdir/metronome.wav $pkgdir/usr/lib/$pkgname/metronome.wav
}
