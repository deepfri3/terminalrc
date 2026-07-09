
Installing Ag for vim

Dependencies:
apt-get install -y automake pkg-config libpcre3-dev zlib1g-dev liblzma-dev

1a) install Ag - the silver searcher from sources
https://github.com/ggreer/the_silver_searcher
or
1b) install using apt-get
Ubuntu >= 13.10 (Saucy) or Debian >= 8 (Jessie)
apt-get install silversearcher-ag

2) install Ag vim plugin for frontend integration
https://github.com/rking/ag.vim

FZF

Main page
https://github.com/junegunn/fzf

Vim plugin for Fzf
https://github.com/junegunn/fzf.vim

Configurin for Vim
https://github.com/junegunn/fzf/wiki/Configuring-FZF-command-(vim)

Add to bashrc:
# fzf - fuzzy finder
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
# Setting ag as the default source for fzf
export FZF_DEFAULT_COMMAND='ag -l -g ""'
# Apply the command to CTRL-T as well
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

Add to vimrc:
" Default fzf layout
let g:fzf_layout = { 'down': '40%' } 
set rtp+=~/Dropbox/Linux/common/fzf

to install per environment:
run fzf/install script
run fzf_manual_install.sh script
