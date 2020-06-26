#!/bin/sh
#
# Author: George Baker <george.baker@siemens.com>
# Date Created: 2016-06-16
#
# This script make backup images of Kane's disks to the remote Synology NAS USFHPNAS5
# The scripts utilizing dd
#

echo -e "dd Backup Started $(date) $USER\n"

USR=bakerg
BSERVER=usfhpnas5

#R_BDIR=/volume1/backups/kane/dd/baseline_$(date +%Y%m%d)
R_BDIR=/volume1/backups/kane/dd/current

L_BDIR=${HOME}/Storage/backups
#L_BDIR=/mnt/nas5backups/dd/baseline_$(date +%Y%m%d)
#L_BDIR=/mnt/nas5backups/dd/current

echo "Local backup dir: ${L_BDIR}"
echo -e "remote backup dir: ${R_BDIR}\n"

# backup main harddisk
DISK=sda
BDISK=/dev/${DISK}
DISK_IMAGE_NAME=${DISK}disk-img.gz
DISK_PART_NAME=${DISK}disk-img.sf
DISK_MBR_NAME=${DISK}disk-img.mbr
DISK_IMAGE=${L_BDIR}/${DISK_IMAGE_NAME}
DISK_PART=${L_BDIR}/${DISK_PART_NAME}
DISK_MBR=${L_BDIR}/${DISK_MBR_NAME}
echo -e "Main harddisk:\n- "Disk: ${BDISK}"\n- Image Name: ${DISK_IMAGE_NAME}\n- Partition: ${DISK_PART_NAME}\n- MBR: ${DISK_MBR_NAME}\n- Local Backup: ${L_BDIR}\n- Remote Dest: ${R_BDIR}"
# backup partition table
echo "Backup up partition table..."
sudo sfdisk -d ${BDISK} > ${DISK_PART}
# backup MBR 
echo "Backup up MBR..."
sudo dd if=${BDISK} of=${DISK_MBR} count=1 bs=512
# main disk image
echo "Backup up disk..."
sudo dd if=${BDISK} bs=2M conv=noerror,sync | pv -tpreb | gzip -c -9 > ${DISK_IMAGE}
echo "Sending backup to remote server..."
scp ${DISK_IMAGE} ${DISK_PART} ${DISK_MBR} ${USR}@${BSERVER}:${R_BDIR}
echo "Cleaning up..."
sudo rm ${DISK_IMAGE} ${DISK_PART} ${DISK_MBR}
echo

# backup home (user data) harddisk
DISK=sdb
BDISK=/dev/${DISK}
DISK_IMAGE_NAME=${DISK}disk-img.gz
DISK_PART_NAME=${DISK}disk-img.sf
DISK_MBR_NAME=${DISK}disk-img.mbr
DISK_IMAGE=${L_BDIR}/$DISK_IMAGE_NAME
DISK_PART=${L_BDIR}/$DISK_PART_NAME
DISK_MBR=${L_BDIR}/$DISK_MBR_NAME
echo -e "Storage harddisk:\n- "Disk: ${BDISK}"\n- Image Name: ${DISK_IMAGE_NAME}\n- Partition: ${DISK_PART_NAME}\n- MBR: ${DISK_MBR_NAME}\n- Local Backup: ${L_BDIR}\n- Remote Dest: ${R_BDIR}"
# backup partition table
echo "Backup up partition table..."
sudo sfdisk -d ${BDISK} > ${DISK_PART}
# backup MBR 
echo "Backup up MBR..."
sudo dd if=${BDISK} of=${DISK_MBR} count=1 bs=512
# main disk image
echo "Backup up disk..."
sudo dd if=${BDISK} bs=2M conv=noerror,sync | pv -tpreb | gzip -c -9 > ${DISK_IMAGE}
echo "Sending backup to remote server..."
scp ${DISK_IMAGE} ${DISK_PART} ${DISK_MBR} ${USR}@${BSERVER}:${R_BDIR}
echo "Cleaning up..."
sudo rm ${DISK_IMAGE} ${DISK_PART} ${DISK_MBR}
echo

echo -e "dd Backup Ended $(date) $USER\n"
exit
