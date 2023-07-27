# [My macOS Setup]

Originally Inspired by [My macOS Empire](https://medium.com/@Sadhosn/build-a-macos-empire-a0c83879ac24) 👑
[![my macOS empire](https://i.imgur.com/3ep7B1T.png)](https://vimeo.com/sajjadhosn/my-macos-empire "Watch a sample executation of my macOS bootstrapping script")

* On a fresh macOS:
	* Setup for a software development environment entirely with a one-liner 🔥
    ```
    curl --silent https://raw.githubusercontent.com/vmsimon/dotfiles/master/install.sh | bash
    ```

* What does the script do_
  * Ask for sudo rights
  * Install Homebrew inclusive xcode command line tools if not already installed - https://brew.sh/index_de
  * Git clone this repo in ~/.dotfiles
  * Install the following tools with ```brew install```
    * antigen - Plugin manager for zsh, inspired by oh-my-zsh and vundle - https://antigen.sharats.me/
    * autojump - Shell extension to jump to frequently used directories - https://github.com/wting/autojump
    * bat - Clone of cat with syntax highlighting and Git integration - https://github.com/sharkdp/bat
    * chafe - Versatile and fast Unicode/ASCII/ANSI graphics renderer - https://hpjansson.org/chafa/
    * curl -  Get a file from an HTTP, HTTPS or FTP server - https://curl.se
    * dive -Tool for exploring each layer in a docker image - https://github.com/wagoodman/dive
    * docker - Pack, ship and run any application as a lightweight container - https://www.docker.com/
    * docker-compose - Isolated development environments using Docker - https://docs.docker.com/compose/
    * docker-credential-helper - Platform keystore credential helper for Docker - https://github.com/docker/docker-credential-helpers
    * docker-slim - Minify and secure Docker images - https://slimtoolkit.org/
    * exa- Modern replacement for 'ls' - https://the.exa.website
    * exiftool - Perl lib for reading and writing EXIF metadata - https://exiftool.org
    * findutils - Collection of GNU find, xargs, and locate - https://www.gnu.org/software/findutils/
    * fzf - Command-line fuzzy finder written in Go - https://github.com/junegunn/fzf
    * git - Distributed revision control system - https://git-scm.com
    * git-crypt - Enable transparent encryption/decryption of files in a git repo - https://www.agwa.name/projects/git-crypt/
    * git-delta - Syntax-highlighting pager for git and diff output - https://github.com/dandavison/delta
    * git-flow - Extensions to follow Vincent Driessen's branching model - https://github.com/nvie/gitflow
    * git-lfs - Git extension for versioning large files - https://git-lfs.github.com/
    * gitui -Blazing fast terminal-ui for git written in rust - https://github.com/extrawurst/gitui
    * helm - Kubernetes package manager - https://helm.sh/
    * helmfile - Deploy Kubernetes Helm Charts - https://github.com/helmfile/helmfile
    * htop - Improved top (interactive process viewer) - https://htop.dev/
    * httpie - User-friendly cURL replacement (command-line HTTP client) - https://httpie.io/
	* k9s - Kubernetes CLI To Manage Your Clusters In Style! - https://k9scli.io/
    * kubernets-cli - Kubernetes command-line interface - https://kubernetes.io/
    * krew - Package manager for kubectl plugins - https://sigs.k8s.io/krew/
    * lazydocker - Lazier way to manage everything docker - https://github.com/jesseduffield/lazydocker
    * lesspipe - Input filter for the pager less - https://github.com/wofr06/lesspipe/
	* popeye - A Kubernetes Cluster sanitizer and linter - https://popeyecli.io
    * pwgen - Password generator - https://pwgen.sourceforge.io/
    * sevenzip - 7-Zip is a file archiver with a high compression ratio - https://7-zip.org
    * sops - Editor of encrypted files - https://github.com/mozilla/sops
    * sslyze - SSL scanner - https://github.com/nabla-c0d3/sslyze
    * step - Crypto and x509 Swiss-Army-Knife - https://smallstep.com
    * stern - Tail multiple Kubernetes pods & their containers - https://github.com/stern/stern
    * tree - Display directories as trees (with optional color/HTML output) - http://mama.indstate.edu/users/ice/tree/
    * tmux -  Terminal multiplexer - https://tmux.github.io/
    * tmuxinator - Manage complex tmux sessions easily - https://github.com/tmuxinator/tmuxinator
    * watch - Executes a program periodically, showing output fullscreen - https://gitlab.com/procps-ng/procps
    * wget - Internet file retriever - https://www.gnu.org/software/wget/
    * zsh - UNIX shell (command interpreter) - https://www.zsh.org/
  * Other Tap's
    * sdkman-cli - A Homebrew tap containing the Formula for the SDKMAN! CLI. - https://github.com/sdkman/homebrew-tap
    * s5cmd - Parallel S3 and local filesystem execution tool - https://github.com/peak/s5cmd

  * Install the following apps with ```brew install --cask``` - https://github.com/Homebrew/homebrew-cask
    * firewfox - Firefox WebBrowser - https://www.mozilla.org/firefox/
    * google-chrome - Google Chrome Webbrowser - https://www.google.com/chrome/
    * 1password - The 1Password password manager - https://1password.com/
    * 1password-cli - Command-line helper for the 1Password password manager - https://developer.1password.com/docs/cli
    * appcleaner - Uninstaller and cleaning assistant - https://freemacsoft.net/appcleaner/
    * apache-directory-studio - Eclipse-based LDAP browser and directory client - https://directory.apache.org/studio/
    * browserosaurus - Open-source browser prompter - https://github.com/will-stone/browserosaurus
    * clipy - Clipboard extension app - https://clipy-app.com/
    * iterm2 - Terminal emulator as alternative to Apple's Terminal app - https://www.iterm2.com/
    * jetbrains-toolbox - JetBrains tools manager - https://www.jetbrains.com/toolbox-app/
    * lens - Kubernetes IDE - https://k8slens.dev/
    * mysqlworkbench - Visual tool to design, develop and administer MySQL servers - https://www.mysql.com/products/workbench/
    * porting-kit - Porting tool, to make Windows programs/games into native apps - https://portingkit.com/
    * postman - Collaboration platform for API development - https://www.postman.com/
    * rectangle - Move and resize windows using keyboard shortcuts or snap areas - https://rectangleapp.com/
    * slack - Team communication and collaboration software - https://slack.com/
    * textmate - General-purpose text editor - https://macromates.com/
    * wireshark - Network protocol analyzer - https://www.wireshark.org
    * xca - X Certificate and Key management - https://hohnstaedt.de/xca/

