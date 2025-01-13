# Prompt the user for file path
$FilePath = Read-Host "Enter the full file path"

# Prompt the user for reference SHA-256 hash
$ReferenceSHA256 = Read-Host "Enter the reference SHA-256 hash"

# Check if file exists
if (-Not (Test-Path $FilePath)) {
    Write-Host "Error: File '$FilePath' does not exist." -ForegroundColor Red
    Read-Host "Press Enter to exit..."
    exit 1
}

# Calculate the SHA-256 hash of the file
try {
    $CalculatedHash = Get-FileHash -Path $FilePath -Algorithm SHA256 | Select-Object -ExpandProperty Hash
} catch {
    Write-Host "Error: Unable to calculate hash. $($_.Exception.Message)" -ForegroundColor Red
    Read-Host "Press Enter to exit..."
    exit 1
}

# Compare calculated hash with the reference hash
if ($CalculatedHash -eq $ReferenceSHA256) {
    Write-Host "SHA-256 hash is correct!" -ForegroundColor Green
} else {
    Write-Host "SHA-256 hash is incorrect!" -ForegroundColor Red
    Write-Host "Calculated Hash: $CalculatedHash" -ForegroundColor Yellow
    Write-Host "Reference Hash:  $ReferenceSHA256" -ForegroundColor Yellow
}

# Wait for user input before exiting
Read-Host "Press Enter to exit..."
