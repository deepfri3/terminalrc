
Debian configuration


== Start application at login ==
https://www.debian-administration.org/article/50/Running_applications_automatically_when_X_starts

The majority of people who use Debian upon the desktop launch straight into the X11 Window system, usually via one of the choosers xdm, gdm, or kdm. Once you've entered your username and password you get your Window Manager running and are ready to start work. But what if you want a program or two to start as soon as you login?
The bigger desktop environments such as KDE or GNOME have their own facilities for starting programs when they load up.
In the case of KDE you simply place a shellscript, or symbolic link to an executable, into a special startup directory:

/home/username/.kde/Autostart

This will be executed at login time.

For GNOME you can use the control center. Go to the Control Center and select the sessions option. Inside there use the Session Properties & Startup section to choose the 'Startup Programs' tab. This allows you to add new programs to run at startup.
But what about causing programs to run if you're not running those environments?
Well the choosers gdm, kdm and xdm all support a standard startup system.
These choosers use XSession to run programs either globally or per-user when you login.
The global options are suitable if you wish to run a program for any user who logs into your machine, the per-user settings only apply to yourself.
Global options are the simplest ones. Simple place a shell script (make it executable) into the directory /etc/X11/Xsession.d
The files in the Xsession.d are executed in the order they are found - which explains why you might find some scripts located there already with numbers in their names.

I almost always want to have a terminal open and the music player xmms running when I login. I can achieve this by saving following shell script as /etc/X11/Xsession.d/startup-local
#!/bin/sh

xmms &

xterm &

Make it executable with:
chmod 755 /etc/X11/Xsession.d/startup

Notice that you must put the commands to run in the background? If you don't do that then your window manager will not start until after those programs have exitted.
If you just want to do this for yourself you can achieve the same thing by saving the script to run as ~/.xsession:
#!/bin/sh

xmms &

xterm &

(Again making it executable).

This is the per-user configuration file and will only affect you.
Either of these systems allow you to start programs automatically with the leighter weight Window Managers such as my personal favorite IceWM.

== Package Tools ==

https://www.debian.org/doc/manuals/debian-faq/ch-pkgtools.en.html
his page is about the ways to list the installed packages in a Debian system and how to create a file with this list. This file can be uploaded to the web (i.e. from other computer with Internet connection) to download new packages.

