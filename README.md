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
  <project path="vendor/realme/spartan" name="provasish/proprietary_vendor_realme_spartan" remote="github" revision="clo" clone-depth="1" />
  <project path="vendor/realme/sm8250-common" name="provasish/proprietary_vendor_realme_sm8250-common" remote="github" revision="clo" clone-depth="1" />
</manifest>
```

`hardware/oplus`, `kernel/msm-4.19` and the two `vendor/realme` repos need a
`clo` branch of their own. See the notes below.

Then:

```bash
repo sync --current-branch --no-tags -j4
source build/envsetup.sh
lunch aospa_spartan-userdebug
```

## Notes

- `hardware/oplus` must not depend on LineageOS-only modules. The LineageOS
  branch builds `vendor.lineage.touch-service.oplus`,
  `vendor.lineage.livedisplay-service.oplus`,
  `vendor.lineage.powershare-service.oplus` and several apps against
  `org.lineageos.settings.resources`. Those need to be removed or ported, and
  `sepolicy/qti/SEPolicy.mk` includes `device/lineage/sepolicy/libperfmgr`.
- AOSPA's kernel build (`AndroidKernel.mk`) takes a single `KERNEL_DEFCONFIG`.
  The kernel needs `AndroidKernel.mk`, `Android.bp` and one defconfig that
  merges `vendor/kona-perf_defconfig` and `vendor/oplus.config`.
- `proprietary-files.txt` changed, so the blobs have to be extracted again:

```bash
cd device/realme/spartan && ./extract-files.py /path/to/stock/dump
```
