# File Organizer - Windows Edition

A simple, fast file organizer for Windows that automatically sorts your files into categories.

## 🚀 Quick Start

### Method 1: Drag and Drop (Easiest)
1. Extract all files from the ZIP to a folder
2. Drag any folder you want to organize onto `organize.bat`
3. Follow the prompts

### Method 2: PowerShell (Interactive)
1. Extract all files from the ZIP to a folder
2. Right-click `organize.ps1` and select "Run with PowerShell"
3. Enter the path of the folder you want to organize
4. Choose whether to do a dry run first

### Method 3: Command Line
```cmd
organize.exe C:\Users\YourName\Downloads
organize.exe C:\Users\YourName\Desktop --dry-run
```

## 📁 File Categories

Files are automatically organized into these folders:

- **Images** - JPG, PNG, GIF, BMP, SVG, WebP
- **Documents** - PDF, DOC, DOCX, TXT, MD, RTF
- **Archives** - ZIP, RAR, 7Z, TAR, GZ
- **Videos** - MP4, AVI, MKV, MOV, WMV
- **Audio** - MP3, WAV, FLAC, OGG, AAC
- **Applications** - EXE, MSI, DMG, DEB
- **Code** - PY, JS, GO, RS, C, CPP, ODIN
- **Other** - Everything else

## 💡 Tips for Windows Users

### Running from File Explorer
- **Double-click issues?** If double-clicking `organize.exe` opens and closes immediately, use `organize.bat` instead
- **Add to PATH:** Copy `organize.exe` to a folder in your PATH to use it from anywhere
- **Create shortcuts:** Right-click `organize.bat` → Send to → Desktop to create a shortcut

### Common Paths on Windows
```cmd
# Organize Downloads folder
organize.exe %USERPROFILE%\Downloads

# Organize Desktop
organize.exe %USERPROFILE%\Desktop

# Organize current folder
organize.exe .

# Preview without moving files
organize.exe C:\path\to\folder --dry-run
```

### PowerShell Examples
```powershell
# Using the PowerShell wrapper
.\organize.ps1 "$env:USERPROFILE\Downloads"
.\organize.ps1 "D:\MyFiles" -DryRun

# Direct executable usage in PowerShell
.\organize.exe $env:USERPROFILE\Downloads
```

## ⚠️ Important Notes

1. **Dry Run First**: Always use `--dry-run` on important folders to preview changes
2. **Duplicate Handling**: If a file with the same name exists, it will be renamed with "_copy" suffix
3. **No Undo**: There's no built-in undo function - the program moves files directly
4. **Subfolder Safety**: Only organizes files in the specified folder, not subfolders

## 🔧 Troubleshooting

### "The program closes immediately"
- Use `organize.bat` instead of the .exe directly
- Or run from Command Prompt/PowerShell to see the output

### "Access Denied" errors
- Run as Administrator if organizing system folders
- Check that files aren't in use by other programs

### "Not a directory" error
- Make sure you're providing a folder path, not a file path
- Use quotes around paths with spaces: `"C:\My Folder\"`

### Windows Defender Warning
- The executable is unsigned, so Windows may show a warning
- Click "More info" → "Run anyway" if you trust the source
- Or build from source using the included `main.odin` file

## 🛠️ Building from Source

If you prefer to build the executable yourself:

1. Install Odin compiler: https://odin-lang.org/
2. Open Command Prompt in the extracted folder
3. Run: `odin build main.odin -out:organize.exe -o:speed`

## 📝 Command Reference

```
organize.exe <directory>              # Organize files
organize.exe <directory> --dry-run    # Preview without moving

organize.bat                          # Interactive mode
organize.bat <directory>              # Organize with prompts

organize.ps1                          # PowerShell interactive
organize.ps1 -Path <directory>        # Direct organization
organize.ps1 -Path <directory> -DryRun # Preview mode
```

## 🤝 Support

For issues or questions:
- Check the troubleshooting section above
- Run with `--dry-run` to test safely
- Ensure you have read/write permissions for the target folder

---

Made with Odin | Fast, Simple, Effective File Organization