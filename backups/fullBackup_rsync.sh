#!/bin/sh
#
# Author: George Baker <george.baker@siemens.com>
# Date Created: 2016-06-09
#
# This script makes a backup of Kane to the remote Synology NAS USFHPNAS5
# The scripts utilizes a combination of rsynce and ssh to makes backups
# of the system.
# - First an initial "baseline" backup is created
# - After the baseline backup a current backup is updated weekly
#
echo -e "Rsync Backup Started $(date) $USER\n"

# rsync executable
RSYNC=/usr/bin/rsync

# directory to backup
# "/" the filesystem
BDIR=/

# exclude file - this contains a wildcard pattern per line of files to exclude
EXCLUDES=$HOME/.backup-excludes

# username and remote machine name
USER=bakerg
BSERVER=usfhpnas5

# backup destination on remote machine
BACKUPDEST=/volume1/backups/kane/rsync

# backup directory name on remote machine (for incremental backups)
#BACKUPDIR=$BACKUPDEST/Kane_Backup_$(date +%Y%m%d)

# current backup destination
DEST=$BACKUPDEST/Kane_Backup_current
# for baseline backup
#DEST=$BACKUPDEST/Kane_Backup_baseline_$(date +%Y%m%d)

# rsync options
# For incremental backups
#RSYNCOPTS=(--backup --numeric-ids --backup-dir=$BACKUPDIR --delete-excluded --delete --exclude-from=$EXCLUDES -ahvvz)
# For whole images
RSYNCOPTS=(--numeric-ids --delete-excluded --delete --exclude-from=$EXCLUDES -ahvvz)
RSYNC_REMOTE_OPT=(-e "ssh -i $HOME/.ssh/id_Kane_bakerg_dsa")
echo -e "rsync remote opt:\n$(printf "%q " "${RSYNC_REMOTE_OPT[@]}"; echo)"
RSYNCOPTS=(${RSYNCOPTS[@]} "${RSYNC_REMOTE_OPT[@]}")
echo -e "rsync options:\n$(printf "%q " "${RSYNCOPTS[@]}"; echo)"

# now the actual transfer
#set -x
#echo -e "cmd:\n${RSYNC} --dry-run $(printf "%q " "${RSYNCOPTS[@]}" ${BDIR} ${USER}@${BSERVER}":"${DEST}; echo)"
#sudo ${RSYNC} --dry-run "${RSYNCOPTS[@]}" ${BDIR} ${USER}@${BSERVER}:${DEST}
echo -e "cmd:\n$(printf "%q " ${RSYNC} "${RSYNCOPTS[@]}" ${BDIR} ${USER}@${BSERVER}":"${DEST}; echo)"
sudo ${RSYNC} "${RSYNCOPTS[@]}" ${BDIR} ${USER}@${BSERVER}:${DEST}
#set +x

echo -e "\nRsync Backup ended $(date) $USER"
exit
