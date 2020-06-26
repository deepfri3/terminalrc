
sudo apt-get install xscreensaver xscreensaver-screensaver-bsod

http://www.howtogeek.com/114027/how-to-add-screensavers-to-ubuntu-12.04/?PageSpeed=noscript

Add xscreensave to startup:

Goto: System Setting -> Startup and Shutdown -> Autostart

Click "Add Program..."

Click the browse button on the right

Find /usr/bin/xscreensaver and click ok

Check "Run in Terminal" and click ok

Properties dialog will pop-up

Navigate to "Application"

Fill out information as follow:

Name: XScreenSaver
Description: Start XScreenSaver in the background at startup
Comment: Start XScreenSaver in the background at startup
Command: /usr/bin/xscreensaver -nosplash

Click "Ok"

Logout and login

xscreensaver should be running.

How to use xscreensaver instead of KDE's default on PCLinuxOS (as of version 2012.8):

Install xscreensaver:
1. use the Synaptic package manager or at a command line:
apt-get install xscreensaver

Disable KDE's screen saver:
1. In the menus, go to More Applications | Configuration | Configure Your Desktop
(note: can be started from a command line with "systemsettings")
2. Open "Display and Montors"
3. Click "Screen Saver"
4. untick "Start automatically after ..."

Locate the Autostart path:
1. back on the "Configure Your Desktop" dialog, open "Account Details"
2. click "Paths"
3. make a note of the "Autostart path"

Make xscreensaver start automatically:
1. create a new file with a name ending in ".desktop" in the directory indicated by your "Autostart Path"
2. put this in it:
[Desktop Entry]
Exec=xscreensaver -no-splash
Name=XScreenSaver
Type=Application
X-KDE-StartupNotify=false

Make the KDE screen lock widget button work with xscreensaver:
1. navigate as root to /usr/lib/kde4/libexec
2. rename kscreenlocker to something else, like kscreenlocker.saver
NOTE: might also be kscreenlocker_greet or krunner_lock.
3. create a file in there called kscreenlocker and put this in it:
#!/bin/bash
xscreensaver-command -lock

Get the configuration menu item to show up:
1. as root, edit: /usr/share/applications/xscreensaver-properties.desktop
2. delete the last line "notshownin=KDE"
3. save it. It should now show under the menus in More Applications | Configuration

And that's it. Use xscreensaver-demo to configure it.
