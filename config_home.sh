#!/usr/bin/bash
# Configure terminal environment

function pause(){
 read -s -n 1 -p "Press any key to continue . . ."
 echo ""
}

basedir=$(pwd)
echo "basedir=$basedir"

DISTRO=$(cat /etc/issue | cut -d\  -f1)
echo "disro=$DISTRO"

# install dependencies
echo -e "\n** Install dependencies **\n"
if [ $DISTRO == "Ubuntu" ]; then
    #Ubuntu / Debian
    sudo apt update && sudo apt -y upgrade
    sudo apt install -y \
        ninja-build gettext \
        libtool \
        libtool-bin \
        autoconf \
        automake \
        cmake \
        make \
        g++ \
        pkg-config \
        unzip \
        npm \
        curl \
        libevent-dev \
        libncurses-dev \
        bison \
        byacc \
        vim-gtk3 \
        libgtk2.0-dev \
        libx11-dev \
        libxt-dev \
        libgtk-3-dev \
        perl \
        libperl-dev \
        ruby \
        ruby-dev \
        python-pip-whl \
        python \
        python3-pip \
        python3-dev \
        neofetch \
        htop \
        autotools-dev \
        xsel \
        xclip \
        ripgrep \
        ctags \
        okular
    sudo snap install bpytop
    sudo snap install vlc
elif [ $DISTRO == "Arch" || $DISTRO == "Manjaro" ]; then
    #Arch Linux
    sudo pacman -S base-devel cmake unzip ninja
fi
echo -e "\n** Installation of dependencies completed **\n"

echo -e "\n** Determine desktop environment **\n"
if [ "$XDG_CURRENT_DESKTOP" = "" ]
then
  desktop=$(echo "$XDG_DATA_DIRS" | sed 's/.*\(xfce\|kde\|gnome\).*/\1/')
else
  desktop=`echo $XDG_CURRENT_DESKTOP | cut -d ':' -f 2`
fi
desktop=${desktop,,}  # convert to lower case
echo "Desktop Environment --> $desktop"

if [ $desktop == "gnome" ]; then
    if [ ! -d ~/.config/base16-gnome-terminal ]; then
        echo "cloning gnome base-16 theme..."
        git clone https://github.com/aaron-williamson/base16-gnome-terminal.git ~/.config/base16-gnome-terminal
        #install desired base-16 themes
        ~/.config/base16-gnome-terminal/color-scripts/base16-gruvbox-dark-hard.sh
    fi
fi

if [ ! -d ~/bin ]; then
    echo "~/bin doesn't exist...create it."
    mkdir ~/bin
fi
if [ ! -d ~/applications ]; then
    echo "~/applications doesn't exist...create it."
    mkdir ~/applications
fi


