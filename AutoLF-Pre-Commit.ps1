# SPDX-FileCopyrightText: 2024 DJDevon3
#
# SPDX-License-Identifier: MIT
# Attribution: ChatGPT https://chat.openai.com/share/4fe18cf7-4199-431f-b4de-60a8e5a2c232

# ------------- Choose directory pathing option ----------------
# Option 1: Run in the same directory as this file (drag/drop/run)
#$folderPath = $PSScriptRoot

# Option 2: Set the folder path manually
# folderPath should be the top level repository directory, not a subdirectory.
# good example C:\Users\$username\Documents\GitHub\Adafruit_CircuitPython_Requests\
# bad example C:\Users\$username\Documents\GitHub\Adafruit_CircuitPython_Requests\wifi\api\expanded

$username = $env:USERNAME
$folderPath = "C:\Users\$username\Documents\GitHub\Adafruit_CircuitPython_Requests\"

# Change to the desired directory. Uses Option 1 or 2 automatically as both use the same variable folderPath.
Set-Location -Path $folderPath

# ----------------- Gather environment info ----------------------
$currentDate = Get-Date -Format "yyyy-MM-dd"
$pythonVersion = & python --version 2>&1
$preCommitVersion = & pre-commit --version 2>&1
$blackVersion = & black --version 2>&1
$reuseVersion = & reuse --version 2>&1

# ----------------- Begin Script Output ---------------------------
# echo/print version info
Write-Host "Date: $currentDate"
Write-Host "Python: $pythonVersion"
Write-Host "pre-commit: $preCommitVersion"
Write-Host "black: $blackVersion"
Write-Host "reuse: $reuseVersion"
Write-Host ""

Write-Host "----- Attempting pre-commit install on ($folderPath) -----"
# This will do nothing if it's previously been run.
try {
    & 'pre-commit' install --install-hooks --overwrite
} catch {
    Write-Host "Error installing pre-commit hooks in the directory: $_"
}
Write-Host ""

Write-Host "----- PIP INSTALL --UPGRADE REUSE -----"
# This will do nothing if it's already up-to-date.
try {
    & pip install --upgrade reuse
} catch {
    Write-Host "Error upgrading reuse tool: $_"
}
Write-Host ""

# Get a list of .py files in the repo directory and included subdirectories
$pyFiles = Get-ChildItem -Path $folderPath -Filter *.py -Recurse

Write-Host "------ Convert line endings to LF then format with black ------"
Write-Host ""

# Powershell will loop through each .py file converting CRLF to LF.
foreach ($file in $pyFiles) {
    # Setup ignored .py files here. 'conf.py' for example. We'e only cleaning up .py files.
    if ($file.Name -eq 'conf.py') {
        Write-Host "Skipping file $($file.FullName): File named 'conf.py' is ignored."
        continue
    }

    # Read the content of the file
    $content = Get-Content -Path $file.FullName -Raw

    # Replace CRLF line endings with LF using ASCII ordinal values
    $content = $content -replace "`r`n", "`n"

    # Write the modified content back to the file
    Set-Content -Path $file.FullName -Value $content

    Write-Host "EOL's converted to LF for $($file.FullName)"

    # Run black code formatter on the file
    try {
        & 'black' $file.FullName
    } catch {
        Write-Host "Error running black for $($file.FullName): $_"
    }
}

# Add a blank line
Write-Host ""

Write-Host "------------- PRE-COMMIT RUN --ALL-FILES -------------"
# Since all py files have already been changed to LF and formatted 
# there shouldn't be hundreds of line-ending errors on pre-commit.
# Pre-commit runs on all files in the repo not just py files
try {
    & 'pre-commit' run --all-files
} catch {
    Write-Host "Error running pre-commit for files in $($folderPath): $_"
}
Write-Host "-------------------------------------------------------------------------"

# Pause at the end to keep the PowerShell window open
Write-Host "Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
