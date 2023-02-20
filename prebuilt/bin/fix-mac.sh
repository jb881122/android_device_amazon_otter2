#!/sbin/busybox sh
# fix-mac -- generates a MAC address in NVS for the WiFi driver to use

umask 0022

OLD_NVS=/tmp/wl1271-nvs.bin
SYS_NVS=/system/etc/firmware/ti-connectivity/wl1271-nvs_127x.bin
NEW_NVS=/system/etc/firmware/ti-connectivity/wl1271-nvs.bin

[ -f "$NEW_NVS" ] && exit 1

# Get NVS file from eMMC
dd if=/dev/block/mmcblk0boot0 of="$OLD_NVS" bs=1 count=912 skip=73728 2>/dev/null
hexdump "$OLD_NVS"|head -n1|grep '6d01' > /dev/null
if [ $? -ne 0 ]; then
    cp "$SYS_NVS" "$OLD_NVS"
fi

# Generates a random MAC address (12 hex digits, no colons)
gen_mac() {
    dd if=/dev/urandom bs=1 count=6 2>/dev/null|
    hexdump|
    sed -e 's/....... \(..\)\(..\) \(..\)\(..\) \(..\)\(..\)/\1\2\3\4\5\6/'|
    head -c12
}

# Gets the MAC address from a Kindle Fire 2
get_mac() {
    dd if=/dev/block/mmcblk0boot0 bs=1 count=12 skip=65580 2>/dev/null|
    tr '[:upper:]' '[:lower:]'
}

# Get the MAC if we can, otherwise generate it
MACADDR=$(get_mac)
if [ ! "$MACADDR" = "$(echo $MACADDR|sed -e 's/[^0-9a-f]//g')" ]; then
    MACADDR=$(gen_mac)
fi

# The MAC address is stored in the nvs file in two pieces: the four
# least-significant bytes in little-endian order starting at byte offset 3
# (indexed to 0), and the two most-significant bytes in little-endian order
# starting at byte offset 10.
#
# We're using printf to write these bytes to the file, so parse the MAC
# address to produce the escape sequences we'll use as arguments to printf.
lowbytes=$(echo "$MACADDR" | sed -e 's#\(..\)\(..\)\(..\)\(..\)\(..\)\(..\)#\\x\6\\x\5\\x\4\\x\3#')
highbytes=$(echo "$MACADDR" | sed -e 's#\(..\)\(..\)\(..\)\(..\)\(..\)\(..\)#\\x\2\\x\1#')

# Create the new nvs file by copying over the ROM's copy byte by byte,
# replacing only the pieces containing the MAC address
dd if="$OLD_NVS" of="$NEW_NVS" bs=1 count=3 2>/dev/null
printf "$lowbytes" >> "$NEW_NVS"
dd if="$OLD_NVS" of="$NEW_NVS" bs=1 skip=7 seek=7 count=3 2>/dev/null
printf "$highbytes" >> "$NEW_NVS"
dd if="$OLD_NVS" of="$NEW_NVS" bs=1 skip=12 seek=12 2>/dev/null

[ -f "$OLD_NVS" ] && rm "$OLD_NVS"

exit 0