# i3 installation and configuration
#echo -e "\n** i3 installation configuration started **\n"
#if [ $DISTRO == "Ubuntu" ]; then
    #if [ ! -f ~/Downloads/keyring.deb ]; then
        #echo "Do the following manually:"
        #echo "pushd ~/Downloads"
        #echo "https://i3wm.org/docs/repositories.html"
        #echo "/usr/lib/apt/apt-helper download-file https://debian.sur5r.net/i3/pool/main/s/sur5r-keyring/sur5r-keyring_2021.02.02_all.deb keyring.deb SHA256:cccfb1dd7d6b1b6a137bb96ea5b5eef18a0a4a6df1d6c0c37832025d2edaa710"
        #echo "#sudo dpkg -i ./keyring.deb"
        #echo "\"deb [arch=amd64] http://debian.sur5r.net/i3/ $(grep '^DISTRIB_CODENAME=' /etc/lsb-release | cut -f2 -d=) universe\" >> /etc/apt/sources.list.d/sur5r-i3.list"
        #echo "sudo apt update"
        #echo "popd"
        #pause
        #sudo apt install -y i3 i3lock i3lock-fancy rofi
    #fi
    #if [ ! -d ~/.config/i3 ]; then
        #echo "~/.config/i3 doesn't exist...create it."
        #mkdir -p ~/.config/i3
    #fi
    #if [ ! -d ~/.config/i3status ]; then
        #echo "~/.config/i3status doesn't exist...create it."
        #mkdir -p ~/.config/i3status
    #fi
    #if [ -f ~/.Xresources ]; then
        #echo "~/.Xresources exists...remove it."
        #rm ~/.Xresources
    #fi
    #ln -s $basedir/dotFiles/dotXresources ~/.Xresources
    #if [ -f ~/.config/i3/config ]; then
        #echo "~/.config/i3/config exists...remove it."
        #rm ~/.config/i3/config
    #fi
    #ln -s $basedir/i3/i3config ~/.config/i3/config
    #if [ -f ~/.config/i3/config ]; then
        #echo "~/.config/i3/config exists...remove it."
        #rm ~/.config/i3/config
    #fi
    #ln -s $basedir/i3/i3config ~/.config/i3/config
    #if [ -f ~/.config/i3status/config ]; then
        #echo "~/.config/i3status/config exists...remove it."
        #rm ~/.config/i3status/config
    #fi
    #ln -s $basedir/i3/i3status ~/.config/i3status/config
    #if [ ! -d ~/.config/rofi/themes/gruvbox ]; then
        #echo "Install gruvbox theme for rofi..."
        #git clone https://github.com/bardisty/gruvbox-rofi ~/.config/rofi/themes/gruvbox
        #mkdir -p ~/.config/rofi
        #echo -e "rofi.theme: ~/.config/rofi/themes/gruvbox/gruvbox-dark.rasi\n" > ~/.config/rofi/config
    #fi
    #sudo cp $basedir/configuration/wakelock.service /etc/systemd/system
    #sudo systemctl enable wakelock.service
#fi
#echo -e "\n** i3 installation and configuration completed **\n"

# bash configuration
echo -e "\n** bash configuration started **\n"
if [ -f ~/.bashrc ]; then
    echo "~/.bashrc exists...remove it."
    rm ~/.bashrc
fi
ln -s $basedir/bash/bashbootstrap ~/.bashrc
#if [ -f ~/.dircolorsrc ]; then
#    echo "~/.dircolorsrc exists...remove it."
#    rm ~/.dircolorsrc
#fi
#ln -s $basedir/dotFiles/dotdircolorsrc ~/.dircolorsrc
echo -e "\n** bash configuration completed **\n"

echo -e "\n** bash-git-promt configuration started **\n"
echo "git prompt for bash"
if [ ! -d ~/.bash-git-prompt ]; then
    echo "cloning bash-git-prompt..."
    git clone https://github.com/magicmonty/bash-git-prompt.git ~/.bash-git-prompt --depth=1
fi
pushd ~/.bash-git-prompt
echo "updating bash-git-prompt"
git pull
echo "update complete"
popd
echo -e "\n** bash-git-promt configuration completed **\n"

echo -e "\n** base16 shell configuration started **\n"
# add base16-shell (https://github.com/chriskempson/base16-shell)
if [ ! -d ~/.config/base16-shell ]; then
    echo "need to download base16-shell..."
    git clone https://github.com/chriskempson/base16-shell.git ~/.config/base16-shell
fi
pushd ~/.config/base16-shell
echo "updating base16-shell"
git pull
echo "update complete"
popd
echo -e "\n** base16 shell configuration completed **\n"

echo -e "\n** zsh configuration start **\n"
if [ ! -d ~/.oh-my-zsh ]; then
    echo "go download oh my zsh!..."
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi
pushd ~/.oh-my-zsh
echo "updating oh-my-zsh"
git pull
echo "update complete"
popd
if [ -f ~/.zshrc ]; then
    echo "~/.zshrc exists...remove it."
    rm ~/.zshrc
fi
ln -s $basedir/zsh/zshbootstrap ~/.zshrc
echo -e "\n** zsh configuration completed **\n"

echo -e "\n** tmux installation and configuration **\n"
# tmux installation and configuration
if [ ! -d ~/repositories/tmux ]; then
    echo "cloning tmux..."
    git clone https://github.com/tmux/tmux.git ~/repositories/tmux
    # setup tmux plugins
    echo "cloning and installing tmux tpm plugin manager..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi
