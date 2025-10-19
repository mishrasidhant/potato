# potato

A pomodoro timer for the shell.

## Building and Installing

This package uses a PKGBUILD for Arch Linux and Arch-based distributions.

### Prerequisites
- `base-devel` package group (includes `makepkg`)
- `libpulse` (PulseAudio library for audio playback)

### Build from Source

1. Clone the repository or navigate to the source directory:
   ```bash
   cd /path/to/potato
   ```

2. Build the package:
   ```bash
   makepkg -f
   ```
   This creates a package file in your configured package output directory (usually `~/build/packages/` or the current directory).

   **Note**: The `-f` flag forces a rebuild even if the package already exists. Omit it for the first build.

3. Install the package:
   ```bash
   sudo pacman -U /path/to/potato-6-1-any.pkg.tar.zst
   ```

### Build and Install in One Step

Alternatively, build and install directly:
```bash
makepkg -si
```
- `-s` installs build dependencies automatically
- `-i` installs the package after building

To force a rebuild when a package already exists:
```bash
makepkg -sif
```
- `-f` forces rebuild even if package already exists

### Usage

After installation, run the timer with:
```bash
potato
```

Use `potato -h` to see available options including metronome mode (`-t`), custom work/break durations, and more.

## Credits
Notification sound (notification.wav, originally
zapsplat\_mobile\_phone\_notification\_003.mp3 decoded and saved as wav with
mpg123)
obtained from [zapsplat.com](https://www.zapsplat.com/) under Creative Commons
CC0.

