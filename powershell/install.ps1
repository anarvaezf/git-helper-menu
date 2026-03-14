Write-Host ""
Write-Host "Installing git-helper-menu for PowerShell..."
Write-Host ""

$RepoUrl = "https://github.com/anarvaezf/git-helper-menu.git"
$InstallPath = "$HOME\.git-helper-menu"

if (!(Test-Path $InstallPath)) {
    git clone $RepoUrl $InstallPath
} else {
    Write-Host "Repository already exists. Pulling latest changes..."
    cd $InstallPath
    git pull
}

$ProfilePath = $PROFILE

if (!(Test-Path $ProfilePath)) {
    Write-Host "Creating PowerShell profile..."
    New-Item -ItemType File -Path $ProfilePath -Force | Out-Null
}

$LoadLine = ". `"$InstallPath\powershell\git-helpers.ps1`""

$ProfileContent = Get-Content $ProfilePath -ErrorAction SilentlyContinue

if ($ProfileContent -notcontains $LoadLine) {
    Add-Content $ProfilePath ""
    Add-Content $ProfilePath "# Git Helper Menu"
    Add-Content $ProfilePath $LoadLine
}

Write-Host ""
Write-Host "Installation complete."
Write-Host "Reload your profile with:"
Write-Host ""
Write-Host ". `$PROFILE"
Write-Host ""
Write-Host "Then open the menu with:"
Write-Host "Ctrl + G"
Write-Host ""