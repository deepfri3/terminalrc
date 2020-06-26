== shell commands ==
https://www.lopezferrando.com/30-interesting-shell-commands/

Speicial Bash environment variables
http://superuser.com/questions/247127/what-is-and-in-linux
http://linuxsig.org/files/bash_scripting.html

While you at it install these:
FZF - Main page
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

Installing Ag for vim
https://github.com/ggreer/the_silver_searcher - combine with FZF for very powerful CtrlP searching tool

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

== Autojump - smart cd == 

https://github.com/joelthelion/autojump

#autojump
[[ -s /home/bakerg/.autojump/etc/profile.d/autojump.sh ]] && source /home/bakerg/.autojump/etc/profile.d/autojump.sh

== Keep bash history per directory ==

add to bash rc:
hgrep (){ find ~/.dir_bash_history/ -type f|xargs grep -h $*;}

# Usage: mycd 
# Replacement for builtin 'cd', wh ich keeps a separate bash-history
# for every directory.
shopt -s histappend
alias cd="mycd"
export HISTFILE="$HOME/.dir_bash_history$PWD/bash_history.txt"

function mycd()
{
history -w # write current history file 
builtin cd "$@" # do actual c d 
local HISTDIR="$HOME/.dir_bash_history$PWD" # use& nbsp;nested folders for history 
if [ ! -d "$HISTDIR" ]; then # create folder if neede d 
mkdir -p "$HISTDIR"
fi
export HISTFILE="$HISTDIR/bash_history.txt" # set& nbsp;new history file 
history -c # clear memory 
history -r #read from current histfile 
}

== Setting vi mode in bash ==

If you only want to use this mode in Bash, an alternative is to use the following in your .bashrc, again with a login/logout or resourcing of the file:

set -o vi
You can check this has applied correctly with the following, which will spit out a list of the currently available bindings for a set of fixed possible actions for text:

$ bind -P

== UNIX command syntax reference == 

Abstract This article serves as a quick reference for the most commonly used shell scripting syntax. 
Introduction There are hundreds of UNIX commands that you can execute at the shell prompt. Shells have their own built-in syntax that helps you to work more effectively with existing commands by allowing you to perform functions like plugging commands into each other and controlling the flow of execution. 

Conditional execution operators 
|| 
You use the double pipe operator in the form 
command1 || command2 
In the above syntax, the second command executes only if the first command fails. 
&& 
You use the double ampersand operator in the form 
command1 && command2 
In the above syntax, the second command executes only if the first command executes successfully. 
Command grouping operators { } 
You can enclose multiple statements in braces ({}) to create a code block. The shell returns one exit status value for the entire group, rather than for each command in the block. 
( ) 
You can enclose multiple statements in round brackets to create a code block. This code block functions in the same way as a code block enclosed in braces, but runs in a subshell. 

I/O redirection operators
> 
You use this operator to redirect command output to a file. If the specified file doesn't exist, the shell creates the file. If the file does exist, the shell overwrites it with the command output unless the noclobber environment variable is set. 
>| 
You use this operator to redirect command output to a file. If the specified file doesn't exist, the shell creates the file. If the file does exist, the shell overwrites it with the command output even if the noclobber environment variable is set. 
>> 
You use this operator to redirect command output to a file. If the file doesn't exist, the shell creates the file. If it does exist, the shell appends the new data to the end of it. 
< 
You use this operator to redirect command input from a file. 

File descriptor redirection operators
<&n 
You use this operator to redirect standard input from file descriptor n. 
>&n 
You use this operator to redirect standard input to file descriptor n. 
n< filename 
You use this operator with a filename to redirect descriptor n from the specified file. 
n> filename 
You use this operator with a filename to redirect descriptor n to the specified file. Unlike ordinary redirection, this will not overwrite an existing file. 
n>| filename 
You use this operator with a filename to redirect descriptor n to the specified file, overriding the noclobber environment variable if it is set. 
n>> filename 
You use this operator with a filename to redirect a descriptor to the specified file. This will redirect to a file but, unlike ordinary redirection, this will append to an existing file. 

Filename substitution 
* 
You use the * wildcard to match a string of any length. 
? 
You use the ? wildcard to match a single character. 
[abc] , [a-c] , [a-c1-3] 
You use square brackets to match only characters that appear inside the specified set. For increased convenience, you can specify multiple ranges. 
!pattern 
You use the ! operator with a pattern to perform a reverse match. The shell returns only filenames that don't match the pattern. 

Command substitution
$(command) 
You use this form of command substitution to resolve a command and pass its output to another command as an argument. 
$(< filename) 
You use this form of command substitution to pass the entire contents of a file to a command as an argument. 
Tilde substitution ~ 
You use the ~ operator to instruct the shell to return the value of the $HOME variable. 
~username 
You use the ~ operator with a username to instruct the shell to return the full path of a specific user's home directory. 
~+ 
You use the ~+ operator to instruct the shell to return the full path of the current working directory. 
~- 
You use the ~- operator to instruct the shell to return the full path of the previous working directory you used.


Miscellaneous syntax ; 
If you enter several commands on the same line, you need to separate the commands with semicolons. The shell will execute each command successively once you press Enter. 
\ 
You use a backslash to allow you to press Enter and continue typing commands on a new line. The shell will only begin executing your commands when you press Enter on a line that doesn't end in a backslash. Using a backlash in this way is known as backslash escaping. 
& 
You add a single ampersand at the end of a command to run that command as a background process. This is useful for tasks that are likely to take a long time to complete. 
SummaryShell programs can execute a wide range of UNIX commands, but they also have built-in functions to help you use shells more effectively. 
Most shells support standard operators for conditional execution, input/output (I/O) redirection, file descriptor redirection, and command grouping. They also allow you to perform filename, tilde, and command substitution. 
Table of Contents | Top of page |
