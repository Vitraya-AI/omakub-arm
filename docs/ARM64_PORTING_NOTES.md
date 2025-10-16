# ARM64 Porting Notes for Omakub

## Installation Flow
1. `install.sh` (x86) and the new `install-arm64.sh` orchestrate the install. Both fetch user choices with Gum, gather identification info, and conditionally run terminal and GNOME desktop installers.【F:install.sh†L1-L36】【F:install-arm64.sh†L1-L35】
2. Architecture and release validation happens before anything else. `install/check-version.sh` enforces Ubuntu 24.04+ on x86, while `install/check-version-arm64.sh` performs the same check for ARM systems.【F:install/check-version.sh†L1-L26】【F:install/check-version-arm64.sh†L1-L26】
3. When GNOME is detected, the installer temporarily disables screen locking, runs every script in `install/terminal/` and `install/desktop/`, then restores normal idle behaviour.【F:install.sh†L18-L35】【F:install-arm64.sh†L17-L34】

## Terminal Stack
### Bootstrap Tasks
- `install/terminal.sh` updates and upgrades apt, then installs `curl`, `git`, and `unzip` before sourcing every script under `install/terminal/`. These packages are multi-arch in Ubuntu 24.04, so no ARM64 issues.【F:install/terminal.sh†L1-L10】
- `a-shell.sh` replaces `.bashrc` and `.inputrc` with the curated configs bundled in `configs/`. Architecture-independent.【F:install/terminal/a-shell.sh†L1-L13】

### Required tooling
- `terminal/required/app-gum.sh` installs Gum v0.14.3 from GitHub. The script now downloads the matching `amd64` or `arm64` `.deb`, skipping unsupported architectures.【F:install/terminal/required/app-gum.sh†L1-L18】

### CLI utilities
- `app-btop.sh` installs `btop` via apt and applies the bundled theme. Ubuntu’s package is available on both amd64 and arm64.【F:install/terminal/app-btop.sh†L1-L12】
- `app-fastfetch.sh` enables the upstream PPA and installs `fastfetch`, then seeds a config if one is missing. The PPA publishes `arm64` builds, so this works unchanged on ARM.【F:install/terminal/app-fastfetch.sh†L1-L15】
- `apps-terminal.sh` installs `fzf`, `ripgrep`, `bat`, `eza`, `zoxide`, `plocate`, `apache2-utils`, `fd-find`, and `tldr` from Ubuntu. All have official arm64 binaries in the Ubuntu archive.【F:install/terminal/apps-terminal.sh†L1-L2】
- `libraries.sh` installs build tooling and client libraries for common databases using apt (e.g., `build-essential`, `libpq-dev`, `libmysqlclient-dev`). Every listed package has an arm64 build in Ubuntu 24.04.【F:install/terminal/libraries.sh†L1-L5】
- `set-git.sh` establishes aliases and sets the git identity supplied during install. Architecture-independent.【F:install/terminal/set-git.sh†L1-L16】

### Git & container helpers
- `app-github-cli.sh` adds GitHub’s apt repo with the detected architecture and installs `gh`, which is published for arm64.【F:install/terminal/app-github-cli.sh†L1-L7】
- `docker.sh` configures Docker’s apt repo for the active architecture, installs the engine and plugins, grants the user `docker` group access, and caps log sizes. Docker ships official arm64 builds, so this pathway works on ARM.【F:install/terminal/docker.sh†L1-L17】
- `app-lazygit.sh` and `app-lazydocker.sh` now map the system architecture to the proper GitHub release archive (`linux_x86_64` vs `linux_arm64`). Both skip gracefully on unsupported CPUs.【F:install/terminal/app-lazygit.sh†L1-L25】【F:install/terminal/app-lazydocker.sh†L1-L24】
- `app-zellij.sh` chooses between the `x86_64-unknown-linux-musl` and `aarch64-unknown-linux-musl` tarballs, installs the binary, and copies theming assets. Unsupported architectures are skipped with an explanatory message.【F:install/terminal/app-zellij.sh†L1-L24】

