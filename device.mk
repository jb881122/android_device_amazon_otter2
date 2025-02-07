# Copyright (C) 2013 The CyanogenMod Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

DEVICE_FOLDER := device/amazon/otter2

$(call inherit-product, device/amazon/otter-common/common.mk)

# Device overlay
DEVICE_PACKAGE_OVERLAYS += $(DEVICE_FOLDER)/overlay

# Hardware HALs
PRODUCT_PACKAGES += \
    lights.otter2 \
    power.otter2 \
    audio.primary.otter2 \
    sensors.otter2

# Rootfs
PRODUCT_COPY_FILES += \
    $(DEVICE_FOLDER)/fstab.otter2:/root/fstab.omap4430 \
    $(DEVICE_FOLDER)/init.omap4430.rc:/root/init.omap4430.rc \
    $(DEVICE_FOLDER)/init.omap4430.usb.rc:/root/init.omap4430.usb.rc \
    $(DEVICE_FOLDER)/init.recovery.omap4430.rc:/root/init.recovery.omap4430.rc \
    $(DEVICE_FOLDER)/ueventd.omap4430.rc:/root/ueventd.omap4430.rc

# Prebuilt system/bin
PRODUCT_COPY_FILES += \
    $(DEVICE_FOLDER)/prebuilt/bin/fix-mac.sh:/system/bin/fix-mac.sh

# Prebuilt system/etc
PRODUCT_COPY_FILES += \
    $(DEVICE_FOLDER)/prebuilt/etc/firmware/ducati-m3.bin:/system/etc/firmware/ducati-m3.bin

# Device settings
ADDITIONAL_BUILD_PROPERTIES += \
    sys.usb.vid=1949 \
    sys.usb.pid=000a \
    usb.vendor=1949 \
    usb.product.adb=000a \
    usb.product.mtpadb=000a

# Dalvik VM settings
ADDITIONAL_BUILD_PROPERTIES += \
    dalvik.vm.heapstartsize=8m \
    dalvik.vm.heapgrowthlimit=128m \
    dalvik.vm.heapsize=384m \
    dalvik.vm.heaptargetutilization=0.75 \
    dalvik.vm.heapminfree=2m \
    dalvik.vm.heapmaxfree=8m

