# 📁 File Organizer

A fast, powerful command-line tool for organizing files by category, date, or custom criteria. Written in [Odin](https://odin-lang.org/) for maximum performance and reliability.

**✨ Standalone binaries with zero dependencies - just download and run!**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Language: Odin](https://img.shields.io/badge/Language-Odin-blue.svg)](https://odin-lang.org/)
[![Platform](https://img.shields.io/badge/Platform-Linux%20%7C%20Windows-blue)](https://github.com/yourusername/file-organizer/releases)

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

### File Categories

Files are automatically categorized based on their extensions:

| Category | Extensions |
|----------|------------|
| **Images** | `.jpg`, `.jpeg`, `.png`, `.gif`, `.bmp`, `.svg`, `.webp`, `.ico`, `.tiff` |
| **Documents** | `.pdf`, `.doc`, `.docx`, `.txt`, `.md`, `.rtf`, `.odt`, `.pptx`, `.xlsx`, `.csv` |
| **Videos** | `.mp4`, `.avi`, `.mkv`, `.mov`, `.wmv`, `.flv`, `.webm`, `.m4v` |
| **Audio** | `.mp3`, `.wav`, `.flac`, `.ogg`, `.aac`, `.m4a`, `.wma` |
| **Code** | `.py`, `.go`, `.rs`, `.c`, `.cpp`, `.h`, `.odin`, `.js`, `.ts`, `.java`, `.cs`, `.rb` |
| **Archives** | `.zip`, `.tar`, `.gz`, `.rar`, `.7z`, `.bz2`, `.jar`, `.xz` |
| **Applications** | `.exe`, `.dmg`, `.app`, `.deb`, `.rpm`, `.msi`, `.appimage` |
| **Disk Images** | `.iso`, `.img`, `.vdi`, `.vmdk` |
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

## 🎯 Use Cases

- **📥 Clean Downloads folder**: Automatically organize your messy Downloads directory
- **📸 Photo management**: Organize photos by date or remove duplicates
- **💼 Project cleanup**: Recursively organize project files by type
- **🗄️ Archive management**: Find and remove duplicate files to save space
- **📚 Document organization**: Sort documents by date or category

## 🛠️ Development

### Project Structure

```
file-organizer/
├── main.odin           # Main source code
├── README.md           # This file
├── LICENSE             # MIT License
└── organize            # Compiled binary
```

### Building

```bash
# Debug build
odin build . -out:organize -debug

# Optimized build
odin build . -out:organize -o:speed

# Production build with all optimizations
odin build . -out:organize -o:aggressive -microarch:native
```

### Testing

```bash
# Create test directory
mkdir test_dir
cd test_dir
touch file1.jpg file2.pdf file3.mp3

# Test dry run
./organize test_dir --dry-run

# Test with stats
./organize test_dir --dry-run --stats

# Clean up
rm -rf test_dir
```

## 🤝 Contributing

Contributions are welcome! Here are some ways you can contribute:

1. **Report bugs**: Open an issue describing the bug and how to reproduce it
2. **Suggest features**: Open an issue with your feature idea
3. **Submit pull requests**: Fork the repo, make your changes, and submit a PR

### Guidelines

- Follow Odin coding conventions
- Add tests for new features
- Update documentation as needed
- Keep commits atomic and well-described

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Built with [Odin](https://odin-lang.org/) programming language
- Inspired by various file organization tools
- Uses SHA256 hashing for reliable duplicate detection

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/yourusername/file-organizer/issues)
- **Discussions**: [GitHub Discussions](https://github.com/yourusername/file-organizer/discussions)

## 🗺️ Roadmap

- [ ] Watch mode for automatic organization
- [ ] Custom configuration files (TOML/YAML)
- [ ] Smart renaming with metadata extraction
- [ ] Multi-directory organization
- [ ] Archive compression for old files
- [ ] GUI interface
- [ ] File preview before moving
- [ ] Regex pattern support
- [ ] Plugin system

---

**Made with ❤️ using Odin**

⭐ Star this repo if you find it useful!