### Editor setup
- `app-neovim.sh` downloads the architecture-specific `nvim-linux-<arch>.tar.gz`, installs the runtime, and seeds LazyVim defaults only when no prior config exists. Unsupported architectures are skipped.【F:install/terminal/app-neovim.sh†L1-L43】

### Runtime managers & languages
- `mise.sh` installs Mise via its apt repository (supports both amd64 and arm64) and `select-dev-language.sh` provisions languages using Mise, apt, or upstream installers (Rust’s `rustup`, PHP modules, etc.). All paths are either architecture neutral or already multi-arch.【F:install/terminal/mise.sh†L1-L8】【F:install/terminal/select-dev-language.sh†L1-L55】
- `select-dev-storage.sh` launches Docker containers for MySQL, Redis, and PostgreSQL. Official images exist for both amd64 and arm64, so no changes were required.【F:install/terminal/select-dev-storage.sh†L1-L26】

### Optional terminal tools
- `optional/app-geekbench.sh` now chooses between the `Linux` and `LinuxARM` archives. The extracted directory name is adjusted accordingly.【F:install/terminal/optional/app-geekbench.sh†L1-L24】
- `optional/app-ollama.sh` and `optional/app-tailscale.sh` run upstream install scripts that already detect arm64.【F:install/terminal/optional/app-ollama.sh†L1-L2】【F:install/terminal/optional/app-tailscale.sh†L1-L2】

## Desktop Stack
### Common desktop tasks
- `install/desktop.sh` sources every script under `install/desktop/` and ends with a reboot prompt. Desktop scripts are written to skip gracefully when an app is unavailable on arm64.【F:install/desktop.sh†L1-L8】
- `a-flatpak.sh` adds Flatpak support and the Flathub remote—available on both architectures.【F:install/desktop/a-flatpak.sh†L1-L5】
- Fonts, GNOME tweaks, keybindings, themes, dock layout, and application grid customization rely on GNOME settings and the bundled assets only—they are architecture neutral.【F:install/desktop/fonts.sh†L1-L16】【F:install/desktop/set-gnome-hotkeys.sh†L1-L59】【F:install/desktop/set-app-grid.sh†L1-L21】

### Desktop applications (core)
- Packages installed from Ubuntu (`alacritty`, `flameshot`, `gnome-sushi`, `gnome-tweak-tool`, `libreoffice`, `vlc`, `xournalpp`, `wl-clipboard`) already have arm64 builds.【F:install/desktop/app-alacritty.sh†L1-L21】【F:install/desktop/app-flameshot.sh†L1-L4】【F:install/desktop/app-gnome-sushi.sh†L1-L4】【F:install/desktop/app-gnome-tweak-tool.sh†L1-L3】【F:install/desktop/app-libreoffice.sh†L1-L4】【F:install/desktop/app-vlc.sh†L1-L3】【F:install/desktop/app-xournalpp.sh†L1-L3】【F:install/desktop/app-wl-clipboard.sh†L1-L5】
- `app-chrome.sh` now refuses to run on non-amd64 systems because Google does not ship an ARM64 Linux build.【F:install/desktop/app-chrome.sh†L1-L14】
- `app-localsend.sh` switches between `linux-x86-64` and `linux-arm-64` `.deb` files.【F:install/desktop/app-localsend.sh†L1-L20】
- `app-obsidian.sh`, `app-pinta.sh` (Snap), `app-typora.sh`, `app-vscode.sh`, and `app-wl-clipboard.sh` install Flatpak/Snap or apt packages that already support arm64. Typora now downloads the correct `amd64`/`arm64` installer automatically.【F:install/desktop/app-obsidian.sh†L1-L5】【F:install/desktop/app-pinta.sh†L1-L4】【F:install/desktop/app-typora.sh†L1-L29】【F:install/desktop/app-vscode.sh†L1-L16】
- `app-signal.sh` skips on arm64 with an explanatory note because Signal only distributes amd64 packages.【F:install/desktop/app-signal.sh†L1-L14】