pushd ~/repositories/tmux
echo "updating tmux..."
git pull
echo "update complete"
sh autogen.sh
echo "tmux configure..."
./configure --prefix=/home/bakerg/applications > log_configure.txt
[ $? -eq 0 ] && echo "OK" || echo "ERROR"
echo "tmux clean..."
make clean > /dev/null
[ $? -eq 0 ] && echo "OK" || echo "ERROR"
echo "tmux build..."
make > /dev/null
[ $? -eq 0 ] && echo "OK" || echo "ERROR"
echo "tmux install..."
make install > /dev/null
[ $? -eq 0 ] && echo "OK" || echo "ERROR"
if [ -f ~/bin/tmux ]; then
    echo "~/bin/tmux exists...remove it."
    rm ~/bin/tmux
fi
ln -s ~/applications/bin/tmux ~/bin/tmux
echo "tmux installed"
popd
if [ -f ~/.tmux.conf ]; then
    echo "~/.tmux.conf exists...remove it."
    rm ~/.tmux.conf
fi
ln -s $basedir/dotFiles/dottmuxdotconf ~/.tmux.conf
#ostmuxconf=tmux-`uname`
#localtmuxconf=$ostmuxconf-`hostname | cut -d. -f1`
#echo -e "\n# default resurrect dir" > ~/.tmux.conf
#echo -e "set -g @resurrect-dir '~/.tmux/resurrect/$localtmuxconf'\n" >> ~/.tmux.conf
#echo -e "source-file $basedir/dotFiles/dottmuxdotconf\n" >> ~/.tmux.conf
echo -e "\n** tmux installation and configuration completed **\n"

# vim install and configure links
echo -e "\n** vim install and configure started **\n"
if [ ! -d ~/repositories/vim ]; then
    echo "cloning vim..."
    git clone https://github.com/vim/vim.git ~/repositories/vim
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    echo -e "install modern vim dependencies..."
fi
pushd ~/repositories/vim
echo "updating vim..."
git pull
echo "update complete"
echo "vim clean..."
make distclean > /dev/null
[ $? -eq 0 ] && echo "OK" || echo "ERROR"
echo "configuring vim..."
./configure --prefix=/home/bakerg/applications \
--with-features=huge \
--disable-nls \
--with-x \
--enable-gtk2-check \
--enable-gui=auto \
--enable-multibyte=yes \
--enable-cscope=yes \
--with-tlib=ncurses \
--enable-pythoninterp \
--with-python-command=/usr/bin/python2.7 \
--enable-python3interp \
--with-python3-command=/usr/bin/python3 \
--with-python3-config-dir=$(python3-config --configdir) \
--enable-luainterp=yes \
--enable-rubyinterp=yes \
--enable-perlinterp=yes \
--with-ruby-command=/usr/bin/ruby \
--enable-fontset=yes > log_configure.txt
[ $? -eq 0 ] && echo "OK" || echo "ERROR"
echo "vim configured"
echo "vim build..."
make > /dev/null
[ $? -eq 0 ] && echo "OK" || echo "ERROR"
echo "make done"
echo "vim install"
make install > /dev/null
[ $? -eq 0 ] && echo "OK" || echo "ERROR"
echo "install done"
popd
if [ -f ~/bin/vim ]; then
    echo "~/bin/vim exists...remove it."
    rm ~/bin/vim
fi
ln -s ~/applications/bin/vim ~/bin/vim
if [ -f ~/bin/gvim ]; then
    echo "~/bin/gvim exists...remove it."
    rm ~/bin/gvim
fi
ln -s ~/applications/bin/gvim ~/bin/gvim
if [ -f ~/.vimrc ]; then
    echo "~/.vimrc exists...remove it."
    rm ~/.vimrc
fi
ln -s $basedir/vim/no_plugins.vimrc ~/.vimrc
echo -e "\n** vim install and configuration completed **\n"

