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

# PenguinOS: vendor/aospa and vendor/udfps-resources (android_vendor_addons)
# both define the ax SDK, the HarmonySans font, the iconpack overlays and the
# ax prebuilts under the same module names, so Soong fails with "module ...
# already defined". Keep one copy of each:
# - ax SDK: vendor/aospa's. The two have diverged, and PenguinSystemUI uses
#   AxBlurColors.surfaceLightTint, which only vendor/aospa's ax_blur has.
#   frameworks/base SystemUI and GameSpace only use repeatWhenAttached and
#   the platform hooks, which are the same in both.
# - prebuilts, font and iconpacks: the addons ones. vendor/aospa's ax SDK
#   does not depend on its misc/prebuilts.
ifneq ($(wildcard vendor/udfps-resources/sdk/ax_compose/Android.bp),)
PRODUCT_SOURCE_ROOT_DIRS += \
    -vendor/udfps-resources/sdk/ax_blur \
    -vendor/udfps-resources/sdk/ax_compose \
    -vendor/udfps-resources/sdk/ax_kt \
    -vendor/udfps-resources/sdk/ax_platform_hooks \
    -vendor/aospa/misc/prebuilts \
    -vendor/aospa/overlay/FontHarmonySansOverlay \
    $(foreach p,Circular Filled Kai Rounded Sam Victor, \
        $(foreach t,Android Launcher Settings SystemUI ThemePicker, \
            -vendor/aospa/overlay/IconPack$(p)$(t)Overlay))
endif

# vendor/udfps-resources also defines the SystemUIClocks-* apps and
# PixelSetupWizardOverlayExpressive, which vendor/google/pixel (an exported
# Soong namespace) provides and installs, so Kati fails with "already
# defined". Only the pixel makefiles install them, so skip the addons copies.
PRODUCT_SOURCE_ROOT_DIRS += \
    -vendor/udfps-resources/rro_overlays/PixelSetupWizardOverlayExpressive \
    -vendor/udfps-resources/themes/SystemUIClocks

# PenguinOS: vendor/udfps-resources/prebuilt/bootanimation (from crDroid)
# selects on these, and Soong analyzes it even though it is not installed.
$(call soong_config_set,lineage_bootanimation,width,1080)
$(call soong_config_set,lineage_bootanimation,height,2400)

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
