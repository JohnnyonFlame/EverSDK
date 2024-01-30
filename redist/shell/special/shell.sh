#!/bin/bash -e
SDCARD=$(realpath $(dirname ${BASH_SOURCE[0]})/..)
DROPBEAR_ID="${SDCARD}/tools/.id_dropbear"
AVAHI_CONF="${SDCARD}/tools/avahi-daemon.conf"

# jank fix for permissions...
for i in /mnt/sdcard*; do
	DEVNAME=$(mountpoint -n "$i" | cut -d ' ' -f1)
	FSTYPE=$(mount | grep "^$DEVNAME on " | cut -d ' ' -f5)
	# Ignore non-fat filesystems
	[[ "$FSTYPE" != "vfat" ]] && continue

	# Remount with umask=000, so everything always have executable flags
	umount "$i"
	mount -o rw,umask=000,noatime,nodiratime "${DEVNAME}" "$i"
done

# Setup
ln -s ${SDCARD}/tools/dropbearmulti /tmp/scp
ln -s ${SDCARD}/tools/dropbearmulti /tmp/dropbearkey
ln -s ${SDCARD}/tools/dropbearmulti /tmp/dropbear
ln -s ${SDCARD}/tools/dropbearmulti /tmp/dbclient
ln -s ${SDCARD}/tools/sftp-server /tmp/sftp-server
ln -s ${SDCARD}/tools/avahi-daemon /tmp/avahi-daemon

# Generate keys if needed
if [[ ! -f "${DROPBEAR_ID}" ]]; then
	/tmp/dropbearkey -t rsa -f "${DROPBEAR_ID}"
fi

# Run and wait for commands
# killItWithFire
/tmp/dropbear -r "${DROPBEAR_ID}" -F &
/tmp/avahi-daemon -D -f "${AVAHI_CONF}"
