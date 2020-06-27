# overwite local changes w/o merge
git fetch --all
git reset --hard origin/master
git pull origin master

# Use git through proxy
git config --global http.proxy http://proxyuser:proxypwd@proxy.server.com:8080

git config --global http.proxy http://194.138.0.9:9400
git config --global http.proxy http://194.138.0.10:9400
git config --global http.proxy http://194.138.0.33:9400

.gitconfig
[http]
        proxy = http://username:password@proxy.at.your.org:8080

[http]
        proxy = http://194.138.0.9:9400

[user]
        name = George Baker
        email = george.baker@siemens.com
[core]
        editor = nvim
[push]
        default = simple

** SSH setup with GitHub **
$ ssh-keygen -t rsa -b 4096 -C "johndoe@domain.com" -f ~/.ssh/id_rsa_<hostname>_<username>_<purpose>
$ eval $(ssh-agent -s)
$ ssh-add ~/.ssh/id_rsa_<hostname>_<username>_<purpose>
$ ssh -T git@github.com
# Attempts to ssh to GitHub

git add remote origin git@<remote repository>
git -u push origin master
