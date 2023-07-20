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
# chmod +x macos_bootstrap.sh
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

    # https://docs.brew.sh/Installation#macos-requirements
    install_xcode_select

    # Installing Homebrew, the basis of anything and everything
    install_homebrew
    # Installing mas using brew as the requirement for login_to_app_store
    brew_install mas
    # Ensuring the user is logged in the App Store so that
    # install_packages_with_brewfile can install App Store applications
    # using mas cli application
    login_to_app_store

    # Cloning Dotfiles repository for install_packages_with_brewfile
    # to have access to Brewfile
    #clone_dotfiles_repo
    # Installing all packages in Dotfiles repository's Brewfile
    install_packages_with_brewfile
    # Changing default shell to Fish
    change_shell_to_fish
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
    # Setting up symlinks so that setup_vim can install all plugins
    #setup_symlinks
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

    brew_cleanup

    info "macOS bootstrapping done"

}

function install_xcode_select() {
    info "Install Command Line Tools for Xcode"
    xcode-select --install
    info "Press any key after Command line tool install is finished"
    while [ true ] ; do
      read -t 5 -n 1
      if [ $? = 0 ] ; then
        exit ;
      else
        info "Press any key after Command line tool install is finished"
      fi
    done
}

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

function login_to_app_store() {
    info "Logging into app store..."
    if mas account >/dev/null; then
        success "Already logged in."
    else
        open -a "/Applications/App Store.app"
        until (mas account > /dev/null);
        do
            sleep 3
        done
        success "Login to app store successful."
    fi
}

function install_homebrew() {
    info "Installing Homebrew..."
    if hash brew 2>/dev/null; then
        success "Homebrew already exists."
    else
        url=https://raw.githubusercontent.com/vmsimon/dotfiles/master/installers/homebrew_installer
        if /usr/bin/ruby -e "$(curl -fsSL ${url})"; then
            success "Homebrew installation succeeded."
        else
            error "Homebrew installation failed."
            exit 1
        fi
    fi
}

function install_packages_with_brewfile() {
    info "Installing packages within ./brew/macOS.Brewfile ..."
    if brew bundle --file=./brew/macOS.Brewfile; then
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

function brew_cleanuo() {
    info "brew cleanup"
    if brew cleanup; then
        success "Cleanup succeeded."
    else
        error "Cleanup failed."
        exit 1
    fi
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
