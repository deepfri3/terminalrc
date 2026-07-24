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
INSTALL_UV=0
INSTALL_STARSHIP=0
INSTALL_FZF=0
INSTALL_GO=0
INSTALL_LAZYGIT=0
INSTALL_GIT=0
INSTALL_PACKAGES=0
INSTALL_ZSH=0
INSTALL_BASH=0

usage() {
  cat <<EOF
Usage: $0 [OPTIONS]

Setup terminal environment.

Options:
  --all      Install tmux, vim, neovim, and fonts (default if no options given)
  --tmux     Compile and install tmux
  --vim      Compile and install vim
  --nvim     Compile and install neovim
  --fonts    Download and install latest fonts
  --uv       Download and install uv executable
  --starship Download and install starship executable
  --fzf      Download and install fzf executable
  --go       Download and install latest Go
  --lazy     Download and install lazygit
  --git      Compile and install git
  --packages Install system packages
  --zsh      Configure and setup zsh
  --bash     Configure and setup bash
  --help     Show this help message
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
  --all) INSTALL_ALL=1 ;;
  --tmux) INSTALL_TMUX=1 ;;
  --vim) INSTALL_VIM=1 ;;
  --nvim) INSTALL_NVIM=1 ;;
  --fonts) INSTALL_FONTS=1 ;;
  --uv) INSTALL_UV=1 ;;
  --starship) INSTALL_STARSHIP=1 ;;
  --fzf) INSTALL_FZF=1 ;;
  --go) INSTALL_GO=1 ;;
  --lazy) INSTALL_LAZYGIT=1 ;;
  --git) INSTALL_GIT=1 ;;
  --packages) INSTALL_PACKAGES=1 ;;
  --zsh) INSTALL_ZSH=1 ;;
  --bash) INSTALL_BASH=1 ;;
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
  INSTALL_UV=1
  INSTALL_STARSHIP=1
  INSTALL_FZF=1
  INSTALL_GO=1
  INSTALL_LAZYGIT=1
  INSTALL_GIT=1
  INSTALL_PACKAGES=1
  INSTALL_ZSH=1
  INSTALL_BASH=1
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

# github_latest_tag <repo> [strip_v]
github_latest_tag() {
  local repo="$1" strip="${2:-1}"
  local pat='"tag_name": *"\K[^"]*'
  [[ "$strip" == "1" ]] && pat='"tag_name": *"v\K[^"]*'
  curl -fsSL "https://api.github.com/repos/${repo}/releases/latest" \
    | grep -Po "$pat" || true
}

mkdir -p ~/.local/bin
basedir=$(pwd)
echo "basedir=$basedir"

