function GitAdd {
    Write-Host "[GitAdd] Stage all changes (git add .)"
    git add .
}

function GitCommit {
    param(
        [Parameter(Mandatory = $false)]
        [string]$Message
    )

    if ([string]::IsNullOrWhiteSpace($Message)) {
        Write-Host '[GitCommit] Missing commit message.'
        Write-Host 'Usage: GitCommit "your message"'
        return
    }

    Write-Host "[GitCommit] Commit with message: $Message"
    git commit -m $Message
}

function GitNewBranch {
    param(
        [Parameter(Mandatory = $false)]
        [string]$BranchName
    )

    if ([string]::IsNullOrWhiteSpace($BranchName)) {
        Write-Host "[GitNewBranch] Missing branch name."
        Write-Host "Usage: GitNewBranch feature/branch-name"
        return
    }

    Write-Host "[GitNewBranch] Create and switch to branch: $BranchName"
    git switch -c $BranchName
}

function GitStatus {
    Write-Host "[GitStatus] Show repository status"
    git status -sb
}

function GitLast {
    Write-Host "[GitLast] Show last commit"
    git log -1
}

function GitLog {
    Write-Host "[GitLog] Show compact git history"
    git log --oneline --graph --decorate --all
}

function GitCurrent {
    Write-Host "[GitCurrent] Current branch"
    git branch --show-current
}

function GitQuickPush {
    Write-Host "[GitQuickPush] Amend last commit and force push with lease"
    git commit --amend --no-edit
    if ($LASTEXITCODE -ne 0) {
        return
    }

    git push --force-with-lease
}

function GitSync {
    Write-Host "[GitSync] Pull with rebase then push"
    git pull --rebase
    if ($LASTEXITCODE -ne 0) {
        return
    }

    git push
}

function GitCleanBranches {
    Write-Host "[GitCleanBranches] Delete local branches already merged into main"

    $branches = git branch --merged | ForEach-Object { $_.Trim() } | Where-Object {
        $_ -and $_ -ne "*" -and $_ -ne "main" -and $_ -notmatch '^\*'
    }

    foreach ($branch in $branches) {
        git branch -d $branch
    }
}

function GitRestore {
    Write-Host "[GitRestore] Unstage all staged files"
    git restore --staged .
}

function GitReset {
    Write-Host "[GitReset] HARD reset: remove all uncommitted changes and untracked files"
    git reset --hard HEAD
    if ($LASTEXITCODE -ne 0) {
        return
    }

    git clean -fd
}

function GitRebase {
    $previousBranch = (git branch --show-current).Trim()

    if ([string]::IsNullOrWhiteSpace($previousBranch)) {
        Write-Host "[GitRebase] Could not determine current branch"
        return
    }

    if ($previousBranch -eq "main") {
        Write-Host "[GitRebase] Already on main - updating"
        git fetch origin
        if ($LASTEXITCODE -ne 0) {
            return
        }

        git pull
        return
    }

    Write-Host "[GitRebase] Update main and rebase current branch onto main"

    git switch main
    if ($LASTEXITCODE -ne 0) {
        return
    }

    git fetch origin
    if ($LASTEXITCODE -ne 0) {
        return
    }

    git pull
    if ($LASTEXITCODE -ne 0) {
        return
    }

    git switch $previousBranch
    if ($LASTEXITCODE -ne 0) {
        return
    }

    git rebase main
}

function GitRebaseEdit {
    $previousBranch = (git branch --show-current).Trim()

    if ([string]::IsNullOrWhiteSpace($previousBranch)) {
        Write-Host "[GitRebaseEdit] Could not determine current branch"
        return
    }

    if ($previousBranch -eq "main") {
        Write-Host "[GitRebaseEdit] Already on main - updating"
        git fetch origin
        if ($LASTEXITCODE -ne 0) {
            return
        }

        git pull
        return
    }

    Write-Host "[GitRebaseEdit] Update main and interactive rebase"

    git switch main
    if ($LASTEXITCODE -ne 0) {
        return
    }

    git fetch origin
    if ($LASTEXITCODE -ne 0) {
        return
    }

    git pull
    if ($LASTEXITCODE -ne 0) {
        return
    }

    git switch $previousBranch
    if ($LASTEXITCODE -ne 0) {
        return
    }

    git rebase -i main
}

function GitFixup {
    param(
        [Parameter(Mandatory = $false)]
        [string]$CommitHash
    )

    if ([string]::IsNullOrWhiteSpace($CommitHash)) {
        Write-Host "[GitFixup] Missing commit hash"
        Write-Host "Usage: GitFixup <commit-hash>"
        return
    }

    Write-Host "[GitFixup] Create fixup commit for $CommitHash"
    git commit --fixup $CommitHash
}

