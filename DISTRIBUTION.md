# Distribution Guide

## What You Have

Your File Organizer is now packaged as **standalone executables** that users can run without installing Odin!

### Distribution Packages

Located in `./dist/`:

```
dist/
├── file-organizer-1.0.0-linux-x64.tar.gz  (81 KB)
├── file-organizer-1.0.0-linux-x64.zip     (82 KB)
├── checksums.txt                           (SHA256 hashes)
└── file-organizer-1.0.0-linux-x64/        (extracted folder)
    ├── organize           (binary - 187 KB)
    ├── main.odin         (source code)
    ├── README.md         (full documentation)
    ├── INSTALL.md        (installation guide)
    └── install.sh        (auto-installer)
```

## For End Users (No Odin Required!)

### ✅ What's Included

The distributed packages contain:
- **Ready-to-run binary** (no compilation needed)
- **Automated installer** (one-command setup)
- **Full documentation** (usage guide)
- **Source code** (for transparency/customization)

### ✅ System Requirements

**Linux (Pre-built binary):**
- Any modern Linux distribution (Ubuntu, Debian, Fedora, Arch, etc.)
- x86_64 architecture
- glibc 2.31+ (included in all modern distros)
- **No Odin installation required!**

**Windows/macOS:**
- Need to build from included source
- Instructions provided in INSTALL.md

## How Users Install

### Quick Install (3 steps)

1. **Download & Extract:**
   ```bash
   wget <your-url>/file-organizer-1.0.0-linux-x64.tar.gz
   tar -xzf file-organizer-1.0.0-linux-x64.tar.gz
   cd file-organizer-1.0.0-linux-x64
   ```

2. **Run Auto-Installer:**
   ```bash
   ./install.sh
   ```

3. **Start Using:**
   ```bash
   organize ~/Downloads --dry-run
   ```

### Manual Install

```bash
# Extract archive
tar -xzf file-organizer-1.0.0-linux-x64.tar.gz
cd file-organizer-1.0.0-linux-x64

# Copy binary to system path
sudo cp organize /usr/local/bin/

# Done! Use anywhere:
organize ~/Desktop
```

## Sharing Your Package

### Option 1: GitHub Release

1. Create a GitHub repository for your project
2. Create a new release (e.g., v1.0.0)
3. Upload both archives:
   - `file-organizer-1.0.0-linux-x64.tar.gz`
   - `file-organizer-1.0.0-linux-x64.zip`
4. Include `checksums.txt` in the release notes

**Download URL will be:**
```
https://github.com/yourusername/file-organizer/releases/download/v1.0.0/file-organizer-1.0.0-linux-x64.tar.gz
```

### Option 2: Direct Download

Host the files on:
- Your website
- Google Drive / Dropbox (public link)
- File hosting service

Share the download link with users.

### Option 3: Package Repository

For wider distribution:
- **AUR (Arch Linux)**: Create PKGBUILD
- **Homebrew**: Create formula
- **Debian**: Create .deb package
- **Snap/Flatpak**: Create snap/flatpak package

## Regenerating Distribution Packages

If you make changes:

```bash
# 1. Rebuild the binary
odin build main.odin -file -out:organize -o:speed -no-bounds-check
strip organize

# 2. Recreate distribution packages
./create-dist.sh

# New packages will be in ./dist/
```

## Version Updates

To create a new version:

1. **Edit `create-dist.sh`:**
   ```bash
   VERSION="1.1.0"  # Update this line
   ```

2. **Rebuild and repackage:**
   ```bash
   odin build main.odin -file -out:organize -o:speed -no-bounds-check
   strip organize
   ./create-dist.sh
   ```

3. **New packages:**
   - `file-organizer-1.1.0-linux-x64.tar.gz`
   - `file-organizer-1.1.0-linux-x64.zip`

## Building for Other Platforms

### Windows Build

**On Windows:**
```batch
odin build main.odin -file -out:organize.exe -o:speed -no-bounds-check
```

Then create a similar distribution package for Windows users.

### macOS Build

**On macOS:**
```bash
odin build main.odin -file -out:organize -o:speed -no-bounds-check
strip organize
```

Create distribution packages for macOS users.

### Cross-Platform Strategy

Since cross-compilation has limitations, recommended approach:

1. **Linux users**: Use pre-built binary from dist/
2. **Windows/macOS users**: Build from included source (takes 2 seconds)
3. **Or**: Provide platform-specific builds if you have access to those systems

## Verifying Integrity

Users can verify downloads using checksums:

```bash
# Verify tar.gz
sha256sum -c checksums.txt

# Should output:
# file-organizer-1.0.0-linux-x64.tar.gz: OK
```

Include `checksums.txt` in your distribution to enable this.

## What Users DON'T Need

✅ **Users do NOT need:**
- Odin compiler installed
- Any build tools
- Go, Rust, or any other language runtime
- Complex dependency management

✅ **Users only need:**
- Standard Linux system (glibc already included)
- Download & extract capability
- ~200KB of disk space

## Example Distribution README

Here's what you can tell users:

---

### 📦 File Organizer - Ready to Use!

**No installation required! No dependencies!**

Download, extract, and run:

```bash
# Download
wget <url>/file-organizer-1.0.0-linux-x64.tar.gz

# Extract
tar -xzf file-organizer-1.0.0-linux-x64.tar.gz
cd file-organizer-1.0.0-linux-x64

# Install (automatic)
./install.sh

# Or copy manually
sudo cp organize /usr/local/bin/

# Use it!
organize ~/Downloads --dry-run
```

**Size:** 187 KB  
**Platform:** Linux x86_64  
**License:** Open Source  

Full documentation included in `README.md`

---

## Support & Distribution Channels

### Where to Share

1. **GitHub**: Most popular for open-source tools
2. **GitLab**: Alternative to GitHub
3. **Your website**: Direct download links
4. **Reddit**: r/linux, r/commandline, r/odinlang
5. **Dev communities**: Dev.to, Hacker News
6. **Package managers**: AUR, Homebrew, apt/dnf repos

### What to Include

When sharing:
- ✅ Clear description of what it does
- ✅ System requirements
- ✅ Installation instructions
- ✅ Usage examples
- ✅ Screenshots/demos (optional)
- ✅ Changelog (for updates)
- ✅ License information

## File Sizes Summary

| Item | Size | Purpose |
|------|------|---------|
| `organize` binary | 187 KB | Main executable |
| `.tar.gz` package | 81 KB | Compressed Linux package |
| `.zip` package | 82 KB | Compressed (Windows-friendly) |
| Total download | ~81 KB | What users download |
| Installed size | ~187 KB | Disk space after install |

**Extremely lightweight!** Smaller than most images.

## Testing Your Distribution

Before sharing publicly:

```bash
# 1. Extract the package
cd /tmp
tar -xzf /path/to/file-organizer-1.0.0-linux-x64.tar.gz
cd file-organizer-1.0.0-linux-x64

# 2. Test the binary works
./organize --dry-run /tmp

# 3. Test the installer
./install.sh

# 4. Test system-wide installation
organize ~/Downloads --dry-run

# 5. Test uninstall
sudo rm /usr/local/bin/organize
```

All tests pass? Ready to distribute! 🚀

## Questions?

- **For users**: See `README.md` for usage help
- **For builders**: See `INSTALL.md` for build instructions
- **For errors**: Check system requirements and try building from source

---

**Your file organizer is now ready for distribution to anyone, anywhere!**

No complicated setup. No dependency hell. Just download and use.
