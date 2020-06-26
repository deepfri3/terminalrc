
## How to Mount Windows CIFS Share on Debian Wheezy at start up ##

http://midactstech.blogspot.com/2013/09/how-to-mount-windows-cifs-share-on_18.html

This is for mounting the usfpksrv01 and usfpksrv04 network drives

Install the required package:

apt-get install cifs-utils

Make a directory to mount your external HDD into and edit '/etc/fstab':
mkdir /mnt/share01
mkdir /mnt/share04

nano /etc/fstab

add this line to the end of the file:

//usfpksrv01/chat/ /mnt/share01 cifs uid=0,guid=0,rw,credentials=/etc/cifspasswd 0 0
//usfpksrv04/public/ /mnt/share04 cifs uid=0,guid=0,rw,credentials=/etc/cifspasswd 0 0

    -//usfpksrv0x is the hostname of your Windows client
    -share0x/ is the name of your share
    -/mnt/share0x is the name of the directory you will mount //usfpksrv0x/xxxxx/ BackupPC
    -cifs is the mount type
    -uid=0,guid=0 gives root access to this directory
    -rw grants read/write access
    -credentials uses the credentials stored in the '/etc/cifspasswd' file

Now to make our file that stores our credentials for '/etc/fstab' to use:

nano /etc/cifspasswd

Add your credentials to the file:

username=<ww009 username>
password=password

Change the '/etc/cifspassword' file's owner and permissions:

chown 0.0 /etc/cifspasswd
chmod 600 /etc/cifspasswd

You should be all set. You can test out these configurations by typing:

mount -a

Other than that, Your server should automatically mount the external hard drive when it boots.

to unmount Windows CIFS Share:

sudo umount /mnt/share0x 

## How to mount an NTFS drive (internal or external) on Debian Wheezy ##

http://www.pendrivelinux.com/mounting-a-windows-xp-ntfs-partition-in-linux/

How to access a Windows XP or Vista NTFS partition from Linux. The following tutorial explains how to gain access to a Windows NTFS partition using Linux. Reading or accessing NTFS partitions in Linux is important for many reasons. Some users repair Windows Operating environments using Linux, while others use a dual boot operating environment and would like to have access to their Windows File system.

The good news is that this is not a complicated task to accomplish. As a matter of fact, for those using a Linux version derived from Debian, (I.E. Ubuntu, Knoppix, etc…) the process can be accomplished in a matter of seconds.

How to Mount a Windows NTFS file system partition in Linux:

NOTE: In step four of the following tutorial, replace hdx1 with your actual partition found in step two. For example hda1, hdb2, sda1, etc.

    Open a terminal and type sudo su
    Type fdisk -l (note which partition contains the NTFS file system)
    Type mkdir /media/windows (This directory is where we will access the partition. You do not have to call it 'windows')
    Type mount /dev/hdx1 /media/windows/ -t ntfs -o nls=utf8,umask=0222
    Type cd /media/windows (Moves us to the windows directory)
    Type ls to list the files on the NTFS partition

Notes: Alternately, you can navigate to the media/windows directory outside of terminal to view the files.

To unmount the Windows NTFS partiton, from the terminal simply type: umount /media/windows/

## How to mount as ISO image in Linux ##

http://www.howtogeek.com/168137/mount-an-iso-image-in-linux/

Prerequisite Module

You’ll have to make sure that the loop module is loaded before you can use this feature.

sudo modprobe loop

Mount a CD ISO Image

We’ll use the regular mount command to mount the ISO image into a folder, just like you would do with a regular drive. The difference is that we pass the -o loop command to specify the loop module, which can handle ISO images.

sudo mount filename.iso /media/iso -t iso9660 -o loop

Of course you should make sure that you have created the /media/iso folder ahead of time.
Mount a DVD ISO Image

When mounting ISO images of DVDs, you might have to use the UDF type instead of ISO.

sudo mount filename.iso /media/iso -t udf -o loop
