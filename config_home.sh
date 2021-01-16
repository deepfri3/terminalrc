#!/usr/bin/bash
# Configure terminal environment

basedir=$(pwd)
echo "basedir=$basedir"
if [ ! -d ~/bin ]; then
    mkdir ~/bin
fi
if [ ! -d ~/Applications ]; then
    mkdir ~/Applications
fi

# bash configuration
echo -e "\n** bash configuration **\n"
if [ -f ~/.bashrc ]; then
    rm ~/.bashrc
fi
ln -s $basedir/bash/bashbootstrap ~/.bashrc
if [ -f ~/.dircolorsrc ]; then
    rm ~/.dircolorsrc
fi
ln -s $basedir/dotFiles/dotdircolorsrc ~/.dircolorsrc
echo "git prompt for bash"
if [ ! -d ~/.bash-git-prompt ]; then
    echo "need to download bash-git-prompt..."
    git clone https://github.com/magicmonty/bash-git-prompt.git ~/.bash-git-prompt --depth=1
fi
pushd ~/.bash-git-prompt
echo "updating bash-git-prompt"
git pull
echo "update complete"
popd

echo -e "\n** base16 shell configuration **\n"
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

echo -e "\n** zsh configuration **\n"
if [ ! -d ~/.oh-my-zsh ]; then
    echo "need to download oh my zsh..."
    wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi
pushd ~/.oh-my-zsh
echo "updating oh-my-zsh"
git pull
echo "update complete"
popd
if [ -f ~/.zshrc ]; then
    rm ~/.zshrc
fi
ln -s $basedir/zsh/zshbootstrap ~/.zshrc

echo -e "\n** tmux installation and configuration **\n"
# tmux installation and configuration
if [ ! -d ~/Downloads/tmux ]; then
    echo "need to download tmux..."
    git clone https://github.com/tmux/tmux.git ~/Downloads/tmux
    # setup tmux plugins
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi
pushd ~/Downloads/tmux
echo "updating tmux..."
git pull
echo "update complete"
sh autogen.sh
./configure && make
if [ -f ~/bin/tmux ]; then
    rm ~/bin/tmux
fi
ln -s ~/Downloads/tmux/tmux ~/bin/tmux
popd
#ostmuxconf=tmux-`uname`
#localtmuxconf=$ostmuxconf-`hostname | cut -d. -f1`
#echo -e "\n# default resurrect dir" > ~/.tmux.conf
#echo -e "set -g @resurrect-dir '~/.tmux/resurrect/$localtmuxconf'\n" >> ~/.tmux.conf
#echo -e "source-file ~/.tmux-main.conf\n" >> ~/.tmux.conf
if [ -f ~/.tmux.conf ]; then
    rm ~/.tmux.conf
fi
ln -s $basedir/dotFiles/dottmuxdotconf ~/.tmux.conf

# vim install and configure links
#echo -e "\n** vim install and configure **\n"
#if [ ! -d ~/Downloads/vim ]; then
    #echo "need to download vim..."
    #git clone https://github.com/vim/vim.git ~/Downloads/vim
    #curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        #https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
#fi
#pushd ~/Downloads/vim
#echo "updating vim..."
#git pull
#echo "update complete"
#echo "configuring vim..."
#./configure --prefix=~/Applicatons/vim \
#--with-features=huge \
#--disable-nls \
#--enable-multibyte=yes \
#--enable-cscope=yes \
#--with-tlib=ncurses \
#--enable-python3interp \
#--with-python3-config-dir=$(python3-config --configdir) \
#--enable-luainterp=yes \
#--enable-rubyinterp=yes \
#--enable-perlinterp=yes \
#--with-ruby-command=/usr/bin/ruby \
#--enable-fontset=yes > log_configure.txt
#echo "vim configured"
#echo "make and install"
#make
#echo "make done"
#make install
#echo "install done"
#popd
#rm ~/bin/vim ~/bin/gvim
#ln -s ~/Applications/vim/bin/vim ~/bin/vim
#ln -s ~/Applications/vim/bin/gvim ~/bin/gvim
#rm ~/.vimrc
#ln -s $basedir/vim/vimrc.vim ~/.vimrc
#mkdir -p ~/.vim/undodir
#echo "vim setup completed"