# neovim install and configure links
echo -e "\n** neovim install and configure **\n"
if [ ! -d ~/respositories/neovim ]; then
    echo "clone neovim from repo..."
    git clone https://github.com/neovim/neovim.git ~/repositories/neovim
    echo "download from plug.vim and install..."
    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
fi
pushd ~/repositories/neovim
echo "updating neovim..."
git pull
echo "update complete"
echo "make neovim..."
echo "neovim clean..."
make CMAKE_INSTALL_PREFIX=/home/bakerg/applications CMAKE_BUILD_TYPE=Release distclean > /dev/null
[ $? -eq 0 ] && echo "OK" || echo "ERROR"
echo "neovim build..."
make CMAKE_INSTALL_PREFIX=/home/bakerg/applications CMAKE_BUILD_TYPE=Release all > /dev/null
[ $? -eq 0 ] && echo "OK" || echo "ERROR"
echo "neovim compiled."
echo "install neovim"
make install > /dev/null
[ $? -eq 0 ] && echo "OK" || echo "ERROR"
echo "install done"
popd
if [ -f ~/bin/nvim ]; then
    echo "~/bin/nvim exists...remove it."
    rm ~/bin/nvim
fi
ln -s ~/applications/bin/nvim ~/bin/nvim
mkdir -p ~/.config/nvim
mkdir -p ~/.local/share/nvim/site/plugged
if [ -f ~/.config/nvim/init.vim ]; then
    echo "init.vim exists...remove it."
    rm ~/.config/nvim/init.vim
fi
ln -s $basedir/vim/init.vim ~/.config/nvim/init.vim
echo "neovim setup completed"


# install autojump
# https://github.com/wting/autojump
echo -e "\n** install autojump **\n"
if [ $DISTRO == "Ubuntu" ]; then
    sudo apt-get install -y autojump
    # autojump (https://github.com/wting/autojump)
    # configured for Debian
    # add to terminalrc
    #[[ -s /usr/share/autojump/autojump.sh ]] && source /usr/share/autojump/autojump.sh
fi
echo "install done"
:<<'END'
if [ ! -d ~/applications/autojump ]; then
    echo "cloning autojump..."
    git clone git://github.com/wting/autojump.git ~/applications/autojump
fi
pushd ~/applications/autojump
echo "updating autojump..."
git pull
echo "update complete"
echo "install autojump"
python uninstall.py
python install.py
echo "install done"
popd
END

# install ag the silver searcher
# https://github.com/ggreer/the_silver_searcher
echo -e "\n** install ag - the sliver searcher **\n"
if [ $DISTRO == "Ubuntu" ]; then
    sudo apt-get install -y silversearcher-ag
fi
echo "install done"
:<<'END'
if [ ! -d ~/applications/the_silver_searcher ]; then
    echo "cloning ag..."
    git clone https://github.com/ggreer/the_silver_searcher.git ~/applications/the_silver_searcher
fi
pushd ~/applications/the_silver_searcher
echo "updating ag..."
git pull
echo "update complete"
echo "install ag"
./build.sh
popd
if [ -f ~/bin/ag ]; then
    rm ~/bin/ag
fi
ln ~/Downloads/the_silver_searcher/ag ~/bin/ag
echo "install done"
END

echo -e "\n** install fzf **\n"
if [ $DISTRO == "Ubuntu" ]; then
    # fzf - fuzzy finder (https://github.com/junegunn/fzf)
    sudo apt-get install -y fzf
    # configured for Debian
    echo "add to terminalrc:"
    echo "source /usr/share/doc/fzf/examples/key-bindings.zsh"
    echo "source /usr/share/doc/fzf/examples/completion.zsh"
    pause
fi
echo "install done"
:<<'END'
# https://github.com/junegunn/fzf
if [ ! -d ~/applications/fzf ]; then
    echo "cloning fzf..."
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/applications/fzf
fi
pushd ~/applications/fzf
echo "updating fzf..."
git pull
echo "update complete"
echo "clean and install fzf"
./install
echo "install done"
popd
END