function GitHelpers {
    $helpers = @(
        [PSCustomObject]@{ Name = "GitAdd";           Description = "Stage all changes (git add .)" }
        [PSCustomObject]@{ Name = "GitCommit";        Description = "Commit with message" }
        [PSCustomObject]@{ Name = "GitNewBranch";     Description = "Create and switch to new branch" }
        [PSCustomObject]@{ Name = "GitStatus";        Description = "Show repository status" }
        [PSCustomObject]@{ Name = "GitLast";          Description = "Show last commit" }
        [PSCustomObject]@{ Name = "GitLog";           Description = "Show compact commit history" }
        [PSCustomObject]@{ Name = "GitCurrent";       Description = "Show current branch" }
        [PSCustomObject]@{ Name = "GitQuickPush";     Description = "Amend last commit and force push" }
        [PSCustomObject]@{ Name = "GitSync";          Description = "Pull with rebase then push" }
        [PSCustomObject]@{ Name = "GitCleanBranches"; Description = "Delete merged local branches" }
        [PSCustomObject]@{ Name = "GitRestore";       Description = "Unstage all staged files" }
        [PSCustomObject]@{ Name = "GitReset";         Description = "Hard reset and remove untracked files" }
        [PSCustomObject]@{ Name = "GitRebase";        Description = "Rebase current branch onto main" }
        [PSCustomObject]@{ Name = "GitRebaseEdit";    Description = "Interactive rebase onto main" }
        [PSCustomObject]@{ Name = "GitFixup";         Description = "Create fixup commit" }
    )

    $helpers | Format-Table -AutoSize
}

function GitMenu {
    $items = @(
        [PSCustomObject]@{ Name = "GitAdd";           Description = "Stage all changes (git add .)";               RequiresInput = $false }
        [PSCustomObject]@{ Name = "GitCommit";        Description = "Commit with message";                         RequiresInput = $true  }
        [PSCustomObject]@{ Name = "GitNewBranch";     Description = "Create and switch to new branch";             RequiresInput = $true  }
        [PSCustomObject]@{ Name = "GitStatus";        Description = "Show repository status";                      RequiresInput = $false }
        [PSCustomObject]@{ Name = "GitLast";          Description = "Show last commit";                            RequiresInput = $false }
        [PSCustomObject]@{ Name = "GitLog";           Description = "Show compact commit history";                 RequiresInput = $false }
        [PSCustomObject]@{ Name = "GitCurrent";       Description = "Show current branch";                         RequiresInput = $false }
        [PSCustomObject]@{ Name = "GitQuickPush";     Description = "Amend last commit and force push";            RequiresInput = $false }
        [PSCustomObject]@{ Name = "GitSync";          Description = "Pull with rebase then push";                  RequiresInput = $false }
        [PSCustomObject]@{ Name = "GitCleanBranches"; Description = "Delete merged local branches";                RequiresInput = $false }
        [PSCustomObject]@{ Name = "GitRestore";       Description = "Unstage all staged files";                    RequiresInput = $false }
        [PSCustomObject]@{ Name = "GitReset";         Description = "Hard reset and remove untracked files";       RequiresInput = $false }
        [PSCustomObject]@{ Name = "GitRebase";        Description = "Rebase current branch onto main";             RequiresInput = $false }
        [PSCustomObject]@{ Name = "GitRebaseEdit";    Description = "Interactive rebase onto main";                RequiresInput = $false }
        [PSCustomObject]@{ Name = "GitFixup";         Description = "Create fixup commit";                         RequiresInput = $true  }
    )

    if (Get-Command Out-GridView -ErrorAction SilentlyContinue) {
        $selection = $items | Select-Object Name, Description | Out-GridView -Title "Git Helpers" -PassThru

        if (-not $selection) {
            return
        }

        switch ($selection.Name) {
            "GitCommit" {
                $message = Read-Host "Commit message"
                if (-not [string]::IsNullOrWhiteSpace($message)) {
                    GitCommit $message
                }
            }
            "GitNewBranch" {
                $branchName = Read-Host "Branch name"
                if (-not [string]::IsNullOrWhiteSpace($branchName)) {
                    GitNewBranch $branchName
                }
            }
            "GitFixup" {
                $commitHash = Read-Host "Commit hash"
                if (-not [string]::IsNullOrWhiteSpace($commitHash)) {
                    GitFixup $commitHash
                }
            }
            default {
                & $selection.Name
            }
        }

        return
    }

    Write-Host ""
    Write-Host "Git Helpers"
    Write-Host "-----------"

    for ($i = 0; $i -lt $items.Count; $i++) {
        $index = $i + 1
        Write-Host ("{0,2}. {1,-18} {2}" -f $index, $items[$i].Name, $items[$i].Description)
    }

    Write-Host ""
    $choice = Read-Host "Select a helper by number"

    if (-not ($choice -as [int])) {
        return
    }

    $selectedIndex = [int]$choice - 1

    if ($selectedIndex -lt 0 -or $selectedIndex -ge $items.Count) {
        return
    }

    $selectedItem = $items[$selectedIndex]

    switch ($selectedItem.Name) {
        "GitCommit" {
            $message = Read-Host "Commit message"
            if (-not [string]::IsNullOrWhiteSpace($message)) {
                GitCommit $message
            }
        }
        "GitNewBranch" {
            $branchName = Read-Host "Branch name"
            if (-not [string]::IsNullOrWhiteSpace($branchName)) {
                GitNewBranch $branchName
            }
        }
        "GitFixup" {
            $commitHash = Read-Host "Commit hash"
            if (-not [string]::IsNullOrWhiteSpace($commitHash)) {
                GitFixup $commitHash
            }
        }
        default {
            & $selectedItem.Name
        }
    }
}

if (Get-Command Set-PSReadLineKeyHandler -ErrorAction SilentlyContinue) {
    Set-PSReadLineKeyHandler -Chord Ctrl+g -ScriptBlock {
        GitMenu
    }
}