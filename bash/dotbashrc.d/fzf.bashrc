# fzf - fuzzy finder (https://github.com/junegunn/fzf)
# ag - the silver searcher (https://github.com/ggreer/the_silver_searcher/wiki)
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
# Setting ag as the default source for fzf
export FZF_DEFAULT_COMMAND='ag -l -g ""'
# Apply the command to CTRL-T as well
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

_gen_fzf_default_opts() {

# Base16 Tomorrow Night
# Author: Chris Kempson (http://chriskempson.com)
local color00='#1d1f21'
local color01='#282a2e'
local color02='#373b41'
local color03='#969896'
local color04='#b4b7b4'
local color05='#c5c8c6'
local color06='#e0e0e0'
local color07='#ffffff'
local color08='#cc6666'
local color09='#de935f'
local color0A='#f0c674'
local color0B='#b5bd68'
local color0C='#8abeb7'
local color0D='#81a2be'
local color0E='#b294bb'
local color0F='#a3685a'

export FZF_DEFAULT_OPTS="
  --color=bg+:$color01,bg:$color00,spinner:$color0C,hl:$color0D
  --color=fg:$color04,header:$color0D,info:$color0A,pointer:$color0C
  --color=marker:$color0C,fg+:$color06,prompt:$color0A,hl+:$color0D
"
# other default fzf options
#export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --ansi -m +x --bind ctrl-a:select-all,ctrl-d:deselect-all --height 50% --reverse --border"
#export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --ansi -m +x --bind ctrl-a:select-all,ctrl-d:deselect-all --height 50% --border"
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --ansi -m +x --bind ctrl-a:select-all,ctrl-d:deselect-all --height 50% --border --inline-info"

}
_gen_fzf_default_opts

# fd - cd to selected directory
fd() {
  local dir
  dir=$(find ${1:-*} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}

# fda - including hidden directories
fda() {
  local dir
  dir=$(find ${1:-.} -type d 2> /dev/null | fzf +m) && cd "$dir"
}

# fdr - cd to selected parent directory
fdr() {
  local declare dirs=()
  get_parent_dirs() {
    if [[ -d "${1}" ]]; then dirs+=("$1"); else return; fi
    if [[ "${1}" == '/' ]]; then
      for _dir in "${dirs[@]}"; do echo $_dir; done
    else
      get_parent_dirs $(dirname "$1")
    fi
  }
  local DIR=$(get_parent_dirs $(realpath "${1:-$(pwd)}") | fzf-tmux --tac)
  cd "$DIR"
}

# cdf - cd into the directory of the selected file
cdf() {
   local file
   local dir
   file=$(fzf +m -q "$1") && dir=$(dirname "$file") && cd "$dir"
}
