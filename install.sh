#!/bin/bash
# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

# inspired by
# https://gist.github.com/codeinthehole/26b37efa67041e1307db
# https://github.com/why-jay/osx-init/blob/master/install.sh
# https://github.com/timsutton/osx-vm-templates/blob/master/scripts/xcode-cli-tools.sh

# PRECONDITIONS
# 1)
# make sure the file is executable
# chmod +x install.sh
#
# 2)
# Your password may be necessary for some packages
#

main() {
    info "macOS bootstrapping start"

    # `set -eu` causes an 'unbound variable' error in case SUDO_USER is not set
    SUDO_USER=$(whoami)

    # First things first, asking for sudo credentials
    ask_for_sudo

    # Installing Homebrew, the basis of anything and everything
    install_homebrew

    # Cloning Dotfiles repository for install_packages_with_brewfile
    # to have access to Brewfile
    clone_dotfiles_repo

    # Installing all packages in Dotfiles repository's Brewfile
    install_packages_with_brewfile

    # Configuring git config file
    configure_git

    # Installing powerline-status so that setup_symlinks can setup the symlinks
    # and requests and dotenv as the basis for a regular python script
    #pip_packages=(powerline-status requests python-dotenv flake8)
    #pip3_install "${pip_packages[@]}"
    # Installing typescript so that YouCompleteMe can support it
    # and prettier so that Neoformat can auto-format files
    #yarn_packages=(prettier typescript)
    #yarn_install "${yarn_packages[@]}"

    # Setting up symlinks so that we can use all plugins
    setup_symlinks

    # Setting up Vim
    #setup_vim
    # Setting up tmux
    #setup_tmux
    # Configuring iTerm2
    #configure_iterm2
    # Update /etc/hosts
    #update_hosts_file
    # Setting up macOS defaults
    #setup_macOS_defaults
    # Updating login items
    #update_login_items
    # install Java SDK's with sdkman
    sdk_install

    brew_cleanup

    info "macOS bootstrapping done"

}

DOTFILES_REPO=~/.dotfiles

function ask_for_sudo() {
    info "Prompting for sudo password..."
    if sudo --validate; then
        # Keep-alive
        while true; do sudo --non-interactive true; \
            sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
        success "Sudo credentials updated."
    else
        error "Obtaining sudo credentials failed."
        exit 1
    fi
}

function install_homebrew() {
    info "Installing Homebrew..."
    if hash brew 2>/dev/null; then
        success "Homebrew already exists."
    else
        # /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        url=https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh
        if /bin/bash -c "$(curl -fsSL ${url})"; then
            success "Homebrew installation succeeded."
        else
            error "Homebrew installation failed."
            exit 1
        fi
    fi
}

function install_packages_with_brewfile() {
    info "Installing packages within .dotfiles/brew/macOS.Brewfile ..."
    if brew bundle --file=~/.dotfiles/brew/macOS.Brewfile; then
        success "Brewfile installation succeeded."
    else
        error "Brewfile installation failed."
        exit 1
    fi
}

function brew_install() {
    package_to_install="$1"
    info "brew install ${package_to_install}"
    if hash "$package_to_install" 2>/dev/null; then
        success "${package_to_install} already exists."
    else
        if brew install "$package_to_install"; then
            success "Package ${package_to_install} installation succeeded."
        else
            error "Package ${package_to_install} installation failed."
            exit 1
        fi
    fi
}

function brew_cleanup() {
    info "brew cleanup"
    if brew cleanup; then
        success "Cleanup succeeded."
    else
        error "Cleanup failed."
        exit 1
    fi
}

function sdk_install() {
    # SDKMAN-CLI integration
    # https://github.com/sdkman/homebrew-tap
    SDKMAN_DIR=$(brew --prefix sdkman-cli)/libexec
    [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"
    while read -r package_to_install; do
      [[ $package_to_install = \#* ]] && continue
      info "sdk install $package_to_install"
      sdk install $package_to_install << EOM
n
EOM
    done < $DOTFILES_REPO/sdkman/sdk.install
}

function configure_git() {
    username="Volker Meyer-Simon"
    email="vmsimon@oev.de"

    info "Configuring git..."
    if git config --global user.name "$username" && \
       git config --global user.email "$email"; then
        success "git configuration succeeded."
    else
        error "git configuration failed."
    fi
}

function clone_dotfiles_repo() {
    info "Cloning dotfiles repository into ${DOTFILES_REPO} ..."
    if test -e $DOTFILES_REPO; then
        substep "${DOTFILES_REPO} already exists."
        pull_latest $DOTFILES_REPO
    else
        url=https://github.com/vmsimon/dotfiles.git
        if git clone "$url" $DOTFILES_REPO; then
            success "Cloned into ${DOTFILES_REPO}"
        else
            error "Cloning into ${DOTFILES_REPO} failed."
            exit 1
        fi
    fi
}

function pull_latest() {
    info "Pulling latest changes in ${1} repository..."
    if git -C $1 pull origin master &> /dev/null; then
        success "Pull successful in ${1} repository."
    else
        error "Please pull the latest changes in ${1} repository manually."
    fi
}

function update_login_items() {
    info "Updating login items..."
    login_item /Applications/iTerm.app
    login_item /Applications/Spectacle.app
    login_item /Applications/1Password.app
    success "Login items successfully updated."
}
function login_item() {
    path=$1
    hidden=${2:-false}
    name=$(basename "$path")

    # "¬" charachter tells osascript that the line continues
    if osascript &> /dev/null << EOM
tell application "System Events" to make login item with properties ¬
{name: "$name", path: "$path", hidden: "$hidden"}
EOM
    then
        success "Login item ${name} successfully added."
    else
        error "Adding login item ${name} failed."
        exit 1
    fi
}

function setup_symlinks() {
    POWERLINE_ROOT_REPO=/usr/local/lib/python2.7/site-packages

    info "Setting up symlinks..."
    symlink "zsh" ${DOTFILES_REPO}/zsh/zshrc ~/.zshrc
    symlink "tmux" ${DOTFILES_REPO}/tmux/tmux.conf ~/.tmux.conf
    symlink "powerline10k" ${DOTFILES_REPO}/p10k/p10k.zsh ~/.p10k.zsh
    success "Symlinks successfully setup."
}

function symlink() {
    application=$1
    point_to=$2
    destination=$3
    destination_dir=$(dirname "$destination")

    if test ! -e "$destination_dir"; then
        substep "Creating ${destination_dir}"
        mkdir -p "$destination_dir"
    fi
    if rm -rf "$destination" && ln -s "$point_to" "$destination"; then
        success "Symlinking ${application} done."
    else
        error "Symlinking ${application} failed."
        exit 1
    fi
}

function coloredEcho() {
    local exp="$1";
    local color="$2";
    local arrow="$3";
    if ! [[ $color =~ '^[0-9]$' ]] ; then
       case $(echo $color | tr '[:upper:]' '[:lower:]') in
        black) color=0 ;;
        red) color=1 ;;
        green) color=2 ;;
        yellow) color=3 ;;
        blue) color=4 ;;
        magenta) color=5 ;;
        cyan) color=6 ;;
        white|*) color=7 ;; # white or invalid color
       esac
    fi
    tput bold;
    tput setaf "$color";
    echo "$arrow $exp";
    tput sgr0;
}

function info() {
    coloredEcho "$1" blue "========>"
}

function substep() {
    coloredEcho "$1" magenta "===="
}

function success() {
    coloredEcho "$1" green "========>"
}

function error() {
    coloredEcho "$1" red "========>"
}

main "$@"