# install pCloud
echo -e "\n** pcloud installation **\n"
if [ ! -f ~/bin/pcloud ]; then
    echo "Go download pcloud appimage to ~/applications/appimages"
    pause
    chmod +x ~/applications/appimages/pcloud
    echo "download completed"
fi
if [ -f ~/bin/pcloud ]; then
    echo "~/bin/pcloud exists...remove it."
    rm ~/bin/pcloud
fi
ln -s ~/applications/appimages/pcloud ~/bin/pcloud
if [ -f ~/.local/share/applications/pcloud.desktop ]; then
    rm ~/.local/share/applications/pcloud.desktop
fi
ln -s $basedir/configuration/pcloud-dmenu.desktop ~/.local/share/applications/pcloud.desktop
if [ -f ~/.config/autostart/pcloud.desktop ]; then
    rm ~/.config/autostart/pcloud.desktop
fi
ln -s $basedir/configuration/pcloud-autostart.desktop ~/.config/autostart/pcloud.desktop
cp $basedir/configuration/pcloud.png ~/applications/appimages
echo -e "\n** pcloud installation completed  **\n"

# install UHK
echo -e "\n** UHK installation **\n"
if [ ! -f ~/applications/appimages/uhk ]; then
    echo "Go download latest UHK ~/applications/appimages"
    pause
    chmod +x ~/applications/appimages/uhk
fi
if [ -f ~/bin/uhk ]; then
    echo "~/bin/uhk exists...remove it."
    rm ~/bin/uhk
fi
ln -s ~/applications/appimages/uhk ~/bin/uhk
cp $basedir/configuration/uhk.desktop ~/.local/share/applications
cp $basedir/configuration/uhk.jpeg ~/applications/appimages
echo -e "\n** UHK installation completed  **\n"

# Misc
echo -e "\n** do misc **\n"
echo "ssh configuration"
mkdir -p ~/.ssh
chmod 0740 ~/.ssh
echo "ignore file"
if [ -f ~/.agignore ]; then
    rm ~/.agignore
fi
echo "agignore"
ln -s $basedir/dotFiles/dotagignore ~/.agignore
echo "1password dmenu entry"
if [ -f ~/.config/autostart/1password.desktop ]; then
    rm ~/.config/autostart/1password.desktop
fi
ln -s $basedir/configuration/1password.desktop ~/.config/autostart/1password.desktop
echo "add .profile"
if [ -f ~/.profile ]; then
    echo "~/.profile exists...remove it."
    rm ~/.profile
fi
ln -s $basedir/dotFiles/dotProfile ~/.profile
echo -e "\n** misc done **\n"

# configure fonts
echo -e "\n** configure fonts **\n"
if [ ! -d ~/.local/share/fonts ]; then
    mkdir -p ~/.local/share/fonts
fi
# goto fonts directory and download...
pushd ~/.local/share/fonts
echo -e "Downloading Source Code Pro\n"
curl -fLO https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/SourceCodePro/Regular/SauceCodeProNerdFont-Regular.ttf
curl -fLO https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/SourceCodePro/Regular/SauceCodeProNerdFontMono-Regular.ttf
curl -fLO https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/SourceCodePro/Medium/SauceCodeProNerdFont-Medium.ttf
curl -fLO https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/SourceCodePro/Medium/SauceCodeProNerdFontMono-Medium.ttf
echo -e "Downloading Fira Code\n"
curl -fLO https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/FiraCode/Regular/FiraCodeNerdFont-Regular.ttf
curl -fLO https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/FiraCode/Regular/FiraCodeNerdFontMono-Regular.ttf
curl -fLO https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/FiraCode/Medium/FiraCodeNerdFont-Medium.ttf
curl -fLO https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/FiraCode/Medium/FiraCodeNerdFontMono-Medium.ttf
popd
# Reset font cache on Linux
if which fc-cache >/dev/null 2>&1 ; then
    echo "Resetting font cache, this may take a moment..."
    fc-cache -f -v ~/.local/share/fonts
fi

#restart applications that need the fonts
echo -e "\nswitch to zsh:"
echo -e "\n\tchsh -s \$(which zsh)\n"

pause
exit
