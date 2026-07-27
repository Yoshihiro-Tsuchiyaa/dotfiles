# YOSHIHIRO's dotfiles

Cross-platform dotfiles for my development environments:

- Windows 11
- Linux (Ubuntu)
- PowerShell
- Bash
- Neovim
- Clink
- oh-my-posh
- Git

All configuration files are stored under `dotfiles/` and linked into their
original locations using **junctions**, **hardlinks**, or **symlinks** depending
on platform and file type.  
This ensures:

- Zero environment pollution  
- Full reproducibility across machines  
- No accidental overwrites  
- Safe version control  
- GitHub Secret Scanning + Push Protection enabled  

---

## Directory Structure
les/
windows/
powershell/
Microsoft.PowerShell_profile.ps1
clink/
clink_settings
oh-my-posh/
(custom themes if needed)
nvim/
init.lua
lua/
...
wsl/
bash/
.bashrc
neovim/
init.lua
lua/
...
byobu/
keybindings.tmux
common/
git/
.gitconfig
.gitignore_global
scripts/
setup.cmd
setup.ps1
setup.sh


---

## Linking Strategy

### Windows
- **Directories** → NTFS Junctions (`mklink /J`)  
- **Files** → Hardlinks (`mklink /H`)  
- No administrator privileges required.

### WSL2 / Linux
- **Files & Directories** → Symlinks (`ln -s`)  

This keeps the real configuration files inside `dotfiles/` while the OS sees
them at their usual paths.

---

## Setup

### Windows (cmd)
Run:


This will:

- Hardlink PowerShell profile  
- Junction Clink settings  
- Junction oh-my-posh directory  
- Junction Neovim config  
- Hardlink `.gitconfig`  
- Hardlink `.gitignore_global`

### Windows (PowerShell)
Run:

### Ubuntu (VirtualBox)

Run:

    common/scripts/setup-ubuntu.sh

This will:

- Symlink .bashrc
- Symlink .vimrc
- Symlink Neovim config
- Symlink byobu/tmux config
- Symlink gitconfig
- Symlink gitignore_global

All configuration files are moved safely into dotfiles/ubuntu/
if they exist and are not already symlinks.

---

## Notes

- No secrets are stored in this repository.
- GitHub Secret Scanning + Push Protection is enabled.
- oh-my-posh themes are loaded via Clink (`oh-my-posh init cmd`).
- All configs are linked safely; original files are moved only when not already linked.
- Reproducible on any machine by running the setup scripts.

---

## Philosophy

- Minimal  
- Robust  
- Reproducible  
- Zero environment pollution  
- Version-controlled configuration  
- Safe automation  

