#!/bin/sh -x

DROPBEAR_ID="/mnt/sdcard/tools/.id_dropbear"
AVAHI_CONF="/mnt/sdcard/tools/avahi-daemon.conf"
MOUNT_SDCARD=$(mount | grep -r '^/dev/.* on /mnt/sdcard' | cut -d ' ' -f1)

# jank fix for permissions...
umount "${MOUNT_SDCARD}"
mount -o rw,umask=000,noatime,nodiratime "${MOUNT_SDCARD}" /mnt/sdcard

# Setup
ln -s /mnt/sdcard/tools/dropbearmulti /tmp/scp
ln -s /mnt/sdcard/tools/dropbearmulti /tmp/dropbearkey
ln -s /mnt/sdcard/tools/dropbearmulti /tmp/dropbear
ln -s /mnt/sdcard/tools/dropbearmulti /tmp/dbclient
ln -s /mnt/sdcard/tools/sftp-server /tmp/sftp-server
ln -s /mnt/sdcard/tools/avahi-daemon /tmp/avahi-daemon

# Generate keys if needed
if [[ ! -f "${DROPBEAR_ID}" ]]; then
	/tmp/dropbearkey -t rsa -f "${DROPBEAR_ID}"
fi

# Run and wait for commands
# killItWithFire
/tmp/dropbear -r "${DROPBEAR_ID}" -F &
/tmp/avahi-daemon -D -f "${AVAHI_CONF}"
