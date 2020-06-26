# Execute as admin
# Use an internet connection without proxy
@powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

Required tools
choco install -y fzf ag ctags cmder notepadplusplus kitty teraterm find-and-run-robot launchy-beta teracopy 7zip python3 mingw cmake gnuwin32-coreutils

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
C:\tools\mingw64\bin
C:\tools\neovim\Neovim\bin
C:\Users\bakerg\.cargo\bin
C:\Users\bakerg\go
C:\Program Files (x86)\GnuWin32\bin
C:\Program Files\CMake\bin

$ choco install neovim --pre
$ pip install pynvim
Install vim-plug for neovim:
md ~\AppData\Local\nvim\autoload
$uri = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
(New-Object Net.WebClient).DownloadFile(
  $uri,
  $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath(
    "~\AppData\Local\nvim\autoload\plug.vim"
  )
)


