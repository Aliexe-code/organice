# 📁 File Organizer

A fast, intelligent file organization tool written in Odin that automatically categorizes and organizes your files into folders based on their type.

## 🚀 What is File Organizer?

File Organizer is a command-line utility that helps you declutter directories by automatically sorting files into categorized folders. Perfect for organizing Downloads folders, Desktop clutter, or any messy directory with mixed file types.

## ✨ Features

- **Automatic Categorization**: Intelligently sorts files into 8 predefined categories
- **Dry-Run Mode**: Preview changes before actually moving files
- **Interactive Confirmation**: Prompts for user confirmation before organizing
- **Duplicate Handling**: Automatically renames files to avoid overwrites
- **Fast Performance**: Written in Odin for blazing-fast execution
- **Safe Operations**: Non-destructive file moves (no data loss)
- **Detailed Output**: Shows file counts and operations clearly

## 📦 Categories

Files are automatically organized into the following categories:

| Category | File Extensions |
|----------|----------------|
| **Images** | `.jpg`, `.jpeg`, `.png`, `.gif`, `.bmp`, `.svg`, `.webp` |
| **Documents** | `.pdf`, `.doc`, `.docx`, `.txt`, `.md`, `.rtf`, `.odt` |
| **Archives** | `.zip`, `.tar`, `.gz`, `.rar`, `.7z`, `.bz2` |
| **Videos** | `.mp4`, `.avi`, `.mkv`, `.mov`, `.wmv`, `.flv` |
| **Audio** | `.mp3`, `.wav`, `.flac`, `.ogg`, `.aac`, `.m4a` |
| **Applications** | `.exe`, `.dmg`, `.app`, `.deb`, `.rpm`, `.msi` |
| **Code** | `.py`, `.go`, `.rs`, `.c`, `.cpp`, `.h`, `.odin`, `.js`, `.ts` |
| **Other** | All other file types |

## 🛠️ Installation

### Prerequisites

- [Odin Compiler](https://odin-lang.org/) installed on your system
- Linux, macOS, or Windows

### Build from Source

1. **Clone or navigate to the project directory:**
   ```bash
   cd /path/to/file-organizer
   ```

2. **Build the executable:**
   ```bash
   odin build main.odin -file -out:organize
   ```

3. **Make it executable (Linux/macOS):**
   ```bash
   chmod +x organize
   ```

4. **(Optional) Install globally:**
   ```bash
   # Linux/macOS
   sudo cp organize /usr/local/bin/
   
   # Or add to your PATH
   export PATH=$PATH:/path/to/file-organizer
   ```

## 📖 Usage

### Basic Syntax

```bash
./organize <directory> [--dry-run]
```

### Options

- `<directory>` - Path to the directory you want to organize (required)
- `--dry-run` - Preview changes without actually moving files (optional)

### Examples

#### 1. Preview Organization (Recommended First Step)

```bash
./organize ~/Downloads --dry-run
```

**Output:**
```
 Found 15 files in 4 categories:
  📁 Images         (5 files)
  📁 Documents      (7 files)
  📁 Videos         (2 files)
  📁 Archives       (1 files)

[DRY RUN - no files were moved, No files were moved.]

 Would create: Images/
  Move: photo1.jpg -> Images/photo1.jpg
  Move: screenshot.png -> Images/screenshot.png
  ...
```

#### 2. Organize Files

```bash
./organize ~/Downloads
```

**Output:**
```
 Found 15 files in 4 categories:
  📁 Images         (5 files)
  📁 Documents      (7 files)
  📁 Videos         (2 files)
  📁 Archives       (1 files)

Proceed with organization? (y/n): y

✓ Successfully organized 15 files!
```

#### 3. Organize Desktop

```bash
./organize ~/Desktop
```

#### 4. Organize Current Directory

```bash
./organize .
```

#### 5. Organize with Absolute Path

```bash
./organize /home/user/messy-folder
```

## 🔒 Safety Features

### Non-Destructive Operations

- **No Data Loss**: Files are moved, not copied or deleted
- **Duplicate Protection**: If a file with the same name exists in the destination, `_copy` is appended to the filename
- **Interactive Confirmation**: Asks for confirmation before making changes (unless in dry-run mode)
- **Error Handling**: Gracefully handles permission errors and invalid directories

### What Gets Organized

- ✅ **Only files** in the specified directory
- ❌ **Subdirectories are ignored** (not moved or organized)
- ❌ **Hidden files** (starting with `.`) are not processed

## 🏗️ Project Structure

```
file-organizer/
├── main.odin          # Main source code
├── README.md          # This documentation
└── organize           # Compiled executable (after build)
```

## 🧩 Code Structure

### Main Components

1. **`File_Info` Struct**: Stores metadata about each file
2. **`main()` Procedure**: Entry point, handles command-line arguments
3. **`organize_directory()` Procedure**: Orchestrates the organization process
4. **`list_files()` Procedure**: Scans directory and collects file information
5. **`categorize()` Procedure**: Determines file category based on extension
6. **`move_files()` Procedure**: Performs actual file moving operations
7. **`print_usage()` Procedure**: Shows help message

### Key Data Structures

```odin
File_Info :: struct {
    name:          string,  // Filename
    path:          string,  // Full file path
    size:          int,     // File size in bytes
    modified_date: string,  // Last modification time
    extension:     string,  // File extension
    category:      string,  // Assigned category
}
```

## 🎯 Use Cases

### Personal Use

- **Downloads Folder**: Automatically organize downloaded files
- **Desktop Cleanup**: Sort desktop clutter into organized folders
- **Photo Management**: Separate images from other files
- **Project Files**: Organize mixed project directories

### Professional Use

- **Server Cleanup**: Organize uploaded files on servers
- **Backup Organization**: Sort backup files by type
- **Data Migration**: Prepare files for migration by type
- **Archive Management**: Organize old files before archiving

## ⚡ Performance

- **Fast Scanning**: Efficient directory traversal
- **Memory Efficient**: Minimal memory footprint
- **Instant Categorization**: Quick pattern matching
- **Batch Operations**: Handles thousands of files efficiently

## 🐛 Troubleshooting

### "Error: Not a directory"

**Problem**: The path provided is not a valid directory.

**Solution**: 
```bash
# Check if path exists
ls -ld /path/to/directory

# Use absolute path
./organize /absolute/path/to/directory
```

### "Error opening directory"

**Problem**: Permission denied or directory doesn't exist.

**Solution**:
```bash
# Check permissions
ls -l /path/to/directory

# Fix permissions
chmod 755 /path/to/directory
```

### "Failed to move: filename.ext"

**Problem**: Permission issues or disk space problems.

**Solution**:
- Check write permissions in the target directory
- Verify available disk space
- Ensure the file isn't open in another program

### No Files Organized

**Problem**: Directory only contains subdirectories or hidden files.

**Solution**: File Organizer only processes regular files, not directories or hidden files (starting with `.`).


