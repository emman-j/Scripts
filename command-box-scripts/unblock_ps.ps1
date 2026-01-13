# @meta description=Unblocks file on the selected directory
# @meta usage=unblock [dir]

# ----------------------------------------------
# PowerShell Script to Unblock Files Recursively
# ----------------------------------------------

param(
    [string]$Path = (Get-Location).Path
)

# Verify the path exists
if (-not (Test-Path -Path $Path)) {
    Write-Host "Error: Path does not exist: $Path" -ForegroundColor Red
    exit 1
}

# Display target directory
Write-Host "Target directory: $Path" -ForegroundColor Cyan

# Get all files recursively in the specified directory
$files = Get-ChildItem -Path $Path -Recurse -File -Force

# Total number of files
$total = $files.Count

if ($total -eq 0) {
    Write-Host "No files found to unblock." -ForegroundColor Yellow
    exit
}

# Confirmation prompt
$confirmation = Read-Host "Proceed with unblocking $total files? (Y/N)"
if ($confirmation -ne 'Y') {
    Write-Host "Unblocking cancelled." -ForegroundColor Yellow
    exit
}

# Unblock files with progress bar
for ($i = 0; $i -lt $total; $i++) {
    $file = $files[$i]
    Unblock-File -Path $file.FullName
    
    # Update progress bar
    Write-Progress -Activity "Unblocking files..." `
                   -Status "Processing $($file.Name)" `
                   -PercentComplete (($i + 1) / $total * 100)
}

Write-Host "`nUnblocking completed: $total files processed." -ForegroundColor Green