DPKG

	List all installed packages

	With version and architecture information, and description, in a table:

	dpkg-query -l

	Package names only, one per line:

	dpkg-query -f '${binary:Package}\n' -W

	List packages using a search pattern

	It is possible to add a search pattern to list packages:

	dpkg-query -l 'foo*'

	Show status of all packages on the system

	To check the status of all packages on your system:

	dpkg-query -l '*' | less

	This will show all packages (one line each) that are in various stages of installation (including packages that were removed but not purged) and packages just available from a repository. To show only installed packages:

	dpkg -l | grep '^.i'

	you can filter with grep to get results for "i".

	You can also use:

	apt-cache pkgnames

	Or you can use dpkg to list the current package selections (the desired state of either installed or to be installed packages):

	dpkg --get-selections

	And store the list of software to a file called /backup/package-selections

	dpkg --get-selections >/backup/package-selections

	You can also find package information in the next directories (you can use mc or other FileManager to browse them):

			/var/lib/apt/lists/*

			/var/lib/dpkg/available: list of available packages from repositories.

			/var/lib/dpkg/status: status of installed (and available) packages. This file contains information about whether a package is marked for removal or not, whether it is installed or not, etc. A package marked reinst-required is broken and requires reinstallation. 

	Restore installed software

	After re-installing base system you can immediately re-install all software. You need dselect:

	apt-get install dselect

	Then you have to type following command:

	dpkg --set-selections </backup/package-selections

	Now that your list is imported use apt-get, Synaptic or other PackageManagement tools. To install the packages:

	apt-get dselect-upgrade

	All this with a single command:

	aptitude install $(cat /backup/package-selections | awk '{print $1}')

https://wiki.debian.org/ListInstalledPackages

APT

	APT is the Advanced Package Tool is the advanced interface to the Debian packaging system and provides the apt-get program. It features complete installation ordering, multiple source capability and several other unique features, see the User's Guide in /usr/share/doc/apt-doc/guide.html/index.html (you will have to install the apt-doc package).
	apt-get provides a simple way to retrieve and install packages from multiple sources using the command line. Unlike dpkg, apt-get does not understand .deb files, it works with the packages proper name and can only install .deb archives from a source specified in /etc/apt/sources.list. apt-get will call dpkg directly after downloading the .deb archives[5] from the configured sources.

	Some common ways to use apt-get are:

			To update the list of package known by your system, you can run:

					 apt-get update

			(you should execute this regularly to update your package lists)

			To upgrade all the packages on your system (without installing extra packages or removing packages), run:

					 apt-get upgrade

			To install the foo package and all its dependencies, run:

					 apt-get install foo

			To remove the foo package from your system, run:

					 apt-get remove foo

			To remove the foo package and its configuration files from your system, run:

					 apt-get --purge remove foo

			To upgrade all the packages on your system, and, if needed for a package upgrade, installing extra packages or removing packages, run:

					 apt-get dist-upgrade

			(The command upgrade keeps a package at its installed obsolete version if upgrading would need an extra package to be installed, for a new dependency to be satisfied. The dist-upgrade command is less conservative.)

	Note that you must be logged in as root to perform any commands that modify the system packages.
	Note that apt-get now installs recommended packages as default and is the preferred program for package management from console to perform system installation and major system upgrades for its robustness.
	The apt tool suite also includes the apt-cache tool to query the package lists. You can use it to find packages providing specific functionality through simple text or regular expression queries and through queries of dependencies in the package management system. Some common ways to use apt-cache are:

			To find packages whose description contain word:

					 apt-cache search word

			To print the detailed information of a package:

					 apt-cache show package

			To print the packages a given package depends on:

					 apt-cache depends package

			To print detailed information of the versions available for a package and the packages that reverse-depends on it:

					 apt-cache showpkg package

	For more information, install the apt package and read apt-get(8), sources.list(5) and install the apt-doc package and read /usr/share/doc/apt-doc/guide.html/index.html. 

How can I tell what packages are already installed on a Debian system?

	To learn the status of all the packages installed on a Debian system, execute the command

			 dpkg --list

	This prints out a one-line summary for each package, giving a 2-letter status symbol (explained in the header), the package name, the version which is installed, and a brief description.

	To learn the status of packages whose names match the string any pattern beginning with "foo" by executing the command:

			 dpkg --list 'foo*'

	To get a more verbose report for a particular package, execute the command:

			 dpkg --status packagename

8.4 How to display the files of a package installed?

	To list all the files provided by the installed package foo execute the command

			 dpkg --listfiles foo

	Note that the files created by the installation scripts aren't displayed.

8.5 How can I find out what package produced a particular file?

To identify the package that produced the file named foo execute either:

    dpkg --search filename

    This searches for filename in installed packages. (This is (currently) equivalent to searching all of the files having the file extension of .list in the directory /var/lib/dpkg/info/, and adjusting the output to print the names of all the packages containing it, and diversions.)

    A faster alternative to this is the dlocate tool.

         dlocate -S  filename

    zgrep foo Contents-ARCH.gz

    This searches for files which contain the substring foo in their full path names. The files Contents-ARCH.gz (where ARCH represents the wanted architecture) reside in the major package directories (main, non-free, contrib) at a Debian FTP site (i.e. under /debian/dists/jessie). A Contents file refers only to the packages in the subdirectory tree where it resides. Therefore, a user might have to search more than one Contents files to find the package containing the file foo.

    This method has the advantage over dpkg --search in that it will find files in packages that are not currently installed on your system.

    apt-file search foo

    If you install the apt-file, similar to the above, it searches files which contain the substring or regular expression foo in their full path names. The advantage over the sample above is that there is no need to retrieve the Contents-ARCH.gz files as it will do this automatically for all the sources defined in /etc/apt/sources.list when you run (as root) apt-file update.

