Install Dropbox via command line
The Dropbox daemon works fine on all 32-bit and 64-bit Linux servers. To install, run the following command in your Linux terminal.

32-bit:

cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86" | tar xzf -
64-bit:

cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
Next, run the Dropbox daemon from the newly created .dropbox-dist folder.

~/.dropbox-dist/dropboxd
If you're running Dropbox on your server for the first time, you'll be asked to copy and paste a link in a working browser to create a new account or add your server to an existing account. Once you do, your Dropbox folder will be created in your home directory. Download this CLI script to control Dropbox from the command line. For easy access, put a symlink to the script anywhere in your PATH.

Dropbox icon missing in system tray:

Run dropbox with dbus-launch:
dbus-launch /home/bakerg/.dropbox-dist/dropboxd start -i &

Tip: create a script such as "dropbox.sh" and place it in $HOME/.kde/Autostart
#!/bin/sh

dbus-launch /home/bakerg/.dropbox-dist/dropboxd start -i &

Set the proxy using the dropbox.py:
=>bakerg@Kane:~$ dropbox.py proxy
set proxy settings for Dropbox
dropbox proxy MODE [TYPE] [HOST] [PORT] [USERNAME] [PASSWORD]

Set proxy settings for Dropbox.

MODE - one of "none", "auto", "manual"
TYPE - one of "http", "socks4", "socks5" (only valid with "manual" mode)
HOST - proxy hostname (only valid with "manual" mode)
PORT - proxy port (only valid with "manual" mode)
USERNAME - (optional) proxy username (only valid with "manual" mode)
PASSWORD - (optional) proxy password (only valid with "manual" mode)
=>bakerg@Kane:~$ dropbox.py proxy manual http 127.0.0.1 3128
set
=>bakerg@Kane:~$

https://www.dropboxforum.com/hc/en-us/community/posts/205683966-Taskbar-Icon-disappeared-KDE4-Linux
https://askubuntu.com/questions/732967/dropbox-icon-is-not-working-xubuntu-14-04-lts-64/734886#734886
