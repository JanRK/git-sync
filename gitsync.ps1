while ($env:PAUSE -eq "True") {
    Start-Sleep -Seconds 60
}

$gitRepoUrl = $env:GIT_SYNC_REPO
$gitSourceDirectory = $env:GIT_SYNC_DEST
$gitFolderName = ($gitRepoUrl -replace ".git") -split "/" | Select-Object -Last 1
$gitDirectory = Join-Path $gitSourceDirectory $gitFolderName

# Test envs are set
if (($gitRepoUrl -notlike "git@*") -OR ($gitRepoUrl -notlike "*.git")) {
    $ErrorActionPreference = "Stop"
    throw "Only ssh is supported for GIT_SYNC_REPO for now. Currently set to $gitRepoUrl"
}
if (-not (Test-Path (Join-Path $gitSourceDirectory "info.txt") -PathType Leaf)) {
    Get-ChildItem $gitSourceDirectory
    $ErrorActionPreference = "Stop"
    throw "GIT_SYNC_DEST - $gitSourceDirectory folder not found. Make sure you create an info.txt in your GIT_SYNC_DEST folder, so we can test if it's correctly mounted."
}

if (Test-Path (Join-Path $gitDirectory ".git") -PathType Container) {
    Write-Host "$gitDirectory is already cloned, updating..."
    Set-Location $gitDirectory
    git pull
} else {
    Write-Host "Cloning $gitRepoUrl to $gitDirectory..."
    Set-Location $gitSourceDirectory
    git clone $gitRepoUrl
}
