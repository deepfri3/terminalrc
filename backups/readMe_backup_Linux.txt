
== backup utilities == 

http://www.techrepublic.com/blog/10-things/10-outstanding-linux-backup-utilities/

GUIs
sbackup (https://sourceforge.net/projects/sbackup/?source=typ_redirect)
fwbackups (http://www.diffingo.com/oss/fwbackups)

== use tar ==

http://www.aboutdebian.com/tar-backup.htm

cd /
mkdir backups
cd backups

Then use the nano editor to create our shell script file with the command:
vim fullserver.sh

and enter the following command into it (and don't miss that period at the end of the command):

tar -cvpf /backups/fullbackup.tar --directory=/ --exclude=proc
--exclude=sys --exclude=dev/pts --exclude=backups .

The above command is on multiple lines for readability. Enter everything on the same line when entering the command in the editor. Once entered, exit the editor (Ctrl-X) saving the file.
- The c option creates the backup file.
- The v option gives a more verbose output while the command is running. This option can also be safely eliminated.
- The p option preserves the file and directory permissions.
- The f option needs to go last because it allows you to specify the name and location of the backup file which follows next in the command (in our case this is the /backups/fullbackup.tar file).
- The --directory option tells tar to switch to the root of the file system before starting the backup.

We --exclude certain directories from the backup because the contents of the directories are dynamically created by the OS. We also want to exclude the directory that contains are backup file.

Many tar references on the Web will give an exclude example as:

--exclude=/proc

However, this will often result in excluded directories still being backed up because there should not be the leading / (slash) character in front of the directory names. If you were to use the above example, tar would back up the proc directory which would result in errors saying that files had changed since they were read.
In addition to holding your backup file, the /backups directory now holds your script file also. You have to make your script executable before you can run it. To do that and run it enter the following two commands:

chmod 750 /backups/fullserver.sh
./backups/fullserver.sh

To restore your "tar ball" you need to copy it to the top-most point in the file tree that it backed up. In our case the --directory option told tar to start backing up from the root of the file system so that's where we would want to copy the tar ball to. Then simply replace the c option with the x parameter line so:

tar -xvpf /fullbackup.tar

Having a backup file is nice but not of much use if the hard-drive itself fails. If your server is running the wu-ftpd FTP server daemon, you should FTP the tar ball off of your server so that it is stored on a different system.

Note that with the use of the --exclude statements when doing the backup, the tar backup file (tar ball) isn't something you could use to do a "bare metal" restore (because the excluded directories would be missing). However, it does work very well if you do an initial vanilla install of the OS and then un-tar your tar ball on top of that.

Saving Space With Compression

You can compress your backup files to save storage space. Because a lot of Linux files are text files the space savings can be significant. Enough, perhaps, to be able to fit your archive file on a CD or DVD.

To enable the compression you have to add the z switch to both the tar-ing and untar-ing commands. You also have to change the file name to indicate the compression. Our tar-ing command becomes:

tar -zcvpf /backups/fullbackup.tar.gz --directory=/ --exclude=proc
--exclude=sys --exclude=dev/pts --exclude=backups .

Likewise, our untar-ing command becomes:

tar -zxvpf /fullbackup.tar.gz 

== use rsync ==

rsync (https://rsync.samba.org/)
https://wiki.archlinux.org/index.php/Full_System_Backup_with_rsync
https://help.ubuntu.com/community/rsync
http://www.comentum.com/rsync.html
https://blog.karssen.org/2011/02/06/using-rsync-to-backup-to-a-remote-synology-diskstation/

Boot requirements

Having a bootable backup can be useful in case the filesystem becomes corrupt or if an update breaks the system. The backup can also be used as a test bed for updates, with the [testing] repo enabled, etc. If you transferred the system to a different partition or drive and you want to boot it, the process is as simple as updating the backup's /etc/fstab and your bootloader's configuration file.
Update the fstab

Without rebooting, edit the backup's fstab to reflect the changes:
/path/to/backup/etc/fstab

tmpfs        /tmp          tmpfs     nodev,nosuid             0   0

/dev/sda1    /boot         ext2      defaults                 0   2
/dev/sda5    none          swap      defaults                 0   0
/dev/sda6    /             ext4      defaults                 0   1
/dev/sda7    /home         ext4      defaults                 0   2

Because rsync has performed a recursive copy of the entire root filesystem, all of the sda mountpoints are problematic and booting the backup will fail. In this example, all of the offending entries are replaced with a single one:
/path/to/backup/etc/fstab

tmpfs        /tmp          tmpfs     nodev,nosuid             0   0

/dev/sdb1    /             ext4      defaults                 0   1

Remember to use the proper device name and filesystem type.
Update the bootloader's configuration file

This section assumes that you backed up the system to another drive or partition, that your current bootloader is working fine, and that you want to boot from the backup as well.

For Syslinux, all you need to do is duplicate the current entry, except pointing to a different drive or partition.
Tip: Instead of editing syslinux.cfg, you can also temporarily edit the menu during boot. When the menu shows up, press the Tab key and change the relevant entries. Partitions are counted from one, drives are counted from zero.

For GRUB, it is recommended that you automatically re-generate the main configuration file.

Also verify the new menu entry in /boot/grub/grub.cfg. Make sure the UUID is matching the new partition, otherwise it could still boot the old system. Find the UUID of a partition as follows:
# lsblk -no NAME,UUID /dev/sdb3

where you substitute the desired partition for /dev/sdb3. To list the UUIDs of partitions grub thinks it can boot, use grep:
# grep UUID= /boot/grub/grub.cfg

First boot

Reboot the computer and select the right entry in the bootloader. This will load the system for the first time. All peripherals should be detected and the empty folders in / will be populated.

Now you can re-edit /etc/fstab to add the previously removed partitions and mount points.

If you transferred the data from HDD to SSD (solid state drive), do not forget to activate TRIM. Also consider using HDD and tmpfs mount points to reduce SSD wearing - see Maximizing performance#Relocate files to tmpfs and Solid State Drives#Tips for minimizing disk reads/writes.
Note: You may have to reboot again in order to get all services and daemons working correctly. Personally, pulseaudio would not initialise because of a module loading error. I restarted the dbus.service to make it work.

== use dd to make images ==

http://mark.koli.ch/howto-whole-disk-backups-with-dd-gzip-and-p7zip

http://www.thegeekstuff.com/2010/10/dd-command-examples/

Restore from Backup

Backups are useless unless you can actually restore your data. If you need to restore a P7ZIP compressed backup to /dev/sda, here’s how:
rescuecd#/> 7za x /mirror/backup-sda.7z -so | dd of=/dev/sda bs=1024

If you decided to skip P7ZIP compression, and need to restore a Gzip compressed backup to /dev/sda, here’s how:
rescuecd#/> gunzip -c /mirror/backup-sda.gz | pv | dd of=/dev/sda bs=1024

== use cron to automate backups ==

http://www.unixgeeks.org/security/newbie/unix/cron-1.html

To add an entry to the crontab, simply enter the following:

$ crontab -e

This will bring up crontab entries configured for your user.

crontab entries have the following format:

min hr dom month dow cmd

Examples:
0 0 * * 6 ~/bin/fullBackup_tar.sh > ~/logs/tar_backup.log 2>&1 # run tar backup weekly, Saturday 12:00am
0 6 * * 6 ~/bin/fullBackup_rsync.sh > ~/logs/rsync_backup.log 2>&1 # run rsync backup weekly, Saturday 6:00am
0 3 * * 0 ~/bin/fullBackup_dd.sh > ~/logs/dd_backup.log 2>&1 # run dd backup weekly, Sunday 3:00am

Once you have written your crontab file, and exited the editor, then it will
check the syntax of the file, and give you a chance to fix any errors.
Note: You do not have to provide a user paramater if you setup cron entries this way





