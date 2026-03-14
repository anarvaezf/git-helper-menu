# Git Helper Menu

Interactive **Git helper functions** with a searchable menu for **Zsh** and **PowerShell**.

This project provides a set of productivity helpers for Git and an interactive menu to quickly execute them from the terminal.

The goal is to simplify common Git workflows while keeping commands readable and discoverable.

---

# Features

- Git productivity helpers
- Interactive command menu
- Keyboard shortcut support
- Works with **Zsh** and **PowerShell**
- Clean command descriptions
- Optional fuzzy search (via `fzf` in Zsh)

---

# Supported Shells

| Shell | Menu | Shortcut |
|------|------|------|
| Zsh | fzf interactive menu | Ctrl + G |
| PowerShell | interactive selection menu | Ctrl + G |

---

# Installation

## Zsh

### Requirements

Install `fzf`:

```bash
brew install fzf
```

### Install

Clone the repository:

```bash
git clone https://github.com/anarvaezf/git-helper-menu.git
```

Run the installer:

```bash
cd git-helper-menu/zsh
./install.sh
```

Reload your shell:

```bash
source ~/.zshrc
```

### Usage

Open the helper menu:

```
Ctrl + G
```

You can also call helpers directly:

```bash
gitAdd
gitCommit "fix issue"
gitRebase
gitCleanBranches
```

---

### Quick Install (optional)

You can also install directly with:

```bash
curl -fsSL https://raw.githubusercontent.com/anarvaezf/git-helper-menu/main/zsh/install.sh | bash
```
---

# PowerShell

### Install

Clone the repository:

```powershell
git clone https://github.com/anarvaezf/git-helper-menu.git
```

Run the installer:

```powershell
cd git-helper-menu\powershell
.\install.ps1
```

Reload your profile:

```powershell
. $PROFILE
```

### Usage

Open the helper menu:

```
Ctrl + G
```

You can also call helpers directly:

```powershell
GitAdd
GitCommit "fix issue"
GitRebase
GitCleanBranches
```

---

# Included Helpers

| Command | Description |
|------|------|
| gitAdd / GitAdd | Stage all changes |
| gitCommit / GitCommit | Commit with message |
| gitNewBranch / GitNewBranch | Create and switch branch |
| gitStatus / GitStatus | Show repository status |
| gitLast / GitLast | Show last commit |
| gitLog / GitLog | Compact commit history |
| gitCurrent / GitCurrent | Show current branch |
| gitQuickPush / GitQuickPush | Amend commit and force push |
| gitSync / GitSync | Pull with rebase then push |
| gitCleanBranches / GitCleanBranches | Remove merged branches |
| gitRestore / GitRestore | Unstage files |
| gitReset / GitReset | Hard reset and clean repo |
| gitRebase / GitRebase | Rebase branch onto main |
| gitRebaseEdit / GitRebaseEdit | Interactive rebase |
| gitFixup / GitFixup | Create fixup commit |

---

# Example Workflow

Typical usage with the menu:

```
Ctrl + G
→ Select gitAdd
→ Select gitCommit
→ Select gitRebase
```

Or directly from the terminal:

```bash
gitAdd
gitCommit "add location mapper"
gitRebase
gitQuickPush
```

---

# Repository Structure

```
git-helper-menu
├── zsh
│   └── git-helpers.zsh
├── powershell
│   ├── git-helpers.ps1
│   └── install.ps1
├── README.md
└── LICENSE
```

---

# License

MIT License

Copyright (c) 2026 Arturo Narváez

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files to deal in the Software
without restriction.

---

# Contributing

Pull requests and improvements are welcome.

If you have ideas for additional helpers or workflow improvements, feel free to open an issue or submit a PR.