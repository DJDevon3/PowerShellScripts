# SPDX-FileCopyrightText: 2024 DJDevon3
#
# SPDX-License-Identifier: MIT
# Attribution: ChatGPT https://chat.openai.com/share/4fe18cf7-4199-431f-b4de-60a8e5a2c232

# ------------- Choose directory pathing option ----------------
# Script will run on the directory you choose and all subdirectories within.

# Option 1: Run in the same directory as this file (drag/drop/run)
#$folderPath = $PSScriptRoot

# Option 2: Set the folder path manually
$username = $env:USERNAME
$folderPath = "C:\Users\$username\Documents\GitHub\Adafruit_CircuitPython_Requests\"

# Change to the desired directory. Uses Option 1 or 2 automatically as both use the same variable folderPath.
Set-Location -Path $folderPath

# ----------------- Gather environment info ----------------------
$currentDate = Get-Date -Format "yyyy-MM-dd"
$psVersion = $PSVersionTable.PSVersion

# ----------------- Begin Script Output ---------------------------
# echo/print version info
Write-Host "Date: $currentDate"
Write-Host "PowerShell version: $($psVersion.Major).$($psVersion.Minor)"
Write-Host ""

# Get a list of .py files in the repo directory and included subdirectories
$pyFiles = Get-ChildItem -Path $folderPath -Filter *.py -Recurse

Write-Host "------------------------ CONVERTING LINE ENDINGS (EOL) TO LF ------------------------"
Write-Host ""

# Powershell will loop through each .py file converting CRLF to LF.
foreach ($file in $pyFiles) {
    # Setup ignored .py files here. 'conf.py' for example. We'e only cleaning up .py files.
    if ($file.Name -eq 'conf.py') {
        Write-Host "Ignored: $($file.FullName): File named 'conf.py' is ignored."
	Write-Host ""
        continue
    }

    # Read the content of the file
    $content = Get-Content -Path $file.FullName -Raw

    # Replace CRLF line endings with LF using ASCII ordinal values
    $content = $content -replace "`r`n", "`n"

    # Write the modified content back to the file
    Set-Content -Path $file.FullName -Value $content

    Write-Host "EOL's converted to LF for $($file.FullName)"
    Write-Host ""
}

# Keep the PowerShell window open after completing to inspect for any errors.
Write-Host "Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
