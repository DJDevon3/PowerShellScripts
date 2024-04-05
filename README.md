# PowerShellScripts
My PowerShell Scripts

1. AutoLF.ps1
   - Automated way to remove CRLF line endings and replace with LF line endings for any .py file in a directory and child directories.  Designed for running on local Github repositories.

2. AutoLF_Pre-Commmit.ps1
   - Automates CRLF to LF conversion, black formatting, reuse formatting, and pre-commit (with Pylint). Designed for running local Adafruit Github repositories for Windows Github Desktop users. They require all of these things to pass a pre-commit check to submit a PR.