### Optional desktop applications
- The optional installer scripts now either select architecture-specific assets or skip unsupported apps:
  - Architecture-aware downloads: `app-zoom.sh` (amd64/arm64 `.deb`), `app-brave.sh` (apt repo arch), `app-typora.sh`, and `app-localsend.sh`.【F:install/desktop/optional/app-zoom.sh†L1-L20】【F:install/desktop/optional/app-brave.sh†L1-L17】
  - Explicit skips on non-amd64: Cursor, Discord, Dropbox, Minecraft, RubyMine, Spotify, Steam, VirtualBox, Windsurf—each prints a message and exits cleanly.【F:install/desktop/optional/app-cursor.sh†L1-L21】【F:install/desktop/optional/app-discord.sh†L1-L16】【F:install/desktop/optional/app-dropbox.sh†L1-L11】【F:install/desktop/optional/app-minecraft.sh†L1-L17】【F:install/desktop/optional/app-rubymine.sh†L1-L9】【F:install/desktop/optional/app-spotify.sh†L1-L14】【F:install/desktop/optional/app-steam.sh†L1-L14】【F:install/desktop/optional/app-virtualbox.sh†L1-L11】【F:install/desktop/optional/app-windsurf.sh†L1-L15】
  - Remaining optional scripts rely on Flatpak or source builds and work unchanged (`app-1password.sh`, `app-asdcontrol.sh`, `app-audacity.sh`, `app-doom-emacs.sh`, `app-gimp.sh`, `app-mainline-kernels.sh`, `app-obs-studio.sh`, `app-retroarch.sh`, `app-ulauncher.sh`, `select-web-apps.sh`, etc.).【F:install/desktop/optional/app-1password.sh†L1-L22】【F:install/desktop/optional/app-asdcontrol.sh†L1-L20】【F:install/desktop/optional/app-audacity.sh†L1-L3】【F:install/desktop/optional/app-doom-emacs.sh†L1-L4】【F:install/desktop/optional/app-mainline-kernels.sh†L1-L4】【F:install/desktop/optional/app-obs-studio.sh†L1-L4】【F:install/desktop/optional/app-retroarch.sh†L1-L3】【F:install/desktop/optional/select-web-apps.sh†L1-L23】

### Desktop configuration extras
- GNOME extensions are installed via `set-gnome-extensions.sh`. It disables Ubuntu’s defaults, installs seven extensions with `gext`, copies their schemas, and applies customised settings. The logic is architecture agnostic.【F:install/desktop/set-gnome-extensions.sh†L1-L54】
- `set-gnome-hotkeys.sh`, `set-gnome-settings.sh`, `set-dock.sh`, `set-framework-text-scaling.sh`, and `set-xcompose.sh` tweak GNOME preferences, manage custom bindings, and adjust Framework laptop scaling. None are architecture specific, though the Framework tweak only applies when hardware detection matches.【F:install/desktop/set-gnome-hotkeys.sh†L1-L59】【F:install/desktop/set-dock.sh†L1-L37】【F:install/desktop/set-framework-text-scaling.sh†L1-L10】
- `applications.sh` sources every script under `applications/`, creating desktop launchers for About, Activity, Basecamp, Docker, HEY, Neovim, Omakub, and WhatsApp. The launchers rely on Chrome for Basecamp/HEY/WhatsApp; on ARM they will be absent if Chrome was skipped.【F:install/desktop/applications.sh†L1-L3】【F:applications/Basecamp.sh†L1-L14】【F:applications/HEY.sh†L1-L14】【F:applications/WhatsApp.sh†L1-L14】

## Summary of ARM64 Availability
- **Fully supported on ARM64:** Core terminal tooling, Docker, GNOME customisation, Flatpak apps, VS Code, Obsidian, Typora, Zoom, Brave, Ulauncher, and most optional Flatpaks/snaps.
- **Partially supported / skipped:** Chrome, Signal, Dropbox, Discord, Minecraft, Spotify, Steam, VirtualBox, Windsurf, Cursor, RubyMine. Scripts now short-circuit with clear messaging on arm64, avoiding install failures.
- **New assets:** Added `install-arm64.sh` and `install/check-version-arm64.sh` so a fresh Ubuntu ARM64 install can follow the same flow with architecture-aware downloads and graceful skips.
