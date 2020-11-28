# Test envs are set
if (($env:GIT_SYNC_REPO -notlike "git@*") -OR ($env:GIT_SYNC_REPO -notlike "*.git")) {
    $ErrorActionPreference = "Stop"
    throw "Only ssh is supported for GIT_SYNC_REPO for now."
}
if (-not (Test-Path (Join-Path $env:GIT_SYNC_DEST "info.txt" -PathType Container))) {
    $ErrorActionPreference = "Stop"
    throw "GIT_SYNC_DEST folder not found. Make sure you create an info.txt in your GIT_SYNC_DEST folder, so we can test if it's correctly mounted."
}

$gitRepoUrl = $env:GIT_SYNC_REPO
$gitSourceDirectory = $env:GIT_SYNC_DEST
$gitFolderName = ($gitRepoUrl -replace ".git") -split "/" | Select-Object -Last 1
$gitDirectory = Join-Path $gitSourceDirectory $gitFolderName

if (Test-Path (Join-Path $gitDirectory ".ssh" -PathType Container)) {
    Write-Host "$gitDirectory is already cloned, updating..."
    Set-Location $gitDirectory
    git pull
} else {
    Write-Host "Cloning $gitRepoUrl to $gitDirectory..."
    Set-Location $gitSourceDirectory
    git clone $gitRepoUrl
}

while ($true) {
    Start-Sleep -Seconds 60
}