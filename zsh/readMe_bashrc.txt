readMe_bashrc

https://medium.com/@waxzce/use-bashrc-d-directory-instead-of-bloated-bashrc-50204d5389ff

Use .bashrc.d directory instead of bloated .bashrc

Bashrc file or .profile are the place where we put the initialization of the bash/zsh/fish shell, and lot’s of software want to add a line here, mainly to init some environment variable, or change path (BTW there is a feature to do that on OSX). The result is a bloated, unreadable file for init. So, let’s split it in several files.

You will be able to list your init parts like this:

denis:~ waxzce$ ls .bashrc.d/
alias-vlc.bashrc
autoenv.bashrc
autojump.bashrc
commented-waht-isit.bashrc
dcos.bashrc
git-alias.bashrc
go_path.bashrc
hist.bashrc
history.bashrc
homebrew_management.bashrc
iterm2.bashrc
nvm.bashrc
path_local.bashrc
rbenv.bashrc
rust.bashrc
sdkman.bashrc

How to switch?

First, create a directory

mkdir ~/.bashrc.d 
chmod 700 ~/.bashrc.d

Then add this to your actual .bashrc or .bash_profile (on top)

for file in ~/.bashrc.d/*.bashrc;
do
 source “$file”
done

Then just split the file inside the ~/.bashrc.d directory with precise MYFILE.bashrc file. You’ll need to give them execution rights too

chmod +x ~/.bashrc.d/*.bashrc

