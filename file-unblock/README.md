# Unblock Scripts

This folder contains utilities to remove the "blocked" status from files downloaded from the internet on Windows systems.
Blocking often occurs for files from untrusted sources and can prevent execution, editing, or cause warning prompts.

---
## How to Use

1. Copy or move the script into the **top-level folder** of the directory you want to unblock.
2. Run the script. It will recursively scan all files and subfolders in the current directory and remove the "blocked" status.

⚠️ **Important Warning:**  
Do **not** run the script with **administrator privileges**, as it will default to running in the `System32` directory, potentially unblocking unintended system files. Always run it as a regular user from the intended folder.


---

## Script Overview

### `Unblock.bat`
A basic batch script that recursively unblocks files in the current directory. It provides **verbose output**, showing each file being processed.

![file-unblock/Images/unblockbat.png](https://raw.githubusercontent.com/emman-j/Scripts/refs/heads/main/file-unblock/Images/unblockbat.png)


### `Unblock_PS.bat`

A batch script that runs the same logic as `Unblock.bat`, but with a **PowerShell-based progress bar** instead of detailed log output.
It offers a more user-friendly visual experience while processing multiple files.

![file-unblock/Images/unblockps1.png](https://raw.githubusercontent.com/emman-j/Scripts/refs/heads/main/file-unblock/Images/unblockps1.png)
![file-unblock/Images/unblockps2.png](https://raw.githubusercontent.com/emman-j/Scripts/refs/heads/main/file-unblock/Images/unblockps2.png)

---

## ⚠️ Note

- These scripts are intended for Windows environments only.
- Run with appropriate permissions if files are in protected locations.