# neovim install and configure links
echo -e "\n** neovim install and configure **\n"
if [ ! -d ~/Downloads/neovim ]; then
    echo "need to download neovim..."
    git clone https://github.com/neovim/neovim.git ~/Downloads/neovim
    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
fi
pushd ~/Downloads/neovim
echo "updating neovim..."
git pull
echo "update complete"
echo "make neovim..."
DISTRO=$(cat /etc/issue | cut -d\  -f1)
if [ $DISTRO == "Ubuntu" ]; then
    Ubuntu / Debian
    sudo apt-get install ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip
elif [ $DISTRO == "Arch" || $DISTRO == "Manjaro" ]; then
    Arch Linux
    sudo pacman -S base-devel cmake unzip ninja
fi
make CMAKE_INSTALL_PREFIX=/home/bakerg/Applications/neovim CMAKE_BUILD_TYPE=Release
echo "neovim compiled."
echo "install neovim"
make install
echo "install done"
popd
if [ -f ~/bin/nvim ]; then
    rm ~/bin/nvim
fi
ln -s ~/Applications/neovim/bin/nvim ~/bin/nvim
mkdir -p ~/.config/nvim
mkdir -p ~/.local/share/nvim/site/plugged
if [ -f ~/.config/nvim/init.vim ]; then
    rm ~/.config/nvim/init.vim
fi
ln -s $basedir/vim/init.vim ~/.config/nvim/init.vim
echo "neovim setup completed"

# install autojump
echo -e "\n** install autojump **\n"
if [ ! -d ~/Downloads/autojump ]; then
    echo "need to download autojump..."
    git clone git://github.com/wting/autojump.git ~/Downloads/autojump
fi
pushd ~/Downloads/autojump
echo "updating autojump..."
git pull
echo "update complete"
echo "install autojump"
python install.py
echo "install done"
popd

# install ag the silver searcher
echo -e "\n** install ag - the sliver searcher **\n"
if [ ! -d ~/Downloads/the_silver_searcher ]; then
    echo "need to download ag..."
    git clone https://github.com/ggreer/the_silver_searcher.git ~/Downloads/the_silver_searcher
fi
pushd ~/Downloads/the_silver_searcher
echo "updating ag..."
git pull
echo "update complete"
echo "install ag"
./build.sh
echo "install done"
popd
if [ -f ~/bin/ag ]; then
    rm ~/bin/ag
fi
ln ~/Downloads/the_silver_searcher/ag ~/bin/ag

echo -e "\n** install fzf **\n"
if [ ! -d ~/Downloads/fzf ]; then
    echo "need to download fzf..."
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/Downloads/fzf
fi
pushd ~/Downloads/fzf
echo "updating fzf..."
git pull
echo "update complete"
echo "install fzf"
./install
echo "install done"
popd

# Misc
echo -e "\n** do misc **\n"
echo "ssh configuration"
mkdir -p ~/.ssh
chmod 0740 ~/.ssh
echo "ignore file"
if [ -f ~/.agignore ]; then
    rm ~/.agignore
fi
ln -s $basedir/dotFiles/dotagignore ~/.agignore

# configure fonts
echo -e "\n** configure fonts **\n"
if [ ! -d ~/.local/share/fonts ]; then
    mkdir -p ~/.local/share/fonts
fi
# goto fonts directory and download...
pushd ~/.local/share/fonts
# Hack
curl -fLo "Hack Regular Nerd Font Mono.ttf" \
    https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Hack/Regular/complete/Hack%20Regular%20Nerd%20Font%20Complete%20Mono.ttf
