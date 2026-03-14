# --------------------------------
# Git helper functions for Zsh
# --------------------------------

gitAdd() {
  echo "[gitAdd] Stage all changes (git add .)"
  git add .
}

gitCommit() {
  local message="$*"

  if [[ -z "$message" ]]; then
    echo -n "[gitCommit] Commit message: "
    read -r message
  fi

  if [[ -z "$message" ]]; then
    echo "[gitCommit] Aborted: empty commit message."
    return 1
  fi

  echo "[gitCommit] Commit with message: $message"
  git commit -m "$message"
}

gitNewBranch() {
  if [ $# -eq 0 ]; then
    echo "[gitNewBranch] Missing branch name."
    echo "Usage: gitNewBranch feature/branch-name"
    return 1
  fi

  echo "[gitNewBranch] Create and switch to branch: $1"
  git switch -c "$1"
}

gitStatus() {
  echo "[gitStatus] Show repository status"
  git status -sb
}

gitLast() {
  echo "[gitLast] Show last commit"
  git log -1
}

gitLog() {
  echo "[gitLog] Show compact git history"
  git log --oneline --graph --decorate --all
}

gitCurrent() {
  echo "[gitCurrent] Current branch"
  git branch --show-current
}

gitQuickPush() {
  echo "[gitQuickPush] Amend last commit and force push with lease"
  git commit --amend --no-edit && git push --force-with-lease
}

gitSync() {
  echo "[gitSync] Pull with rebase then push"
  git pull --rebase && git push
}

gitCleanBranches() {
  echo "[gitCleanBranches] Delete local branches already merged into main"
  git branch --merged | grep -v '\*' | grep -v 'main' | xargs git branch -d
}

gitRestore() {
  echo "[gitRestore] Unstage all staged files"
  git restore --staged .
}

gitReset() {
  echo "[gitReset] HARD reset: remove all uncommitted changes and untracked files"
  git reset --hard HEAD && git clean -fd
}

gitRebase() {
  local previous_branch
  previous_branch="$(git branch --show-current)"

  echo "[gitRebase] Update main and rebase current branch onto main"

  git switch main &&
  git fetch origin &&
  git pull &&
  git switch "$previous_branch" &&
  git rebase main
}

gitRebaseEdit() {
  local previous_branch
  previous_branch="$(git branch --show-current)"

  echo "[gitRebaseEdit] Update main and interactive rebase"

  git switch main &&
  git fetch origin &&
  git pull &&
  git switch "$previous_branch" &&
  git rebase -i main
}

gitFixup() {
  if [ $# -eq 0 ]; then
    echo "[gitFixup] Missing commit hash"
    echo "Usage: gitFixup <commit-hash>"
    return 1
  fi

  echo "[gitFixup] Create fixup commit for $1"
  git commit --fixup "$1"
}

# --------------------------------
# Git helper menu (fzf)
# --------------------------------

gitMenu() {

  local selection
  local cmd

  selection=$(
    printf "%-22s %s\n" \
      "gitAdd" "Stage all changes (git add .)" \
      "gitCommit" "Commit with message" \
      "gitNewBranch" "Create and switch to new branch" \
      "gitStatus" "Show repository status" \
      "gitLast" "Show last commit" \
      "gitLog" "Show compact commit history" \
      "gitCurrent" "Show current branch" \
      "gitQuickPush" "Amend last commit and force push" \
      "gitSync" "Pull with rebase then push" \
      "gitCleanBranches" "Delete merged local branches" \
      "gitRestore" "Unstage all staged files" \
      "gitReset" "Hard reset and clean repo" \
      "gitRebase" "Rebase current branch onto main" \
      "gitRebaseEdit" "Interactive rebase onto main" \
      "gitFixup" "Create fixup commit" \
      | fzf \
          --prompt="Git helpers > " \
          --height=40% \
          --layout=reverse \
          --border \
          --info=inline
  )

  if [[ -n "$selection" ]]; then
    cmd=$(echo "$selection" | awk '{print $1}')
    echo "[gitMenu] Running: $cmd"
    eval "$cmd"
  fi
}

# Ctrl + G shortcut
bindkey -s '^G' 'gitMenu\n'