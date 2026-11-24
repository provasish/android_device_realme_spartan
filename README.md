Device configuration for realme GT Neo 3T / realme Q5 Pro (spartan, RMX3371)
==============

This is the `clo` branch. It builds the device with ROMs based on Paranoid
Android (AOSPA) `calcite`, which use the CLO/CAF HALs and the
`device/qcom/common` QTI components instead of LineageOS' `hardware/qcom-caf`.
The LineageOS tree lives on the `lineage-24.0` branch.

What changes compared to the LineageOS branch:

- The product is `aospa_spartan` and inherits `aospa-target.mk`.
- `TARGET_COMMON_QTI_COMPONENTS` (see `sm8250-common/common.mk`) pulls in the
  adreno, alarm, audio, av, bt, charging, display, gps, media, overlay, perf,
  telephony, usb, wfd and wlan components. Blobs those components provide are
  no longer listed in `proprietary-files.txt`.
- The kernel is built from `kernel/msm-4.19` with `KERNEL_DEFCONFIG`.
- LineageOS-only HALs (LiveDisplay, touch, lineage-sdk overlays) are gone.
  Double tap to wake goes through `TARGET_TAP_TO_WAKE_NODE`.

## Building

Sync an AOSPA `calcite` tree, then add the following to
`.repo/local_manifests/spartan.xml`. The first block is AOSPA's kona platform
manifest (`vendor/aospa/products/platforms/kona.xml`).

```xml
<?xml version="1.0" encoding="UTF-8"?>
<manifest>
  <remote name="provasish-gitlab" fetch="https://gitlab.com/provasishh" />

  <!-- kona platform -->
  <project path="vendor/qcom/opensource/audio-hal/primary-hal" name="AOSPA/android_hardware_qcom_audio" remote="aospa" revision="vauxite-865" />
  <project path="hardware/qcom/display" name="AOSPA/android_hardware_qcom_display" remote="aospa" revision="vauxite-865" />
  <project path="hardware/qcom/gps" name="AOSPA/android_hardware_qcom_gps" remote="aospa" revision="vauxite-legacy-component" />
  <project path="hardware/qcom/media" name="AOSPA/android_hardware_qcom_media" remote="aospa" revision="vauxite-865" />
  <remove-project name="AOSPA/android_hardware_qcom_thermal" />
  <project path="vendor/qcom/opensource/thermal-hal" name="AOSPA/android_hardware_qcom_thermal" remote="aospa" revision="vauxite-legacy" />

  <!-- spartan -->
  <project path="device/realme/spartan" name="provasish/android_device_realme_spartan" remote="github" revision="clo" />
  <project path="device/realme/sm8250-common" name="provasish/android_device_realme_sm8250-common" remote="github" revision="clo" />
  <project path="hardware/oplus" name="provasish/android_hardware_oplus" remote="github" revision="clo" />
  <project path="kernel/msm-4.19" name="provasish/android_kernel_realme_sm8250-a17" remote="github" revision="clo" />
  <project path="vendor/realme/spartan" name="proprietary_vendor_realme_spartan" remote="provasish-gitlab" revision="clo" clone-depth="1" />
  <project path="vendor/realme/sm8250-common" name="proprietary_vendor_realme_sm8250-common" remote="provasish-gitlab" revision="clo" clone-depth="1" />
</manifest>
```

Then:

```bash
repo sync --current-branch --no-tags -j4
source build/envsetup.sh
lunch aospa_spartan-userdebug
```

## Notes

- `hardware/oplus` (`clo`) drops the LineageOS-only touch, LiveDisplay and
  PowerShare HALs and the apps that use `org.lineageos.settings.resources`.
- The kernel (`clo`) has `AndroidKernel.mk`, `Android.bp` and
  `vendor/kona-perf-oplus_defconfig`, which is `kona-perf_defconfig` merged
  with `oplus.config`. Regenerate it if either source file changes.
- `proprietary_vendor_realme_sm8250-common` (`clo`) was regenerated from the
  new `proprietary-files.txt` with `extract-files.py --regenerate_makefiles`.
  The spartan blobs are unchanged.
