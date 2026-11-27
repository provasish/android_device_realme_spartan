#
# Copyright (C) 2018 The LineageOS Project
#           (C) 2026 Paranoid Android
#
# SPDX-License-Identifier: Apache-2.0
#

ifeq (aospa_spartan,$(TARGET_PRODUCT))

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
TARGET_SUPPORTS_OMX_SERVICE := false
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit from spartan device
$(call inherit-product, device/realme/spartan/device.mk)

# Boot animation resolution.
TARGET_BOOT_ANIMATION_RES := 1080

# PenguinOS: UDFPS icon and animation packs (vendor/udfps-resources).
# Ignored on plain AOSPA. Set before aospa-target.mk, which reads it.
TARGET_HAS_UDFPS := true

# PenguinOS: window blur. Off by default on kona; set to true to try it.
TARGET_USES_BLUR ?= false

# Inherit from the AOSPA configuration.
$(call inherit-product, vendor/aospa/target/product/aospa-target.mk)

PRODUCT_BRAND := realme
PRODUCT_DEVICE := spartan
PRODUCT_MANUFACTURER := realme
PRODUCT_MODEL := RMX3371
PRODUCT_NAME := aospa_spartan

PRODUCT_GMS_CLIENTID_BASE := android-oppo

# Override device name for Play Store.
PRODUCT_BUILD_PROP_OVERRIDES += \
    BuildDesc="RMX3371-user 14 UKQ1.230924.001 S.1d262cb-66b86-66b87 release-keys" \
    BuildFingerprint=realme/RMX3371/RE54E4L1:14/UKQ1.230924.001/S.1d262cb-66b86-66b87:user/release-keys \
    DeviceName=RE54E4L1 \
    DeviceProduct=RMX3371 \
    SystemDevice=RE54E4L1 \
    SystemName=RMX3371

endif
