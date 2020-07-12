
== How to map a drive using a Linux/Unix Environment ==

Basic overview: This will cover basic commands needed to be entered in a Linux Terminal Environment. Please consult with each Linux Distribution support or community forum for advanced techniques.
Basic Method

1. Begin by creating a mount point for the map drive

    sudo mkdir /mnt/nas4homes /mnt/nas4chat /mnt/nas5backups
    sudo chown bakerg:USFHP-CC_EngDefault-U /mnt/nas4homes /mnt/nas4chat /mnt/nas5backups

2. Edit the /etc/fstab file, add the following line

   # Synology USFHPNAS4 public/chat
   //136.157.0.157/public/chat /mnt/nas4chat cifs user,uid=bakerg,gid=USFHP-CC_EngDefault-U,rw,suid,credentials=/etc/cifspwd 0 0
   # Synology USFHPNAS4 cloud station
   //136.157.0.157/homes /mnt/nas4homes cifs user,uid=bakerg,gid=USFHP-CC_EngDefault-U,ro,suid,credentials=/etc/cifspwd 0 0
   # Synology USFHPNAS5 backup
   //136.157.0.158/backups/kane /mnt/nas5backups cifs user,uid=bakerg,gid=USFHP-CC_EngDefault-U,rw,suid,credentials=/etc/cifspwd 0 0

   For NFS
   sudo apt-get install nfs-common
   # mount synology NAS volumes
   192.168.1.56:/volume1/MEDIA /media/synology/media nfs rsize=8192,wsize=8192,timeo=14,intr 0 0
   192.168.1.56:/volume1/DOWNLOADS /media/synology/downloads nfs rsize=8192,wsize=8192,timeo=14,intr 0 0
   192.168.1.56:/volume1/ARCHIVES /media/synology/archives nfs rsize=8192,wsize=8192,timeo=14,intr 0 0
   192.168.1.56:/volume1/PC_BACKUPS /media/synology/backups nfs rsize=8192,wsize=8192,timeo=14,intr 0 0

3. Create the file /etc/cifspwd with your login credentials and secure it:

    echo username=yourusername > /etc/cifspwd
    echo password=yourpassword >> /etc/cifspwd
    chmod 0600 /etc/cifspwd

4. Mount the drive with the following command

    sudo mount -a

== SSH into your Synology DiskStation with SSH Keys as Root ==

https://www.chainsawonatireswing.com/2012/01/15/ssh-into-your-synology-diskstation-with-ssh-keys/

The Synology DiskStation supports both telnet & SSH, but all right-thinking people know that you should never use telnet, as it is completely insecure, & should instead use SSH, as it is very secure. It’s easy to enable SSH on your DiskStation by going to Control Panel > Terminal & checking the box next to Enable SSH Service. You can now log in with your username & password.

But that’s not enough. Logging in with a username & password isn’t nearly as secure as requiring SSH keys. With that method, you have a private key on your computer & a public key on the SSH server (the Synology DiskStation in this case). When a computer tries to log in via SSH, the server looks at the public key & asks for the corresponding private key. No private key, no login.

    NOTE: I’m assuming that you have already generated or possess SSH keys. If you haven’t, I’ve written a section in Linux Phrasebook that covers how to do so, or you can easily find instructions on the Web.

To start the process, you need to edit the SSH daemon’s config file to allow access via keys. Edit /etc/ssh/sshd_config using vim & change these lines:

#RSAAuthentication yes
#PubkeyAuthentication yes
#AuthorizedKeysFile .ssh/authorized_keys

To this:

#RSAAuthentication yes
PubkeyAuthentication yes
AuthorizedKeysFile .ssh/authorized_keys

Save the file.

Time to create the necessary .ssh directory & file on your Synology DiskStation:

> cd /root
> mkdir .ssh
> touch .ssh/authorized_keys

Now get your permissions set correctly on that directory & file:

> chmod 700 .ssh
> chmod 644 .ssh/authorized_keys

Now you need to edit the authorized_keys file. Do so remotely with vim, or FTP (with SSL enabled!) into the server, grab the file, edit it on your machine, & then FTP it back to the DiskStation—your choice. Put your public SSH key into the authorized_keys file, so it will look something like this:

ssh-dss AAVLyQ9TYW7rKzUQJV9akeEaQjkVeERVaGvaLXnmg3PCIUaJd2tZTvQvdXHgtUfJdCJcKjTF2RdYFDO5weeoTtdaYl1cGYIWT+nfOhqs9+EGmwwkM1MKoibRzIcu2EEkidBhAE4Ahya+iKbTzwk7VNgprAXA61j39SazZW2LkdHtlsHFloCqcHPXlakEj2JlAAAAFQDRBQ+l7v2rwhwFPKuxucM834AqYzU4HzAbv0AgqLFsC4ZBwPEw+3HFwJX/Xkv3V67Sug8JKDbprbZct9c3TSYq24IDYRmVBsewj714qCeafZKdo3SRAVzB/6/rMKFa5LkY5dOBfQuExSj9mTHMT9BkeeQnacld76OxxQiMej+bVLyQ9TYW7rKzUQJV9akeEaQjkVeERVaGvaLXnmg3PCIUaJd2tZJputa0TEpg5GyqenhQ6LE0B5ebjN/fVi7yuzRKqHrQUZVnziVgIMKpSJtqYoKW+3L0/L2rwhwFPKuxucM834AqYzU4Hz+q28Ss1HDEUrrQGR+D5xWISskUnH2oPY0d5A8/phnH8FQp/gEwh3YIq3dLapOxpAZtg== johncarter@barsoom.local

Save the file, & try logging in to your Synology DiskStation:

ssh root@IP
BusyBox v1.16.1 (2011-11-26 14:58:46 CST) built-in shell (ash)
Enter 'help' for a list of built-in commands.


It worked! In four further posts over the next several days, let’s make this situation better:

== SSH into your Synology DiskStation with SSH Keys as User ==

https://www.chainsawonatireswing.com/2012/01/16/log-in-to-a-synology-diskstation-using-ssh-keys-as-a-user-other-than-root/

Troubleshooting SSH with public key authentication on Synology DSM 6.0

If SSH keeps asking you to enter your password, although you have set up Public Key Authentication, make sure that file permissions are correct:

Apparently, on a Synology DiskStation, your home dir must be neither group- nor world-writable:

cd ~
chmod 0755 .
(/volume1/homes/bakerg)

On my DiskStation, all user directories were set to 777 – I don’t remember if this has always been the case, if I did this manually (and why :)) or if this happened during the update to DSM 6.0. ↩

