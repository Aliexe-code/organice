# File Organizer - PowerShell Wrapper
# A modern Windows wrapper for the file organizer

param(
    [Parameter(Position=0)]
    [string]$Path,

    [Parameter()]
    [switch]$DryRun
)

$ErrorActionPreference = "Stop"

# Colors for better output
$Host.UI.RawUI.WindowTitle = "File Organizer"

function Write-ColorOutput($ForegroundColor, $Text) {
    $fc = $host.UI.RawUI.ForegroundColor
    $host.UI.RawUI.ForegroundColor = $ForegroundColor
    Write-Output $Text
    $host.UI.RawUI.ForegroundColor = $fc
}

# Check if organize.exe exists
$organizerPath = Join-Path $PSScriptRoot "organize.exe"
if (-not (Test-Path $organizerPath)) {
    Write-ColorOutput Red "ERROR: organize.exe not found in $PSScriptRoot"
    Write-ColorOutput Yellow "Please ensure organize.exe is in the same folder as this script."
    Write-Host "`nPress any key to exit..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 1
}

# If no path provided, show usage
if (-not $Path) {
    Write-ColorOutput Cyan @"

📁 File Organizer - Windows PowerShell
═══════════════════════════════════════

USAGE:
  From PowerShell:
    .\organize.ps1 "C:\path\to\folder"
    .\organize.ps1 "C:\path\to\folder" -DryRun

  From Windows Explorer:
    Right-click this script and select "Run with PowerShell"
    Then enter the path when prompted

EXAMPLES:
  .\organize.ps1 "$env:USERPROFILE\Downloads"
  .\organize.ps1 "$env:USERPROFILE\Desktop" -DryRun
  .\organize.ps1 "." (organize current folder)

"@

    # Interactive mode - ask for path
    Write-ColorOutput Yellow "Enter the path to organize (or press Enter to exit): "
    $Path = Read-Host

    if (-not $Path) {
        Write-Host "Exiting..."
        Start-Sleep -Seconds 1
        exit 0
    }

    # Ask about dry run
    Write-ColorOutput Yellow "`nDo you want to do a dry run first? (y/n): "
    $dryRunResponse = Read-Host
    if ($dryRunResponse -eq 'y' -or $dryRunResponse -eq 'Y') {
        $DryRun = $true
    }
}

# Validate path
if (-not (Test-Path $Path)) {
    Write-ColorOutput Red "ERROR: Path '$Path' does not exist."
    Write-Host "`nPress any key to exit..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 1
}

if (-not (Test-Path $Path -PathType Container)) {
    Write-ColorOutput Red "ERROR: Path '$Path' is not a directory."
    Write-Host "`nPress any key to exit..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 1
}

# Prepare arguments
$args = @($Path)
if ($DryRun) {
    $args += "--dry-run"
    Write-ColorOutput Yellow "`n🔍 Running in DRY RUN mode - no files will be moved`n"
} else {
    Write-ColorOutput Green "`n▶ Organizing files in: $Path`n"
}

# Run the organizer
Write-ColorOutput Cyan "════════════════════════════════════════`n"
& $organizerPath $args
$exitCode = $LASTEXITCODE

# Show completion message
Write-ColorOutput Cyan "`n════════════════════════════════════════"
if ($exitCode -eq 0) {
    Write-ColorOutput Green "✓ Operation completed successfully!"
} else {
    Write-ColorOutput Yellow "Operation completed with exit code: $exitCode"
}

# Keep window open
Write-Host "`nPress any key to close this window..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
