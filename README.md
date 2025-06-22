# GPD Win Max 2 Sleep Management: `sleephead`

Intelligent suspend/hibernation management scripts for GPD Win Max 2 devices running Linux.

## Overview

This project provides systemd sleep hooks that automatically manage power states on GPD Win Max 2 devices. The system intelligently switches from suspend to hibernation after 6 hours to preserve battery life when the lid is closed and the device is running on battery power.

## Features

- **Intelligent Power Management**: Automatically hibernates after 6 hours of suspend when on battery
- **Lid Detection**: Only triggers hibernation when the lid is closed
- **Battery Aware**: Only hibernates when running on battery power (not AC)
- **Safe Transitions**: Ensures proper suspend/hibernate state transitions
- **Systemd Integration**: Uses systemd sleep hooks for reliable operation
- **Comprehensive Logging**: All actions logged via systemd-cat

## Components

### `gpd-wm2-sleephead.sh`
Main systemd sleep hook script that:
- Tracks sleep start time on suspend
- Checks lid state and battery status on resume
- Triggers hibernation after 6+ hours of sleep on battery
- Manages sleep timestamp cleanup

### `gpd-wm2-crawl-back-to.sh`
Helper script that safely executes suspend/hibernate commands:
- Waits for suspend.target to become inactive before proceeding
- Prevents race conditions during state transitions
- Includes retry logic with timeout protection

## Installation

### Arch Linux

Build and install using the provided PKGBUILD:

```bash
git clone https://github.com/pastleo/gpd-wm2-sleephead.git
cd gpd-wm2-sleephead
makepkg -si
```

## Configuration

### Hibernation Threshold

The default hibernation threshold is 6 hours. To modify this, edit line 5 in `gpd-wm2-sleephead.sh`:

```bash
hibernation_threshold_hours=6
```

### Device-Specific Paths

The script assumes standard ACPI paths for GPD Win Max 2:
- Lid state: `/proc/acpi/button/lid/LID0/state`
- Battery status: `/sys/class/power_supply/BAT0/status`

If your device uses different paths, modify lines 20-21 in the main script.

## Usage

Once installed, the scripts work automatically with systemd sleep events. No manual intervention is required.

### Monitoring

View logs using journalctl:

```bash
# View all sleep management logs
journalctl -t gpd-wm2-sleephead

# Follow logs in real-time
journalctl -t gpd-wm2-sleephead -f
```

## How It Works

1. **Pre-suspend**: Records timestamp when suspend begins
2. **Post-resume**: Checks conditions and decides next action:
   - If lid open OR on AC power: Clean up and stay awake
   - If lid closed AND on battery:
     - Sleep < 6 hours: Return to suspend
     - Sleep ≥ 6 hours: Switch to hibernation

## Requirements

- Linux with systemd
- ACPI support for lid and battery detection
- Hibernation properly configured (swap space/file)

## Troubleshooting

### Hibernation Not Working

Ensure hibernation is properly configured:
```bash
# Check if hibernation is available
systemctl hibernate
```

### Logs Not Appearing

Verify systemd-cat is working:
```bash
echo "test" | systemd-cat -t gpd-wm2-sleephead
journalctl -t gpd-wm2-sleephead --since "1 minute ago"
```

### Script Not Executing

Check script permissions and location:
```bash
ls -la /usr/lib/systemd/system-sleep/gpd-wm2-sleephead
ls -la /usr/local/bin/gpd-wm2-crawl-back-to
```

## License

MIT License - see package metadata for details.

## Contributing

Issues and pull requests welcome on the project repository.
