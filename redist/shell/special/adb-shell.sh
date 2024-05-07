#!/bin/bash -x

killall -9 ayydbd

USB_GADGET=/sys/kernel/config/usb_gadget/rockchip
SERIAL_NUMBER=$(grep -oE -e 'androidboot\.serialno=[^ ]*' /proc/cmdline | cut -d= -f2)

# Disable device first.
echo "none" > ${USB_GADGET}/UDC

# Setup the USB Gadget
mkdir -p /dev/usb-ffs -m 0770
mkdir -p /dev/usb-ffs/adb -m 0770
mount -t configfs none /sys/kernel/config
mkdir -p ${USB_GADGET}  -m 0770
echo 0x2207 > ${USB_GADGET}/idVendor
echo 0x0006 > ${USB_GADGET}/idProduct
mkdir -p ${USB_GADGET}/strings/0x409   -m 0770
echo "${SERIAL_NUMBER}" > ${USB_GADGET}/strings/0x409/serialnumber
echo "EverSDK"  > ${USB_GADGET}/strings/0x409/manufacturer
echo "EverSDK ADB Adapter"  > ${USB_GADGET}/strings/0x409/product
mkdir -p ${USB_GADGET}/configs/b.1  -m 0770              
mkdir -p ${USB_GADGET}/configs/b.1/strings/0x409  -m 0770
echo 500 > ${USB_GADGET}/configs/b.1/MaxPower

mkdir -p ${USB_GADGET}/functions/ffs.adb
ln -s ${USB_GADGET}/functions/ffs.adb ${USB_GADGET}/configs/b.1/f1	

echo "adb" > ${USB_GADGET}/configs/b.1/strings/0x409/configuration

mkdir -p /dev/usb-ffs/adb
mount -o uid=2000,gid=2000 -t functionfs adb /dev/usb-ffs/adb
export service_adb_tcp_port=5555

cp /mnt/sdcard/tools/adbd /tmp/ayydbd
chmod +x /tmp/ayydbd
/tmp/ayydbd &
sleep 1

# Start the USB Gadget proper
UDC=`ls /sys/class/udc/| awk '{print $1}'`
echo $UDC > ${USB_GADGET}/UDC
