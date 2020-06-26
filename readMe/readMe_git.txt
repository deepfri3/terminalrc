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
