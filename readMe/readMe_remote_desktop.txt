
https://www.debian-administration.org/article/50/Running_applications_automatically_when_X_starts


Remote Desktop

[ 6478.428528 ] Xvnc[52839]: segfault at 7ffe12f63000 ip 0000000000447f3a sp 00007ffe12f622a0 error 6 in Xtightvnc[400000+177000]
[ 6499.925132 ] Xvnc[53158]: segfault at 7ffc44d5b000 ip 0000000000447f3a sp 00007ffc44d59ae0 error 6 in Xtightvnc[400000+177000]

Windows (client) -> Linux (server)
http://www.techrepublic.com/blog/windows-and-office/how-do-i-run-a-remote-linux-desktop-in-windows/

Install TightVNC on client (http://www.tightvnc.com/)

Install x11vnc on server (http://www.karlrunge.com/x11vnc/)
sudo apt-get install libssl-dev
./configure
make
sudo make install
x11vnc -storepasswd
Add the following to rc.local:
x11vnc -usepw -forever

=>bakerg@Kane:~$ ps wwaux | grep auth
root       1440  0.3  0.2 231732 69796 tty7     Ss+  Jul18   7:56 /usr/bin/X :0 vt7 -br -nolisten tcp -auth /var/run/xauth/A:0-xqsWbb
bakerg   130206  0.0  0.1 395676 33572 ?        Sl   11:31   0:00 /usr/lib/kde4/libexec/polkit-kde-authentication-agent-1
bakerg   140815  0.0  0.0  12736  2120 pts/29   S+   11:54   0:00 grep --color=auto auth

-auth /var/run/xauth/A:0-xqsWbb
