# 📁 File Organizer v2.1

A fast, powerful command-line tool for organizing files by category, date, or custom criteria. Written in [Odin](https://odin-lang.org/) for maximum performance and reliability.

**✨ Standalone binaries with zero dependencies - just download and run!**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Language: Odin](https://img.shields.io/badge/Language-Odin-blue.svg)](https://odin-lang.org/)
[![Platform](https://img.shields.io/badge/Platform-Linux%20%7C%20Windows-blue)](https://github.com/yourusername/file-organizer/releases)

## 🆕 What's New in v2.1

- ⚙️ **Configuration File Support**: Save your preferences in JSON config files
- 🎨 **Custom Categorization Rules**: Define your own file categories
- 📝 **Error Logging**: Log errors to file for debugging and auditing
- 🔐 **Permission Preservation**: Automatically preserve file permissions during moves
- 💬 **Verbose Mode**: Detailed output for troubleshooting
- 🛡️ **Input Validation**: Enhanced security with path sanitization
- 📚 **Extended File Types**: Support for more file extensions (fonts, config files, etc.)

## 🌟 Features

### Core Functionality
- **🗂️ Automatic Categorization**: Organizes files into categories (Images, Documents, Videos, Audio, Code, Archives, etc.)
- **🔍 Duplicate Detection**: SHA256-based content detection to find and manage duplicate files
- **📊 Detailed Statistics**: View file counts, sizes, and breakdown by category
- **🎨 Colorized Output**: Beautiful terminal UI with progress indicators
- **🔄 Undo Support**: Reverse any organization operation with a single command
- **👁️ Dry Run Mode**: Preview changes before applying them

### Advanced Features
- **📂 Recursive Scanning**: Scan subdirectories to any depth
- **📅 Date-Based Organization**: Organize files by modification date (YYYY-MM format)
- **🎯 File Size Filtering**: Filter files by minimum and maximum size
- **🚫 Exclude Patterns**: Skip specific files or patterns during organization
- **💬 Interactive Mode**: Confirm each file move individually
- **🗑️ Duplicate Management**: Delete duplicate files interactively
- **📈 Progress Bars**: Real-time progress indicators for large operations
- **⚙️ Configuration Files**: Load settings from JSON configuration files
- **🎨 Custom Categories**: Define custom categorization rules per extension
- **📝 Error Logging**: Log all errors to a file for auditing
- **🔐 Permission Preservation**: Maintain file permissions after moves
- **💬 Verbose Output**: Detailed logging for debugging and monitoring

## 📦 Installation

### Pre-built Binaries (Recommended)

**✨ No dependencies required!** Download standalone executables that work out of the box.

Download the latest release from the [Releases](https://github.com/yourusername/file-organizer/releases) page.

#### Linux
```bash
# Download and extract
tar -xzf file-organizer-linux-x64.tar.gz
cd linux-package

# Run directly
./organize ~/Downloads --dry-run

# Optional: Install system-wide
sudo ./install.sh
```

#### Windows
1. Download `file-organizer-windows-x64.zip`
2. Extract to any folder
3. Run it one of three ways:
   - **Drag & Drop**: Drag a folder onto `organize.bat`
   - **PowerShell**: Right-click `organize.ps1` → "Run with PowerShell"
   - **Command Line**: Open CMD in the folder and run:
     ```cmd
     organize.exe C:\Users\YourName\Downloads
     ```

**Note for Windows**: Windows Defender may show a warning for new executables. Click "More info" → "Run anyway". The program is safe!

### Build from Source

**Requirements:**
- [Odin compiler](https://odin-lang.org/docs/install/) (latest version)
- Git

```bash
# Clone the repository
git clone https://github.com/yourusername/file-organizer.git
cd file-organizer

# Build the project
odin build . -out:organize -o:speed

# Run
./organize --help
```

## 🚀 Quick Start

```bash
# Basic organization
organize ~/Downloads

# Preview without making changes
organize ~/Downloads --dry-run

# Recursive organization with statistics
organize ~/Documents --recursive --stats

# Find duplicate files
organize ~/Pictures --duplicates
```

## 📖 Usage

```
organize <directory> [options]
```

### Command-Line Options

| Option | Short | Description |
|--------|-------|-------------|
| `--dry-run` | `-d` | Preview changes without moving files |
| `--recursive` | `-r` | Scan subdirectories recursively |
| `--interactive` | `-i` | Confirm each file move |
| `--stats` | `-s` | Show detailed statistics |
| `--by-date` | | Organize by modification date (YYYY-MM) |
| `--duplicates` | | Find and display duplicate files |
| `--delete-duplicates` | | Interactively delete duplicate files |
| `--undo` | | Undo the last organization operation |
| `--no-color` | | Disable colored output |
| `--exclude <patterns>` | `-e` | Exclude files matching patterns (comma-separated) |
| `--min-size <size>` | | Minimum file size (e.g., 1MB, 500KB) |
| `--max-size <size>` | | Maximum file size (e.g., 100MB, 1GB) |
| `--verbose` | `-v` | Enable verbose output with detailed logging |
| `--config <file>` | `-c` | Load configuration from JSON file |
| `--log <file>` | | Log errors to specified file |
| `--preserve-perms` | | Preserve file permissions (default: enabled) |
| `--no-preserve-perms` | | Don't preserve file permissions |
| `--category <ext> <cat>` | | Set custom category for file extension |

### File Categories

Files are automatically categorized based on their extensions:

| Category | Extensions |
|----------|------------|
| **Images** | `.jpg`, `.jpeg`, `.png`, `.gif`, `.bmp`, `.svg`, `.webp`, `.ico`, `.tiff` |
| **Documents** | `.pdf`, `.doc`, `.docx`, `.txt`, `.md`, `.rtf`, `.odt`, `.pptx`, `.xlsx`, `.csv` |
| **Videos** | `.mp4`, `.avi`, `.mkv`, `.mov`, `.wmv`, `.flv`, `.webm`, `.m4v` |
| **Audio** | `.mp3`, `.wav`, `.flac`, `.ogg`, `.aac`, `.m4a`, `.wma` |
| **Code** | `.py`, `.go`, `.rs`, `.c`, `.cpp`, `.h`, `.odin`, `.js`, `.ts`, `.java`, `.cs`, `.rb`, `.php`, `.swift`, `.kt` |
| **Archives** | `.zip`, `.tar`, `.gz`, `.rar`, `.7z`, `.bz2`, `.jar`, `.xz`, `.tar.gz`, `.tgz` |
| **Applications** | `.exe`, `.dmg`, `.app`, `.deb`, `.rpm`, `.msi`, `.appimage`, `.bin` |
| **Disk Images** | `.iso`, `.img`, `.vdi`, `.vmdk`, `.qcow2` |
| **Configuration** | `.json`, `.xml`, `.yaml`, `.yml`, `.toml`, `.ini`, `.cfg`, `.conf` |
| **Fonts** | `.ttf`, `.otf`, `.woff`, `.woff2` |
| **Other** | All other file types |

## 💡 Examples

### Basic Organization

```bash
# Organize Downloads folder
organize ~/Downloads

# Output:
# Found 245 files in 8 categories:
#   📁 Images              (120 files, 2.5 GB)
#   📁 Documents           (80 files, 450 MB)
#   📁 Videos              (30 files, 5.2 GB)
#   📁 Archives            (15 files, 800 MB)
#
# Proceed with organization? (y/n): y
# Moving: [████████████████████████████] 100% (245/245)
# ✓ Successfully organized 245 files!
```

### Dry Run with Statistics

```bash
organize ~/Desktop --dry-run --stats

# Output:
# === Statistics ===
# Total files: 156
# Total size: 3.45 GB
#
# By category (largest first):
#   Videos         :    15 files,    2.10 GB
#   Images         :    89 files,    980.50 MB
#   Documents      :    42 files,    345.20 MB
#   Other          :    10 files,     24.30 MB
#
# ⚠ [DRY RUN - no files will be moved]
```

### Recursive Organization with Exclusions

```bash
organize ~/Projects --recursive --exclude '*.tmp,*.log,node_modules'

# Scans all subdirectories and ignores temporary files and node_modules
```

### Date-Based Organization

```bash
organize ~/Photos --by-date

# Output:
# Found 450 files in 12 categories:
#   📁 2025-10             (85 files, 1.2 GB)
#   📁 2025-09             (120 files, 1.8 GB)
#   📁 2025-08             (95 files, 1.4 GB)
#   ...
```

### Find and Remove Duplicates

```bash
organize ~/Downloads --duplicates --delete-duplicates

# Output:
# Scanning: [████████████████████████████] 100% (500/500)
#
# ⚠ Duplicate files (1.2 MB):
#   /home/user/Downloads/photo.jpg
#   /home/user/Downloads/photo (1).jpg
#   /home/user/Downloads/photo-copy.jpg
#
# Delete duplicates (keep first)? (y/n): y
# ✓ Deleted: /home/user/Downloads/photo (1).jpg
# ✓ Deleted: /home/user/Downloads/photo-copy.jpg
#
# Found 45 sets of duplicate files.
# Potential space savings: 250.5 MB
```

### Interactive Mode

```bash
organize ~/Desktop --interactive

# Output:
# Move document.pdf to Documents? (y/n/q): y
# Move photo.jpg to Images? (y/n/q): y
# Move old_file.tmp to Other? (y/n/q): n
# Move video.mp4 to Videos? (y/n/q): q
# ℹ Cancelled remaining operations.
```

### Size Filtering

```bash
# Only organize files between 1MB and 100MB
organize ~/Downloads --min-size 1MB --max-size 100MB

# Only organize large files (>100MB)
organize ~/Videos --min-size 100MB
```

### Undo Last Operation

```bash
# Organize files
organize ~/Downloads

# Oops, made a mistake!
organize ~/Downloads --undo

# Output:
# ℹ Found 245 operations from 2025-10-22 19:15:30
# Undo these operations? (y/n): y
# ✓ Undone 245 operations!
```

### Using Configuration Files

```bash
# Create a config file at ~/.organizer.json
{
  "recursive": true,
  "use_colors": true,
  "preserve_perms": true,
  "verbose": false,
  "exclude_patterns": ["*.tmp", "*.log", "node_modules"],
  "custom_categories": {
    "WebAssets": [".tsx", ".jsx", ".scss", ".sass"],
    "DataFiles": [".csv", ".json", ".xml"]
  }
}

# Use the config file
organize ~/Projects --config ~/.organizer.json

# Output:
# ✓ Loaded config from: /home/user/.organizer.json
# Found 320 files in 15 categories...
```

### Custom Categorization

```bash
# Organize with custom categories for specific extensions
organize ~/Code --category .tsx WebCode --category .jsx WebCode

# Multiple custom categories
organize ~/Files --category .dat Data --category .bin Binary --category .log Logs
```

### Verbose Mode with Error Logging

```bash
# Enable verbose output and log errors to file
organize ~/Downloads --verbose --log ~/organize-errors.log

# Output shows detailed information:
# ℹ Moved: photo.jpg -> Images
# ℹ Moved: document.pdf -> Documents
# ⚠ Failed to preserve permissions for: old_file.txt
# ℹ Moved: video.mp4 -> Videos
# ...

# Check error log
cat ~/organize-errors.log
# [2025-10-24 21:30:15] move_file | /path/to/file.txt | Failed to move file.txt: Permission denied
```

### Advanced Workflow

```bash
# Complete workflow with all features
organize ~/Downloads \
  --config ~/.organizer.json \
  --verbose \
  --log ~/org-errors.log \
  --recursive \
  --exclude '*.tmp,*.log' \
  --min-size 1KB \
  --max-size 500MB \
  --stats \
  --dry-run

# Review the dry run, then execute
organize ~/Downloads \
  --config ~/.organizer.json \
  --log ~/org-errors.log \
  --recursive
```

## ⚙️ Configuration

### Operation Log

The tool saves operation logs to `~/.file-organizer/last_operation.json` for undo functionality. This log is automatically overwritten with each new organization operation.

### Color Output

By default, the tool uses ANSI colors for better readability. Disable colors for scripts or unsupported terminals:

```bash
organize ~/Downloads --no-color
```

## 🔒 Safety Features

1. **Duplicate Detection**: Automatically skips duplicate files based on content (SHA256 hash)
2. **Name Conflict Resolution**: Automatically renames files to avoid overwriting (e.g., `file.txt` → `file (1).txt`)
3. **Dry Run Mode**: Preview all changes before applying
4. **Undo Functionality**: Reverse any operation
5. **Interactive Confirmation**: Manual confirmation before moving files
6. **Input Validation**: Path sanitization prevents malicious inputs
7. **Permission Preservation**: Maintains file permissions after moves
8. **Error Logging**: All errors are logged for auditing and debugging
9. **Safe File Operations**: Robust error handling for all file operations
10. **Configuration Validation**: JSON config files are validated before use

## 🎯 Use Cases

- **📥 Clean Downloads folder**: Automatically organize your messy Downloads directory
- **📸 Photo management**: Organize photos by date or remove duplicates
- **💼 Project cleanup**: Recursively organize project files by type
- **🗄️ Archive management**: Find and remove duplicate files to save space
- **📚 Document organization**: Sort documents by date or category

### Building

```bash
# Debug build
odin build . -out:organize -debug

# Optimized build
odin build . -out:organize -o:speed

# Production build with all optimizations
odin build . -out:organize -o:aggressive -microarch:native
```


**Made with ❤️ using Odin**

⭐ Star this repo if you find it useful!
