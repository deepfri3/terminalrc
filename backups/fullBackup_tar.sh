#!/bin/sh
#
# Author: George Baker <george.baker@siemens.com>
# Date Created: 2016-06-10
#
# This script makes a backup of Kane to the remote Synology NAS USFHPNAS5
# The scripts utilizing tar
#
echo -e "Tar Backup Started $(date) $USER\n"

BDIR=/

USR=bakerg
BSERVER=usfhpnas5

R_BDIR=/volume1/backups/kane/tar

L_BDIR=${HOME}/Storage/backups
#L_BDIR=/mnt/nas5backups/tar

BACKUP=fullbackup_baseline.tar.bz2
#BACKUP=fullbackup_$(date +%Y%m%d).tar.bz2

echo "Local backup dir: ${L_BDIR}"
echo -e "remote backup dir: ${R_BDIR}"
echo -e "backup: ${BACKUP}\n"

echo "Performing backup..."
sudo tar -jcvpf ${L_BDIR}/${BACKUP} --directory=${BDIR} \
--exclude=dev/pts/* \
--exclude=backups \
--exclude=dev/* \
--exclude=proc/* \
--exclude=sys/* \
--exclude=tmp/* \
--exclude=run/* \
--exclude=mnt/* \
--exclude=media/* \
--exclude=lost+found \
--exclude=home/*/.thumbnails \
--exclude=home/*/.gvfs \
--exclude=home/*/.cache \
--exclude=Cache \
--exclude=home/*/.local/share/Trash/* \
--exclude=home/*/.CloudStation \
--exclude=home/*/CloudStation \
--exclude=home/*/.xsession-errors \
--exclude=home/*/Storage/backups/* \
--exclude=home/*/logs/* \
.
echo -e "Backup completed.\n"

echo "Sending backup to remote server..."
scp ${L_BDIR}/${BACKUP} ${USR}@${BSERVER}:${R_BDIR}
echo "Cleaning up..."
sudo rm ${L_BDIR}/${BACKUP}
echo -e "Done!\n"

echo -e "Tar Backup ended $(date) $USER"
exit
