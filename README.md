# GPD Win Max 2 Sleep Management: `sleephead`

## Installation

### Arch Linux

Build and install using the provided PKGBUILD:

```bash
git clone https://github.com/pastleo/gpd-wm2-sleephead.git
cd gpd-wm2-sleephead
makepkg -si
```

## Monitoring

```bash
# View all sleep management logs
journalctl -t gpd-wm2-sleephead

# Follow logs in real-time
journalctl -t gpd-wm2-sleephead -f
```
