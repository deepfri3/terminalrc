//*** Configure terminal in Windows ***//

*** Setup chocolatey ***
# Execute as admin
# Use an internet connection without proxy
@powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

Required tools
choco install -y fzf ag ctags cmder notepadplusplus kitty teraterm find-and-run-robot launchy-beta teracopy 7zip python3 mingw cmake gnuwin32-coreutils cygwin git
choco install -y neovim --pre

Optional development tools
choco install -y sourcetree
choco install -y jdk8 maven groovy
choco install -y intellijidea-community
choco install -y visualstudiocode
choco install -y virtualbox openshift-cli
choco install -y visualstudio2017buildtools visualstudio2017-workload-officebuildtools
choco install -y visualstudio2019buildtools visualstudio2019-workload-officebuildtools
choco install -y llvm
choco install -y golang
choco install -y rustup

Upgrading Chocolatey
Once installed, Chocolatey can be upgraded in exactly the same way as any other package that has been installed using Chocolatey. Simply use the command to upgrade to the latest stable release of Chocolatey:
choco upgrade chocolatey

C:\Go\bin
C:\tools\cygwin\bin
C:\tools\mingw64\bin
C:\tools\neovim\Neovim\bin
C:\Users\bakerg\.cargo\bin
C:\Users\bakerg\go
C:\Program Files (x86)\GnuWin32\bin
C:\Program Files\CMake\bin

*** Setup up Git for Windows ***

Add to .bashrc:
env=~/.ssh/agent.env

agent_load_env () { test -f "$env" && . "$env" >| /dev/null ; }

agent_start () {
    (umask 077; ssh-agent >| "$env")
    . "$env" >| /dev/null ; }

agent_load_env

# agent_run_state: 0=agent running w/ key; 1=agent w/o key; 2= agent not running
agent_run_state=$(ssh-add -l >| /dev/null 2>&1; echo $?)

if [ ! "$SSH_AUTH_SOCK" ] || [ $agent_run_state = 2 ]; then
    agent_start
    ssh-add
elif [ "$SSH_AUTH_SOCK" ] && [ $agent_run_state = 1 ]; then
    ssh-add
fi

unset env


*** Setup neovim ***
$ pip install pynvim

Install vim-plug for neovim:
md ~\AppData\Local\nvim\plugged
md ~\AppData\Local\nvim\undodir
md ~\AppData\Local\nvim\autoload
$uri = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
(New-Object Net.WebClient).DownloadFile(
  $uri,
  $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath(
    "~\AppData\Local\nvim\autoload\plug.vim"
  )
)

Open Cmder settings and go to Startup -> Environment, add the following settings:
set TERM=xterm-256color

Run in cmd:
mklink ~\AppData\Local\nvim\init.vim .\terminalrc\vim\init.vim
mklink ~\AppData\Local\nvim\ginit.vim .\terminalrc\vim\ginit.vim
symbolic link created for C:\Users\bakerg\AppData\Local\nvim\init.vim <<===>> C:\Users\bakerg\terminalrc\vim\init.vim
