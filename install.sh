#!/usr/bin/env bash
# Configure terminal environment
set -euo pipefail
IFS=$'\n\t'
trap 'echo "Error on line $LINENO"' ERR

# --- Options -----------------------------------------------------------------

INSTALL_ALL=0
INSTALL_TMUX=0
INSTALL_VIM=0
INSTALL_NVIM=0
INSTALL_FONTS=0

usage() {
  cat <<EOF
Usage: $0 [OPTIONS]

Setup terminal environment.

Options:
  --all     Install tmux, vim, neovim, and fonts (default if no options given)
  --tmux    Compile and install tmux
  --vim     Compile and install vim
  --nvim    Compile and install neovim
  --fonts   Download and install latest fonts
  --help    Show this help message
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
  --all) INSTALL_ALL=1 ;;
  --tmux) INSTALL_TMUX=1 ;;
  --vim) INSTALL_VIM=1 ;;
  --nvim) INSTALL_NVIM=1 ;;
  --fonts) INSTALL_FONTS=1 ;;
  --help)
    usage
    exit 0
    ;;
  *)
    echo "Unknown option: $1" >&2
    usage
    exit 1
    ;;
  esac
  shift
done

if [[ $INSTALL_ALL -eq 1 ]]; then
  INSTALL_TMUX=1
  INSTALL_VIM=1
  INSTALL_NVIM=1
  INSTALL_FONTS=1
fi

# Default to all if no install options given
if [[ $INSTALL_TMUX -eq 0 && $INSTALL_VIM -eq 0 && $INSTALL_NVIM -eq 0 && $INSTALL_FONTS -eq 0 ]]; then
  INSTALL_TMUX=1
  INSTALL_VIM=1
  INSTALL_NVIM=1
  INSTALL_FONTS=1
fi

# --- Helpers -----------------------------------------------------------------

function pause() {
  read -s -n 1 -p "Press any key to continue . . ."
  echo ""
}

log() { echo -e "\n** $1 **\n"; }

backup_or_remove() {
  local target="$1"
  if [[ -e "$target" && ! -L "$target" ]]; then
    mv "$target" "${target}.bak.$(date +%s)"
  elif [[ -L "$target" ]]; then
    rm "$target"
  fi
}

safe_link() {
  local src="$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  backup_or_remove "$dst"
  ln -s "$src" "$dst"
}

basedir=$(pwd)
echo "basedir=$basedir"

DISTRO=$(grep '^ID=' /etc/os-release | cut -d= -f2 | tr -d '"')
echo "distro=$DISTRO"

# --- Dependencies ------------------------------------------------------------

log "Install dependencies"

pkg_is_installed() {
  dpkg-query -W -f='${Status}' "$1" 2>/dev/null | grep -q "install ok installed"
}

packages=(
  ninja-build gettext libtool libtool-bin autoconf automake cmake make g++
  pkg-config unzip curl libevent-dev libncurses-dev bison byacc libx11-dev
  libxt-dev libgtk-3-dev zsh perl libperl-dev ruby ruby-dev python3-pip
  python3-dev btop autotools-dev xsel xclip ripgrep universal-ctags fzf
  snapd fd-find cargo
)

missing=()
for pkg in "${packages[@]}"; do
  if ! pkg_is_installed "$pkg"; then
    missing+=("$pkg")
  fi
done

if [[ ${#missing[@]} -gt 0 ]]; then
  log "Installing missing packages: ${missing[*]}"
  sudo apt-get update
  sudo apt-get install -y "${missing[@]}"
else
  echo "All apt packages already installed"
fi

# Make fd-find usable as 'fd'
if command -v fdfind >/dev/null 2>&1 && [[ ! -x ~/.local/bin/fd ]]; then
  mkdir -p ~/.local/bin
  ln -sf "$(command -v fdfind)" ~/.local/bin/fd
fi

if [[ "$DISTRO" == "debian" ]]; then
  LAZYGIT_VERSION=$(curl -fsSL \
    "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" |
    grep -Po '"tag_name": *"v\K[^"]*') || true
  [[ -z "$LAZYGIT_VERSION" ]] && {
    echo "Could not fetch lazygit version" >&2
    exit 1
  }

  ARCH=$(uname -m)
  case "$ARCH" in
  x86_64) LAZYGIT_ARCH="Linux_x86_64" ;;
  aarch64) LAZYGIT_ARCH="Linux_arm64" ;;
  armv7l) LAZYGIT_ARCH="Linux_armv7" ;;
  *)
    echo "Unsupported architecture: $ARCH" >&2
    exit 1
    ;;
  esac

  curl -fsSL -o /tmp/lazygit.tar.gz \
    "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_${LAZYGIT_ARCH}.tar.gz"
  tar -xf /tmp/lazygit.tar.gz -C /tmp lazygit
  sudo install /tmp/lazygit -D -t /usr/local/bin/
  rm -rf /tmp/lazygit.tar.gz /tmp/lazygit

  sudo snap install ghostty --classic
  sudo snap install zig --beta --classic

  log "Install fastfetch"
  if ! command -v fastfetch >/dev/null 2>&1; then
    FASTFETCH_VERSION=$(curl -fsSL \
      "https://api.github.com/repos/fastfetch-cli/fastfetch/releases/latest" |
      grep -Po '"tag_name": *"\K[^"]*' || true)

    [[ -z "$FASTFETCH_VERSION" ]] && {
      echo "Could not determine fastfetch version" >&2
      exit 1
    }

    curl -fsSL -o /tmp/fastfetch-linux-amd64.deb \
      "https://github.com/fastfetch-cli/fastfetch/releases/download/${FASTFETCH_VERSION}/fastfetch-linux-amd64.deb"

    sudo dpkg -i /tmp/fastfetch-linux-amd64.deb
    sudo apt-get install -f -y
    rm -f /tmp/fastfetch-linux-amd64.deb
  else
    echo "fastfetch already installed ($(fastfetch --version | head -n1)), skipping"
  fi