# --- Packages ------------------------------------------------------------
if [[ $INSTALL_PACKAGES -eq 1 ]]; then
  log "Install packages"

  DISTRO=$(grep '^ID=' /etc/os-release | cut -d= -f2 | tr -d '"')
  echo "distro=$DISTRO"

  # Helper: returns 0 if distro is RHEL/Alma/Rocky/CentOS/Fedora
  is_rhel_family() {
    case "$DISTRO" in
      rhel|almalinux|rocky|centos|fedora) return 0 ;;
      *) return 1 ;;
    esac
  }

  if [[ "$DISTRO" == "debian" ]]; then
	pkg_is_installed() {
	  dpkg-query -W -f='${Status}' "$1" 2>/dev/null | grep -q "install ok installed"
	}

	packages=(
	  ninja-build gettext libtool libtool-bin autoconf automake cmake make g++
	  pkg-config unzip curl libevent-dev libncurses-dev bison byacc libx11-dev
	  libxt-dev libgtk-3-dev zsh perl libperl-dev ruby ruby-dev python3-pip
	  python3-dev btop autotools-dev xsel xclip ripgrep universal-ctags snapd
	  fd-find cargo wl-clipboard libcurl4-openssl-dev libexpat1-dev libssl-dev
	  zlib1g-dev
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

	snap_is_installed() {
	  snap list "$1" >/dev/null 2>&1
	}

	if ! snap_is_installed ghostty; then
	  sudo snap install ghostty --classic
	  log "ghostty configuration"
	  mkdir -p ~/.config/ghostty
	  safe_link "$basedir/configs/config.ghostty" ~/.config/ghostty/config.ghostty
	  log "ghostty configuration completed"
	else
	  echo "ghostty already installed via snap, skipping"
	fi

	if ! snap_is_installed zig; then
	  sudo snap install zig --beta --classic
	else
	  echo "zig already installed via snap, skipping"
	fi

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
	  log "Fastfetch installed"
	else
	  echo "fastfetch already installed ($(fastfetch --version | head -n1)), skipping"
	fi
  elif is_rhel_family; then
    pkg_is_installed() {
      rpm -q "$1" &>/dev/null
    }

    # Enable required repos (EPEL + CRB/PowerTools for extra packages)
    if ! rpm -q epel-release &>/dev/null; then
      sudo dnf install -y epel-release
    fi
    # CRB (CodeReady Builder) — needed on RHEL/Alma/Rocky for devel packages
    if sudo dnf repolist | grep -qiE 'crb|codeready|powertools'; then
      sudo dnf config-manager --set-enabled crb 2>/dev/null \
        || sudo dnf config-manager --set-enabled powertools 2>/dev/null \
        || true
    fi

    packages=(
      ninja-build gettext libtool autoconf automake cmake make gcc-c++
      pkgconfig unzip curl libevent-devel ncurses-devel bison byacc
      libX11-devel libXt-devel gtk3-devel zsh perl perl-devel ruby ruby-devel
      python3-pip python3-devel btop xsel xclip ripgrep ctags
      fd-find cargo wl-clipboard libcurl-devel expat-devel openssl-devel
      zlib-devel snapd
    )

    missing=()
    for pkg in "${packages[@]}"; do
      if ! pkg_is_installed "$pkg"; then
        missing+=("$pkg")
      fi
    done

    if [[ ${#missing[@]} -gt 0 ]]; then
      log "Installing missing packages: ${missing[*]}"
      sudo dnf install -y "${missing[@]}"
    else
      echo "All dnf packages already installed"
    fi

    # fd-find installs as 'fd' on RHEL family (no fdfind alias needed)
    if command -v fd >/dev/null 2>&1 && [[ ! -x ~/.local/bin/fd ]]; then
      mkdir -p ~/.local/bin
      ln -sf "$(command -v fd)" ~/.local/bin/fd
    fi

    # Enable and start snapd (required for ghostty/zig snaps)
    if ! systemctl is-enabled snapd &>/dev/null; then
      sudo systemctl enable --now snapd.socket
      sudo ln -sf /var/lib/snapd/snap /snap 2>/dev/null || true
      sleep 2  # give snapd a moment to initialise
    fi

    snap_is_installed() {
      snap list "$1" >/dev/null 2>&1
    }

    if ! snap_is_installed ghostty; then
      sudo snap install ghostty --classic
      log "ghostty configuration"
      mkdir -p ~/.config/ghostty
      safe_link "$basedir/configs/config.ghostty" ~/.config/ghostty/config.ghostty
      log "ghostty configuration completed"
    else
      echo "ghostty already installed via snap, skipping"
    fi

    if ! snap_is_installed zig; then
      sudo snap install zig --beta --classic
    else
      echo "zig already installed via snap, skipping"
    fi

    log "Install fastfetch"
    if ! command -v fastfetch >/dev/null 2>&1; then
      FASTFETCH_VERSION=$(curl -fsSL \
        "https://api.github.com/repos/fastfetch-cli/fastfetch/releases/latest" |
        grep -Po '"tag_name": *"\K[^"]*' || true)

      [[ -z "$FASTFETCH_VERSION" ]] && {
        echo "Could not determine fastfetch version" >&2
        exit 1
      }

      curl -fsSL -o /tmp/fastfetch-linux-amd64.rpm \
        "https://github.com/fastfetch-cli/fastfetch/releases/download/${FASTFETCH_VERSION}/fastfetch-linux-amd64.rpm"

      sudo rpm -i /tmp/fastfetch-linux-amd64.rpm
      rm -f /tmp/fastfetch-linux-amd64.rpm
      log "Fastfetch installed"
    else
      echo "fastfetch already installed ($(fastfetch --version | head -n1)), skipping"
    fi
  fi
  log "Installation of packages completed"
fi

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
else
  echo "Unknown (or no) desktop environment!"
fi

# --- Bash --------------------------------------------------------------------
if [[ $INSTALL_BASH -eq 1 ]]; then
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

  log "bash configuration"
  safe_link "$basedir/bash/bashbootstrap" ~/.bashrc
  log "bash configuration completed"
fi

# --- Zsh / Oh-My-Zsh ---------------------------------------------------------
if [[ $INSTALL_ZSH -eq 1 ]]; then
  log "zsh configuration"
  safe_link "$basedir/zsh/zshbootstrap" ~/.zshrc
  log "zsh configuration completed"

  mkdir -p $HOME/.zsh
  if [[ ! -d $HOME/.zsh/zsh-autosuggestions ]]; then
    echo "Install zsh-autosuggestions plugin"
    git clone https://github.com/zsh-users/zsh-autosuggestions.git $HOME/.zsh/zsh-autosuggestions
  else
    echo "Updating zsh-autosuggestions plugin"
    pushd $HOME/.zsh/zsh-autosuggestions
    git pull
    popd
  fi
  if [[ ! -d $HOME/.zsh/fast-syntax-highlighting ]]; then
    echo "Install fast-syntax-highlighting plugin"
    git clone https://github.com/zdharma-continuum/fast-syntax-highlighting $HOME/.zsh/fast-syntax-highlighting
  else
    echo "Updating fast-syntax-highlighting plugin"
    pushd $HOME/.zsh/fast-syntax-highlighting
    git pull
    popd
  fi
fi

# --- lazygit ----------------------------------------------------------------------
if [[ $INSTALL_LAZYGIT -eq 1 ]]; then
  log "Install lazygit"
  LAZYGIT_VERSION=$(curl -fsSL \
	"https://api.github.com/repos/jesseduffield/lazygit/releases/latest" |
	grep -Po '"tag_name": *"v\K[^"]*') || true
  [[ -z "$LAZYGIT_VERSION" ]] && {
	echo "Could not fetch lazygit version" >&2
	exit 1
  }

  LAZYGIT_ARCH="Linux_x86_64"
  curl -fsSL -o /tmp/lazygit.tar.gz \
	"https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_${LAZYGIT_ARCH}.tar.gz"
  tar -xf /tmp/lazygit.tar.gz -C /tmp lazygit
  sudo install /tmp/lazygit -D -t /usr/local/bin/
  rm -rf /tmp/lazygit.tar.gz /tmp/lazygit
fi

# --- Go ----------------------------------------------------------------------
if [[ $INSTALL_GO -eq 1 ]]; then
  log "Install Go"
  GO_ARCH="linux-amd64"

  install_go() {
    local version
    version=$(curl -fsSL "https://go.dev/VERSION?m=text" | head -n1 || true)

    [[ -z "$version" ]] && {
      echo "Could not determine latest Go version" >&2
      return 1
    }

    local tarball="${version}.${GO_ARCH}.tar.gz"
    local url="https://go.dev/dl/${tarball}"

    echo "Downloading Go ${version} for ${GO_ARCH}..."
    curl -fsSL -o "/tmp/${tarball}" "$url"

    echo "Removing previous Go installation..."
    sudo rm -rf /usr/local/go

    echo "Extracting Go to /usr/local..."
    sudo tar -C /usr/local -xzf "/tmp/${tarball}"

    rm -f "/tmp/${tarball}"
  }

  if ! command -v go >/dev/null 2>&1; then
    install_go
    log "Go installed"
  else
    current=$(go version | awk '{print $3}')
    latest=$(curl -fsSL "https://go.dev/VERSION?m=text" | head -n1 || true)

    if [[ -n "$latest" && "$current" != "$latest" ]]; then
      echo "Go ${current} installed, updating to ${latest}..."
      install_go
      log "Go installed"
    else
      echo "Go ${current} already installed and up to date, skipping"
    fi
  fi
fi

# --- fzf ----------------------------------------------------------------------
if [[ $INSTALL_FZF -eq 1 ]]; then
  log "Install fzf"
  install_fzf() {
	local version
	version=$(curl -fsSL "https://api.github.com/repos/junegunn/fzf/releases/latest" \
	  | grep -Po '"tag_name": *"v\K[^"]*' || true)

	[[ -z "$version" ]] && {
	  echo "Could not determine latest fzf version" >&2
	  return 1
	}

	local tarball="fzf-${version}-linux_amd64.tar.gz"
	local url="https://github.com/junegunn/fzf/releases/download/v${version}/${tarball}"

	echo "Downloading fzf ${version} for linux_amd64..."
	curl -fsSL -o "/tmp/${tarball}" "$url"

	echo "Extracting fzf to ~/.local/bin..."
	tar -xzf "/tmp/${tarball}" -C ~/.local/bin fzf
	chmod +x ~/.local/bin/fzf

	rm -f "/tmp/${tarball}"
  }

  if ! command -v fzf >/dev/null 2>&1; then
	install_fzf
	log "fzf installed"
  else
	current=$(fzf --version | awk '{print $1}')
	latest=$(curl -fsSL "https://api.github.com/repos/junegunn/fzf/releases/latest" \
	  | grep -Po '"tag_name": *"v\K[^"]*' || true)

	if [[ -n "$latest" && "$current" != "$latest" ]]; then
	  echo "fzf ${current} installed, updating to ${latest}..."
	  install_fzf
	  log "fzf installed"
	else
	  echo "fzf ${current} already installed and up to date, skipping"
	fi
  fi
fi

# --- starship ----------------------------------------------------------------
if [[ $INSTALL_STARSHIP -eq 1 ]]; then
  log "Install starship"
  STARSHIP_ARCH="x86_64-unknown-linux-gnu"

  install_starship() {
	local version
	version=$(curl -fsSL "https://api.github.com/repos/starship/starship/releases/latest" \
	  | grep -Po '"tag_name": *"v\K[^"]*' || true)

	[[ -z "$version" ]] && {
	  echo "Could not determine latest starship version" >&2
	  return 1
	}

	local tarball="starship-${STARSHIP_ARCH}.tar.gz"
	local url="https://github.com/starship/starship/releases/download/v${version}/${tarball}"

	echo "Downloading starship ${version} for ${STARSHIP_ARCH}..."
	curl -fsSL -o "/tmp/${tarball}" "$url"

	echo "Extracting starship to ~/.local/bin..."
	tar -xzf "/tmp/${tarball}" -C ~/.local/bin starship
	chmod +x ~/.local/bin/starship

	rm -f "/tmp/${tarball}"
  }

  if ! command -v starship >/dev/null 2>&1; then
	install_starship
	log "starship installed"
  else
	current=$(starship --version | awk '{print $2}')
	latest=$(curl -fsSL "https://api.github.com/repos/starship/starship/releases/latest" \
	  | grep -Po '"tag_name": *"v\K[^"]*' || true)

	if [[ -n "$latest" && "$current" != "$latest" ]]; then
	  echo "starship ${current} installed, updating to ${latest}..."
	  install_starship
	  log "starship installed"
	else
	  echo "starship ${current} already installed and up to date, skipping"
	fi
  fi

  log "starship configuration"
  safe_link "$basedir/configs/starship.toml" ~/.config/starship.toml
  log "starship configuration completed"
fi

# --- uv ----------------------------------------------------------------------
if [[ $INSTALL_UV -eq 1 ]]; then
  log "Install uv"
  UV_ARCH="x86_64-unknown-linux-gnu"

  install_uv() {
	local version
	version=$(curl -fsSL \
	  "https://api.github.com/repos/astral-sh/uv/releases/latest" \
	  | grep -Po '"tag_name": *"\K[^"]*' || true)

	[[ -z "$version" ]] && {
	  echo "Could not determine latest uv version" >&2
	  return 1
	}

	local tarball="uv-${UV_ARCH}.tar.gz"
	local url="https://github.com/astral-sh/uv/releases/download/${version}/${tarball}"

	echo "Downloading uv ${version} for ${UV_ARCH}..."
	curl -fsSL -o "/tmp/${tarball}" "$url"

	echo "Extracting uv and uvx to ~/.local/bin..."
	tar -xzf "/tmp/${tarball}" -C /tmp
	install -m 0755 "/tmp/uv-${UV_ARCH}/uv" ~/.local/bin/uv
	install -m 0755 "/tmp/uv-${UV_ARCH}/uvx" ~/.local/bin/uvx

	rm -rf "/tmp/${tarball}" "/tmp/uv-${UV_ARCH}"
  }

  if ! command -v uv >/dev/null 2>&1; then
	install_uv
	log "uv installed"
  else
	current=$(uv --version | awk '{print $2}')
	latest=$(curl -fsSL \
	  "https://api.github.com/repos/astral-sh/uv/releases/latest" \
	  | grep -Po '"tag_name": *"\K[^"]*' || true)

	if [[ -n "$latest" && "$current" != "$latest" ]]; then
	  echo "uv ${current} installed, updating to ${latest}..."
	  install_uv
	  log "uv installed"
	else
	  echo "uv ${current} already installed and up to date, skipping"
	fi
  fi
fi
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
  safe_link "$basedir/vim/init.vim" ~/.vimrc
  log "vim install and configuration completed"
  mkdir -p ~/.vim/autoload
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
  popd
  safe_link "$basedir/vim/build-parsers.sh" ~/.config/nvim/build-parsers.sh
  ~/.config/nvim/build-parsers.sh
  log "neovim setup completed"
fi

# --- git ---------------------------------------------------------------------
if [[ $INSTALL_GIT -eq 1 ]]; then
  log "git installation"
  if [[ ! -d ~/repos/git ]]; then
    echo "cloning git..."
    git clone https://github.com/git/git.git ~/repos/git
  fi
  pushd ~/repos/git
  echo "updating git..."
  git pull
  echo "update complete"

  # Build the most recent stable tag rather than an in-progress master
  latest_tag=$(git tag -l 'v[0-9]*' --sort=-v:refname \
    | grep -v -- '-rc' | head -n1)
  if [[ -n "$latest_tag" ]]; then
    echo "checking out ${latest_tag}..."
    git checkout "$latest_tag"
  fi

  echo "git clean..."
  make distclean || true
  echo "git build..."
  make prefix="${HOME}/.local" -j"$(nproc)" all
  echo "git install..."
  make prefix="${HOME}/.local" install
  echo "git installed"
  popd
  log "git installation completed"
fi

# --- Misc --------------------------------------------------------------------
log "do misc"
echo "ssh configuration"
mkdir -p ~/.ssh
chmod 0700 ~/.ssh

echo "(rg)ignore file"
safe_link "$basedir/.rgignore" ~/.rgignore

# echo "add .profile"
# safe_link "$basedir/.profile" ~/.profile
# log "misc done"

# --- Fonts -------------------------------------------------------------------

if [[ $INSTALL_FONTS -eq 1 ]]; then
  log "configure fonts"
  mkdir -p ~/.local/share/fonts

  install_nerd_font_family() {
    local family="$1"
    local version="v$2"
    local zip="${family}.zip"
    local url="https://github.com/ryanoasis/nerd-fonts/releases/download/${version}/${zip}"

    curl -fsSL -o "/tmp/${zip}" "$url"
    unzip -o "/tmp/${zip}" -d ~/.local/share/fonts/
    rm -f "/tmp/${zip}"
  }

  latest_version=$(github_latest_tag "ryanoasis/nerd-fonts")
  echo "Nerd Fonts version=$latest_version"
  echo "Installing Source Code Pro"
  install_nerd_font_family "SourceCodePro" $latest_version
  echo "Installing Fira Code Mono"
  install_nerd_font_family "FiraMono" $latest_version
  echo "Installing Inconsolata"
  install_nerd_font_family "Inconsolata" $latest_version

  if command -v fc-cache >/dev/null 2>&1; then
    echo "Resetting font cache, this may take a moment..."
    fc-cache -f -v ~/.local/share/fonts
  fi
fi

if command -v zsh >/dev/null 2>&1; then
  echo "switch to zsh:"
  echo "    chsh -s \$(command -v zsh)"
fi

exit 0
