$InstallDir = "$HOME\.git-helper-menu"
$ScriptSource = "$PSScriptRoot\git-helpers.ps1"
$ScriptTarget = "$InstallDir\git-helpers.ps1"

Write-Host "Installing git-helper-menu..."

if (!(Test-Path $InstallDir)) {
    New-Item -ItemType Directory -Path $InstallDir | Out-Null
}

Copy-Item $ScriptSource $ScriptTarget -Force

if (!(Test-Path $PROFILE)) {
    New-Item -ItemType File -Path $PROFILE -Force | Out-Null
}

$SourceLine = ". `"$ScriptTarget`""

$ProfileContent = Get-Content $PROFILE -ErrorAction SilentlyContinue

if ($ProfileContent -notcontains $SourceLine) {
    Add-Content $PROFILE ""
    Add-Content $PROFILE "# Git Helper Menu"
    Add-Content $PROFILE $SourceLine
    Write-Host "Added git helpers to PowerShell profile."
}
else {
    Write-Host "git helpers already configured in profile."
}

Write-Host ""
Write-Host "Installation complete."
Write-Host ""
Write-Host "Reload your profile with:"
Write-Host ""
Write-Host ". `$PROFILE"
Write-Host ""
Write-Host "Then press Ctrl + G to open the menu."