fi

log "Installation of dependencies completed"

# --- Desktop environment -----------------------------------------------------

log "Determine desktop environment"

if [[ -z "${XDG_CURRENT_DESKTOP:-}" ]]; then
  desktop=$(echo "${XDG_DATA_DIRS:-}" | sed -n 's/.*\(xfce\|kde\|gnome\).*/\1/p')
else
  desktop=$(echo "$XDG_CURRENT_DESKTOP" | cut -d ':' -f 2)
fi
desktop=${desktop,,}
echo "Desktop Environment --> $desktop"

if [[ "$desktop" == "gnome" ]]; then
  if [[ ! -d ~/.config/base16-gnome-terminal ]]; then
    echo "cloning gnome base-16 theme..."
    git clone https://github.com/aaron-williamson/base16-gnome-terminal.git \
      ~/.config/base16-gnome-terminal
    ~/.config/base16-gnome-terminal/color-scripts/base16-gruvbox-dark-hard.sh
  fi

  if [[ ! -d ~/.themes ]]; then
    mkdir -p ~/repos
    git clone https://github.com/Fausto-Korpsvart/Gruvbox-GTK-Theme.git \
      ~/repos/gnome-gruvbox-theme
    mkdir -p ~/.themes ~/.icons ~/.local/share/gedit/styles
    cp ~/repos/gnome-gruvbox-theme/themes/* ~/.themes/
    cp ~/repos/gnome-gruvbox-theme/icons/* ~/.icons/
    cp ~/repos/gnome-gruvbox-theme/extras/text-editor/* \
      ~/.local/share/gedit/styles/
  fi
elif [[ "$desktop" == "kde" ]]; then
  echo "KDE desktop!"

  if [[ ! -d ~/repos/base16-konsole-themes ]]; then
    echo "Install base16 themes for Konsole"
    git clone https://github.com/cskeeters/base16-konsole.git \
      ~/repos/base16-konsole-themes
    mkdir -p ~/.local/share/konsole
    cp ~/repos/base16-konsole-themes/colorscheme/base16-gruvbox-dark-* \
      ~/.local/share/konsole/
  fi

  if [[ ! -f ~/.local/share/konsole/Gruvbox_dark.colorscheme ]]; then
    echo "Install gruvbox Konsole color scheme"
    mkdir -p ~/.local/share/konsole
    curl -fsSL -o ~/.local/share/konsole/Gruvbox_dark.colorscheme \
      "https://raw.githubusercontent.com/morhetz/gruvbox-contrib/master/konsole/Gruvbox_dark.colorscheme"
    curl -fsSL -o ~/.local/share/konsole/Gruvbox_light.colorscheme \
      "https://raw.githubusercontent.com/morhetz/gruvbox-contrib/master/konsole/Gruvbox_light.colorscheme"
  fi

  if [[ ! -d ~/.local/share/warp-terminal/themes ]]; then
    echo "Install Warp terminal themes"
    mkdir -p ~/.local/share/warp-terminal
    git clone https://github.com/warpdotdev/themes.git \
      ~/.local/share/warp-terminal/themes
  fi
else
  echo "Unknown desktop!"
fi

mkdir -p ~/.local/bin

# --- Bash --------------------------------------------------------------------

log "bash configuration"
safe_link "$basedir/bash/bashbootstrap" ~/.bashrc
log "bash configuration completed"

# --- bash-git-prompt ---------------------------------------------------------

log "bash-git-prompt configuration"
if [[ ! -d ~/.bash-git-prompt ]]; then
  git clone --depth=1 https://github.com/magicmonty/bash-git-prompt.git \
    ~/.bash-git-prompt
fi
pushd ~/.bash-git-prompt
echo "updating bash-git-prompt"
git pull
popd
log "bash-git-prompt configuration completed"

# --- base16-shell ------------------------------------------------------------

log "base16 shell configuration"
if [[ ! -d ~/.config/base16-shell ]]; then
  git clone https://github.com/chriskempson/base16-shell.git \
    ~/.config/base16-shell
fi
pushd ~/.config/base16-shell
echo "updating base16-shell"
git pull
popd
log "base16 shell configuration completed"

# --- Zsh / Oh-My-Zsh ---------------------------------------------------------

log "zsh configuration"
if [[ ! -d ~/.oh-my-zsh ]]; then
  sh -c "$(curl -fsSL \
    https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  git clone https://github.com/zsh-users/zsh-autosuggestions.git \
    "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
    "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
fi
pushd ~/.oh-my-zsh
echo "updating oh-my-zsh"
git pull
popd
safe_link "$basedir/zsh/zshbootstrap" ~/.zshrc
log "zsh configuration completed"

# --- Ghostty -----------------------------------------------------------------

log "ghostty configuration"
mkdir -p ~/.config/ghostty
safe_link "$basedir/configs/config.ghostty" ~/.config/ghostty/config.ghostty
log "ghostty configuration completed"

# --- tmux --------------------------------------------------------------------

if [[ $INSTALL_TMUX -eq 1 ]]; then
  log "tmux installation and configuration"
  if [[ ! -d ~/repos/tmux ]]; then
    echo "cloning tmux..."
    git clone https://github.com/tmux/tmux.git ~/repos/tmux
    echo "cloning and installing tmux tpm plugin manager..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  fi
  pushd ~/repos/tmux
  echo "updating tmux..."
  git pull
  echo "update complete"
  sh autogen.sh
  echo "tmux configure..."
  ./configure --prefix="${HOME}/.local"
  echo "tmux clean..."
  make clean
  echo "tmux build..."
  make
  echo "tmux install..."
  make install
  echo "tmux installed"
  popd
  safe_link "$basedir/.tmux.conf" ~/.tmux.conf
  log "tmux installation and configuration completed"
fi

# --- vim ---------------------------------------------------------------------

if [[ $INSTALL_VIM -eq 1 ]]; then
  log "vim install and configure"
  if [[ ! -d ~/repos/vim ]]; then
    echo "cloning vim..."
    git clone https://github.com/vim/vim.git ~/repos/vim
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    echo "install modern vim dependencies..."
  fi
  pushd ~/repos/vim
  echo "updating vim..."
  git pull
  echo "update complete"
  echo "vim clean..."
  make distclean
  echo "configuring vim..."
  ./configure --prefix="${HOME}/.local" \
    --with-features=huge \
    --disable-nls \
    --with-x \
    --enable-gui=gtk3 \
    --enable-multibyte=yes \
    --enable-cscope=yes \
    --with-tlib=ncurses \
    --enable-python3interp=dynamic \
    --with-python3-command=/usr/bin/python3 \
    --with-python3-config-dir="$(python3-config --configdir)" \
    --enable-luainterp=dynamic \
    --enable-rubyinterp=dynamic \
    --enable-perlinterp=dynamic \
    --enable-fail-if-missing \
    --disable-netbeans \
    --enable-fontset=yes
  echo "vim configured"
  echo "vim build..."
  make
  echo "make done"
  echo "vim install"
  make install
  echo "install done"
  popd
  safe_link "$basedir/vim/no_plugins.vimrc" ~/.vimrc
  log "vim install and configuration completed"
fi

# --- neovim ------------------------------------------------------------------

if [[ $INSTALL_NVIM -eq 1 ]]; then
  log "neovim install and configure"
  if [[ ! -d ~/repos/neovim ]]; then
    echo "clone neovim from repo..."
    git clone https://github.com/neovim/neovim.git ~/repos/neovim
  fi
  pushd ~/repos/neovim
  echo "updating neovim..."
  git pull
  echo "update complete"
  echo "neovim clean..."
  rm -rf build/
  echo "neovim build..."
  make CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=${HOME}/.local" \
    CMAKE_BUILD_TYPE=Release
  echo "neovim compiled."
  echo "install neovim"
  make install
  echo "install done"
  cargo install tree-sitter-cli
  popd
  log "neovim setup completed"
fi

# --- Misc --------------------------------------------------------------------

log "do misc"
echo "ssh configuration"
mkdir -p ~/.ssh
chmod 0700 ~/.ssh

echo "ignore file"
safe_link "$basedir/.agignore" ~/.agignore

echo "add .profile"
safe_link "$basedir/.profile" ~/.profile
log "misc done"

# --- Fonts -------------------------------------------------------------------

if [[ $INSTALL_FONTS -eq 1 ]]; then
  log "configure fonts"
  mkdir -p ~/.local/share/fonts

  install_nerd_font_family() {
    local family="$1"
    local version="${2:-v3.4.0}"
    local zip="${family}.zip"
    local url="https://github.com/ryanoasis/nerd-fonts/releases/download/${version}/${zip}"

    curl -fsSL -o "/tmp/${zip}" "$url"
    unzip -o "/tmp/${zip}" -d ~/.local/share/fonts/
    rm -f "/tmp/${zip}"
  }

  echo "Installing Source Code Pro"
  install_nerd_font_family "SourceCodePro"
  echo "Installing Fira Code"
  install_nerd_font_family "FiraCode"

  if command -v fc-cache >/dev/null 2>&1; then
    echo "Resetting font cache, this may take a moment..."
    fc-cache -f -v ~/.local/share/fonts
  fi
fi

echo -e "\nswitch to zsh:"
echo -e "\n\tchsh -s \$(command -v zsh)\n"

pause
exit 0
