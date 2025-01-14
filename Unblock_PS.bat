@echo off

REM Define the Base64-encoded PowerShell script
REM I cannot for the life of me output a ps script using plain text here without error and this is easier than escaping as well
REM
REM ----------------------------------------------
REM PowerShell Script to Unblock Files Recursively
REM ----------------------------------------------
REM # Get all files recursively in the current directory
REM $files = Get-ChildItem -Recurse -File -Force
REM
REM # Total number of files
REM $total = $files.Count
REM if ($total -eq 0) {
REM     Write-Host "No files found to unblock." -ForegroundColor Yellow
REM     exit
REM }
REM
REM # Confirmation prompt
REM $confirmation = Read-Host "Proceed with unblocking $total files? (Y/N)"
REM if ($confirmation -ne 'Y') {
REM     Write-Host "Unblocking cancelled."
REM     exit
REM }
REM
REM # Unblock files with progress bar
REM for ($i = 0; $i -lt $total; $i++) {
REM     $file = $files[$i]
REM     Unblock-File -Path $file.FullName
REM
REM     # Update progress bar
REM     Write-Progress -Activity "Unblocking files..." `
REM                    -Status "Processing $($file.Name)" `
REM                    -PercentComplete (($i + 1) / $total * 100)
REM }
REM
REM Write-Host "Unblocking completed." -ForegroundColor Green

REM Define the script
set "encoded_script=IyBHZXQgYWxsIGZpbGVzIHJlY3Vyc2l2ZWx5IGluIHRoZSBjdXJyZW50IGRpcmVjdG9yeQokZmlsZXMgPSBHZXQtQ2hpbGRJdGVtIC1SZWN1cnNlIC1GaWxlIC1Gb3JjZQoKIyBUb3RhbCBudW1iZXIgb2YgZmlsZXMKJHRvdGFsID0gJGZpbGVzLkNvdW50CmlmICgkdG90YWwgLWVxIDApIHsKICAgIFdyaXRlLUhvc3QgIk5vIGZpbGVzIGZvdW5kIHRvIHVuYmxvY2suIiAtRm9yZWdyb3VuZENvbG9yIFllbGxvdwogICAgZXhpdAp9CgojIENvbmZpcm1hdGlvbiBwcm9tcHQKJGNvbmZpcm1hdGlvbiA9IFJlYWQtSG9zdCAiUHJvY2VlZCB3aXRoIHVuYmxvY2tpbmcgJHRvdGFsIGZpbGVzPyAoWS9OKSIKaWYgKCRjb25maXJtYXRpb24gLW5lICdZJykgewogICAgV3JpdGUtSG9zdCAiVW5ibG9ja2luZyBjYW5jZWxsZWQuIgogICAgZXhpdAp9CgojIFVuYmxvY2sgZmlsZXMgd2l0aCBwcm9ncmVzcyBiYXIKZm9yICgkaSA9IDA7ICRpIC1sdCAkdG90YWw7ICRpKyspIHsKICAgICRmaWxlID0gJGZpbGVzWyRpXQogICAgVW5ibG9jay1GaWxlIC1QYXRoICRmaWxlLkZ1bGxOYW1lCgogICAgIyBVcGRhdGUgcHJvZ3Jlc3MgYmFyCiAgICBXcml0ZS1Qcm9ncmVzcyAtQWN0aXZpdHkgIlVuYmxvY2tpbmcgZmlsZXMuLi4iIGAKICAgICAgICAgICAgICAgICAgIC1TdGF0dXMgIlByb2Nlc3NpbmcgJCgkZmlsZS5OYW1lKSIgYAogICAgICAgICAgICAgICAgICAgLVBlcmNlbnRDb21wbGV0ZSAoKCRpICsgMSkgLyAkdG90YWwgKiAxMDApCn0KCldyaXRlLUhvc3QgIlVuYmxvY2tpbmcgY29tcGxldGVkLiIgLUZvcmVncm91bmRDb2xvciBHcmVlbgo="

REM Create the PowerShell script from Base64 string
echo %encoded_script% | powershell -Command "$encodedScript = [System.Text.Encoding]::UTF8.GetString([Convert]::FromBase64String('%encoded_script%')); $encodedScript | Set-Content -Path 'unblock_ps.ps1'"

REM Execute the decoded PowerShell script
powershell -ExecutionPolicy Bypass -File unblock_ps.ps1

REM Optionally delete the decoded script after execution
del unblock_ps.ps1

pause
