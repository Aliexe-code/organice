# Installation Guide

## Quick Install (Linux x86_64)

The pre-built binary works on most Linux distributions without requiring Odin to be installed.

### Option 1: System-Wide Installation (Recommended)

```bash
# Make the binary executable
chmod +x organize

# Copy to system path
sudo cp organize /usr/local/bin/

# Verify installation
organize
```

Now you can run `organize` from anywhere!

### Option 2: Local Installation

```bash
# Make the binary executable
chmod +x organize

# Add to your shell profile (~/.bashrc or ~/.zshrc)
export PATH="$PATH:/full/path/to/file-organizer"

# Or create a symbolic link
ln -s /full/path/to/file-organizer/organize ~/.local/bin/organize
```

## Dependencies

The binary only requires standard system libraries (included in all Linux distributions):
- `libc` (GNU C Library)
- `libm` (Math library)

**No need to install Odin or any other dependencies!**

## Platform-Specific Instructions

### Linux (Pre-built Binary Included)

**Supported Distributions:**
- Ubuntu 20.04+
- Debian 11+
- Fedora 35+
- Arch Linux (latest)
- CachyOS
- Any modern Linux with glibc 2.31+

**Installation:**
```bash
chmod +x organize
sudo cp organize /usr/local/bin/
```

### Windows (Build from Source)

Since cross-compilation is limited, Windows users need to build from source:

**Prerequisites:**
1. Download and install [Odin Compiler](https://github.com/odin-lang/Odin/releases)
2. Clone or download this project

**Build Steps:**
```batch
:: Navigate to project directory
cd file-organizer

:: Build executable
odin build main.odin -file -out:organize.exe -o:speed -no-bounds-check

:: Run it
organize.exe
```

**Distribution:**
- The resulting `organize.exe` is standalone
- Can be run on any Windows 10+ system without installing Odin
- Size: ~200KB

### macOS (Build from Source)

**Prerequisites:**
1. Install Xcode Command Line Tools:
   ```bash
   xcode-select --install
   ```

2. Download and install [Odin Compiler](https://github.com/odin-lang/Odin/releases)

**Build Steps:**
```bash
# Navigate to project directory
cd file-organizer

# Build executable
odin build main.odin -file -out:organize -o:speed -no-bounds-check

# Make executable
chmod +x organize

# Install system-wide
sudo cp organize /usr/local/bin/
```

## Verifying the Binary

### Check if it's standalone:
```bash
# Linux: Check dependencies
ldd organize

# Should only show:
# - linux-vdso.so.1
# - libm.so.6
# - libc.so.6
# - ld-linux-x86-64.so.2
```

### Test it works:
```bash
./organize --dry-run /tmp
```

## Building from Source (All Platforms)

If the pre-built binary doesn't work or you want to build from source:

### 1. Install Odin Compiler

**Linux/macOS:**
```bash
# Clone Odin repository
git clone https://github.com/odin-lang/Odin
cd Odin

# Build Odin
make

# Add to PATH (add to ~/.bashrc or ~/.zshrc)
export PATH="$PATH:/path/to/Odin"
```

**Windows:**
Download pre-built binaries from [Odin Releases](https://github.com/odin-lang/Odin/releases)

### 2. Build File Organizer

**Standard Build:**
```bash
odin build main.odin -file -out:organize
```

**Optimized Release Build:**
```bash
# Maximum performance
odin build main.odin -file -out:organize -o:speed -no-bounds-check

# Smaller binary size
odin build main.odin -file -out:organize -o:size -no-bounds-check

# Strip debug symbols (Linux/macOS)
strip organize
```

**Debug Build:**
```bash
odin build main.odin -file -out:organize -debug
```

## Uninstallation

### System-wide installation:
```bash
sudo rm /usr/local/bin/organize
```

### Local installation:
```bash
# Remove the binary
rm /path/to/organize

# Remove from PATH in ~/.bashrc or ~/.zshrc
# (Edit and remove the export PATH line)
```

## Troubleshooting

### "Permission denied" when running
```bash
chmod +x organize
```

### "Command not found" after installation
```bash
# Verify it's in PATH
which organize

# Refresh your shell
source ~/.bashrc  # or ~/.zshrc
```

### Library version errors (Linux)
The binary requires glibc 2.31+. Check your version:
```bash
ldd --version

# If too old, build from source on your system
```

### Binary doesn't work on your system
Build from source following the instructions above. This ensures compatibility with your specific system.

## Distribution Package Structure

```
file-organizer/
├── organize           # Pre-built Linux binary (187KB)
├── main.odin         # Source code
├── README.md         # Full documentation
├── INSTALL.md        # This file
└── install.sh        # Automated installation script
```

## Creating Portable Package

To create a distributable package:

```bash
# Create distribution directory
mkdir -p file-organizer-dist

# Copy necessary files
cp organize file-organizer-dist/
cp README.md file-organizer-dist/
cp INSTALL.md file-organizer-dist/

# Create archive
tar -czf file-organizer-linux-x64.tar.gz file-organizer-dist/

# Or create zip
zip -r file-organizer-linux-x64.zip file-organizer-dist/
```

Users can then extract and run without any dependencies!

## Advanced: Static Binary (Optional)

For maximum portability, you can attempt a static build:

```bash
# This may require musl-gcc or similar
odin build main.odin -file -out:organize -o:speed -no-bounds-check

# The binary still dynamically links to libc/libm
# True static linking with Odin is platform-dependent
```

## Support Matrix

| Platform | Pre-built Binary | Build from Source | Notes |
|----------|-----------------|-------------------|-------|
| Linux x86_64 | ✅ Included | ✅ Supported | glibc 2.31+ required |
| Linux ARM64 | ❌ Not included | ✅ Supported | Build from source |
| Windows x64 | ❌ Not included | ✅ Supported | Build on Windows |
| macOS x64 | ❌ Not included | ✅ Supported | Requires Xcode tools |
| macOS ARM64 | ❌ Not included | ✅ Supported | Apple Silicon |

---

**Questions?** Check README.md for usage documentation and troubleshooting.
