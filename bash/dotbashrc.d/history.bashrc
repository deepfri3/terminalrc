# Save bash history per directory
# http://www.compbiome.com/2010/07/bash-per-directory-bash-history.html
# Usage: mycd
# Replacement for builtin 'cd', which keeps a separate bash-history
# for every directory.
alias cd="mycd"
export HISTFILE="$HOME/.dir_bash_history$PWD/bash_history.txt"
hgrep (){ find $HISTFILE -type f|xargs grep -h $*; }

function mycd()
{
  history -w # write current history file
  builtin cd "$@" # do actual cd
  local HISTDIR="$HOME/.dir_bash_history$PWD" # use& nbsp;nested folders for history
  if [ ! -d "$HISTDIR" ]; then # create folder if neede d
    mkdir -p "$HISTDIR"
  fi
  export HISTFILE="$HISTDIR/bash_history.txt" # set& nbsp;new history file
  history -c # clear memory
  history -r #read from current histfile
}
