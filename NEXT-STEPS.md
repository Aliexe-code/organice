# 🎯 How to Get a Windows .exe (Standalone)

You can't build Windows `.exe` directly from Linux, but here's the **easiest solution**:

## ✅ RECOMMENDED: GitHub Actions (100% Free & Automatic)

I've already set up everything you need. Just follow these steps:

### Step 1: Create GitHub Repository

1. Go to https://github.com/new
2. Name it: `file-organizer`
3. Keep it public (or private)
4. Don't initialize with README (you already have one)
5. Click "Create repository"

### Step 2: Push Your Code

```bash
cd /home/ali/Projects/vlnag-test/file-organizer

# Initialize git
git init

# Add all files
git add .

# Commit
git commit -m "File Organizer v1.0.0 with multi-platform builds"

# Add GitHub remote (replace YOURUSERNAME with your GitHub username)
git branch -M main
git remote add origin https://github.com/YOURUSERNAME/file-organizer.git

# Push
git push -u origin main
```

### Step 3: Create a Release Tag

```bash
# Tag version 1.0.0
git tag v1.0.0

# Push the tag
git push origin v1.0.0
```

### Step 4: Wait for GitHub Actions

1. Go to: `https://github.com/YOURUSERNAME/file-organizer/actions`
2. You'll see the build running (takes ~5-10 minutes)
3. When done (green checkmark), go to: `https://github.com/YOURUSERNAME/file-organizer/releases`

### Step 5: Download Your Windows .exe!

You'll find:
- ✅ `file-organizer-windows-x64.zip` - **Contains organize.exe** (standalone!)
- ✅ `file-organizer-linux-x64.tar.gz` - Contains organize (Linux)
- ✅ `file-organizer-macos-x64.tar.gz` - Contains organize (macOS)

**All are standalone - no installation needed!**

---

## 📦 What Users Get

After you share the GitHub release link:

**Windows users:**
```batch
1. Download file-organizer-windows-x64.zip
2. Extract it
3. Double-click organize.exe
4. Done! No installation needed.
```

**Linux users:**
```bash
1. Download file-organizer-linux-x64.tar.gz
2. tar -xzf file-organizer-linux-x64.tar.gz
3. ./organize ~/Downloads --dry-run
4. Done! No installation needed.
```

**macOS users:**
```bash
1. Download file-organizer-macos-x64.tar.gz
2. tar -xzf file-organizer-macos-x64.tar.gz
3. ./organize ~/Downloads --dry-run
4. Done! No installation needed.
```

---

## 🔄 For Future Updates

Whenever you make changes:

```bash
cd /home/ali/Projects/vlnag-test/file-organizer

# Make your changes to main.odin
nano main.odin

# Commit changes
git add .
git commit -m "Add new feature"
git push

# Create new release
git tag v1.1.0
git push origin v1.1.0
```

GitHub Actions automatically rebuilds for all platforms!

---

## 🎉 Done!

After Step 5, you'll have:
- ✅ Windows `.exe` (standalone)
- ✅ Linux binary (standalone)
- ✅ macOS binary (standalone)

All built automatically, all free, all standalone!

**No Odin needed for end users on any platform.**

---

## Alternative: Manual Windows Build

If you don't want to use GitHub:
- See `BUILD-WINDOWS.md` for other options (local VM, cloud VM, etc.)
- But GitHub Actions is by far the easiest!

---

**Questions? The GitHub Actions workflow is already set up at:**
`.github/workflows/build.yml`

Just push your code and create a tag. GitHub does the rest! 🚀
