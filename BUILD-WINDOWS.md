# Building Windows Standalone Executable

Since you're on Linux and cross-compilation doesn't work, here are your options to create a standalone Windows `.exe`:

## Option 1: GitHub Actions (Recommended - FREE & AUTOMATIC)

**Best solution**: Use GitHub Actions to automatically build for Windows, Linux, and macOS.

### Setup (One Time):

1. **Push your code to GitHub:**
   ```bash
   cd /home/ali/Projects/vlnag-test
   git init
   git add .
   git commit -m "Initial commit"
   git branch -M main
   git remote add origin https://github.com/yourusername/file-organizer.git
   git push -u origin main
   ```

2. **The workflow is already created** at `.github/workflows/build.yml`

3. **Create a release:**
   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```

4. **GitHub Actions will automatically:**
   - Build for Windows (`.exe`)
   - Build for Linux
   - Build for macOS
   - Create release packages
   - Upload to GitHub Releases

**Result**: Standalone Windows `.exe` that users can download - NO installation needed!

---

## Option 2: Use a Free Windows VM/Cloud Service

### A. GitHub Codespaces (Free)
1. Go to your GitHub repo
2. Click "Code" → "Codespaces" → "New codespace"
3. Select Windows environment
4. Build:
   ```batch
   odin build main.odin -file -out:organize.exe -o:speed -no-bounds-check
   ```

### B. Azure Free Tier (Free for 12 months)
1. Sign up: https://azure.microsoft.com/free/
2. Create Windows VM (B1s is free)
3. Install Odin
4. Build your binary

### C. AWS EC2 Free Tier (Free for 12 months)
1. Sign up: https://aws.amazon.com/free/
2. Launch Windows instance (t2.micro is free)
3. Install Odin
4. Build your binary

---

## Option 3: VirtualBox/QEMU Windows VM (Local)

### Setup:

1. **Download Windows 11 Dev VM (FREE):**
   ```bash
   # Download from Microsoft (legal and free):
   wget https://aka.ms/windev_VM_virtualbox
   ```
   Or get from: https://developer.microsoft.com/en-us/windows/downloads/virtual-machines/

2. **Install VirtualBox:**
   ```bash
   sudo pacman -S virtualbox  # or your distro's package manager
   ```

3. **Import the VM and start it**

4. **Inside Windows VM:**
   ```batch
   # Download Odin
   # From: https://github.com/odin-lang/Odin/releases
   
   # Copy your main.odin to the VM
   # Build
   odin build main.odin -file -out:organize.exe -o:speed -no-bounds-check
   ```

5. **Copy `organize.exe` back to Linux**

---

## Option 4: Wine + Odin (Experimental)

**May work, but not guaranteed:**

```bash
# Install Wine
sudo pacman -S wine

# Download Windows Odin build
wget https://github.com/odin-lang/Odin/releases/latest/download/odin-windows-amd64.zip
unzip odin-windows-amd64.zip

# Try building
wine odin.exe build main.odin -file -out:organize.exe
```

⚠️ This is hit-or-miss. GitHub Actions (Option 1) is more reliable.

---

## Option 5: Ask a Friend with Windows

1. Send them `main.odin`
2. They run:
   ```batch
   odin build main.odin -file -out:organize.exe -o:speed -no-bounds-check
   ```
3. They send you back `organize.exe`

---

## Comparison:

| Method | Cost | Time | Automation | Reliability |
|--------|------|------|------------|-------------|
| **GitHub Actions** | ✅ Free | ⏱️ 5 min setup | ✅ Automatic | ✅✅✅ High |
| **Cloud VM** | ⚠️ Free tier | ⏱️ 15 min | ❌ Manual | ✅✅ Medium |
| **Local VM** | ✅ Free | ⏱️ 30 min | ❌ Manual | ✅✅ Medium |
| **Wine** | ✅ Free | ⏱️ 10 min | ❌ Manual | ⚠️ Low |
| **Friend** | ✅ Free | ⏱️ ? | ❌ Manual | ✅ Depends |

---

## Recommended Approach: GitHub Actions

**Why?**
- ✅ Completely free
- ✅ Automatic builds for all platforms
- ✅ Professional CI/CD setup
- ✅ Users get verified releases
- ✅ No VM management needed
- ✅ Builds Windows, Linux, AND macOS

**Setup Steps:**

```bash
cd /home/ali/Projects/vlnag-test

# Create GitHub repo first on github.com, then:
git init
git add .
git commit -m "Add file organizer with multi-platform builds"
git branch -M main
git remote add origin https://github.com/YOURUSERNAME/file-organizer.git
git push -u origin main

# Create release tag
git tag v1.0.0
git push origin v1.0.0

# GitHub Actions will automatically build Windows .exe!
# Check: https://github.com/YOURUSERNAME/file-organizer/actions
```

After a few minutes, you'll have:
- ✅ `organize.exe` for Windows (standalone)
- ✅ `organize` for Linux (standalone)
- ✅ `organize` for macOS (standalone)

All available in GitHub Releases - users just download and run!

---

## Testing the Windows .exe

Once you have it, test in Wine:

```bash
wine organize.exe
wine organize.exe C:\\Users\\Public --dry-run
```

Or get a friend to test on real Windows.

---

## Result

With GitHub Actions, **every time you create a release tag**, you automatically get standalone executables for:
- Windows (organize.exe) - ~200 KB
- Linux (organize) - ~187 KB  
- macOS (organize) - ~200 KB

**No installation required for users on any platform!**

---

**Need help setting this up? Let me know!**