#Inconsolata
curl -fLo "Inconsolata Regular Nerd Font Mono.ttf" \
    https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Inconsolata/complete/Inconsolata%20Regular%20Nerd%20Font%20Complete%20Mono.ttf
curl -fLo "Inconsolata Nerd Font Complete.ttf" \
    https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Inconsolata/complete/Inconsolata%20Regular%20Nerd%20Font%20Complete.ttf
#Source Code Pro
curl -fLo "Source Code Pro Regular Nerd Font Complete Mono.ttf" \
    https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/SourceCodePro/Regular/complete/Sauce%20Code%20Pro%20Nerd%20Font%20Complete%20Mono.ttf
curl -fLo "Source Code Pro Regular Nerd Font Complete.ttf" \
    https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/SourceCodePro/Regular/complete/Sauce%20Code%20Pro%20Nerd%20Font%20Complete.ttf
curl -fLo "Source Code Pro Semibold Nerd Font Complete Mono.ttf" \
    https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/SourceCodePro/Semibold/complete/Sauce%20Code%20Pro%20Semibold%20Nerd%20Font%20Complete%20Mono.ttf
curl -fLo "Source Code Pro Semibold Nerd Font Complete.ttf" \
    https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/SourceCodePro/Semibold/complete/Sauce%20Code%20Pro%20Semibold%20Nerd%20Font%20Complete.ttf
#JetBrainsMono
curl -fLo "JetBrains Regular Nerd Font Complete Mono.ttf" \
    https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/JetBrainsMono/Regular/complete/JetBrains%20Mono%20Regular%20Nerd%20Font%20Complete%20Mono.ttf
curl -fLo "JetBrains Regular Nerd Font Complete.ttf" \
    https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/JetBrainsMono/Regular/complete/JetBrains%20Mono%20Regular%20Nerd%20Font%20Complete.ttf
curl -fLo "JetBrains Medium Nerd Font Complete Mono.ttf" \
    https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/JetBrainsMono/Medium/complete/JetBrains%20Mono%20Medium%20Nerd%20Font%20Complete%20Mono.ttf
curl -fLo "JetBrains Medium Nerd Font Complete.ttf" \
    https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/JetBrainsMono/Medium/complete/JetBrains%20Mono%20Medium%20Nerd%20Font%20Complete.ttf
curl -fLo "JetBrains Bold Nerd Font Complete Mono.ttf" \
    https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/JetBrainsMono/Bold/complete/JetBrains%20Mono%20Bold%20Nerd%20Font%20Complete%20Mono.ttf
curl -fLo "JetBrains Bold Nerd Font Complete.ttf" \
    https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/JetBrainsMono/Bold/complete/JetBrains%20Mono%20Bold%20Nerd%20Font%20Complete.ttf
popd
# Reset font cache on Linux
if which fc-cache >/dev/null 2>&1 ; then
    echo "Resetting font cache, this may take a moment..."
    fc-cache -f -v ~/.local/share/fonts
fi

#if [ ! -d ~/Downloads/fonts ]; then
    #echo "need to download fonts..."
    #git clone https://github.com/powerline/fonts.git ~/Downloads/fonts/powerline
    #git clone https://github.com/JetBrains/JetBrainsMono.git ~/Downloads/fonts/JetBrainsMono
    #git clone https://github.com/Znuff/consolas-powerline.git ~/Downloads/fonts/consolas-powerline
    ## Copy all fonts to user fonts directory
    #echo "Copying fonts..."
    #find ~/Downloads/fonts \( -name "*.[ot]tf" -or -name "*.pcf.gz" \) -type f -print0 | xargs -0 -n1 -I % cp "%" ~/.local/share/fonts
    ## Reset font cache on Linux
    #if which fc-cache >/dev/null 2>&1 ; then
        #echo "Resetting font cache, this may take a moment..."
        #fc-cache -f -v ~/.local/share/fonts
    #fi
#fi

#restart applications that need the fonts
echo -e "\nswitch to zsh:"
echo -e "\n\tchsh -s \$(which zsh)\n"
