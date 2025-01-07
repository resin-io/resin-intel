inherit kernel-balena

FILESEXTRAPATHS:prepend := "${THISDIR}/files:${THISDIR}/genericx86-64-ext:${THISDIR}/surface-go:"

SRC_URI += " \
    file://0001-Add-support-for-Quectel-EC20-modem.patch \
"

# Rest of the machines that are on kernel 5.10.21
# already have these patches
SRC_URI:append:surface-pro-6 = " \
    file://0003-ipts.patch \
    file://0007-BUGFIX-iwlwifi-mvm-Allow-multicast-~ta-frames-only-when-associated.patch \
    file://0008-BUGFIX-iwlwifi-mvm-Allow-multicast-~ta-frames-only-when-authorized.patch \
    file://fix_kasrl_build_error.patch \
"

SRC_URI:append:genericx86-64-ext = " \
    file://defconfig \
"

SRC_URI:append:virtio-x86 = " \
    file://defconfig \
"

BALENA_CONFIGS:remove:virtio-x86 = " \
    brcmfmac \
    ralink \
    rtl8192cu \
    r8188eu \
    hid-multitouch \
    apple_hfs \
    mdraid \
    dmcrypt \
"

do_kernel_configme[depends] += "virtual/${TARGET_PREFIX}binutils:do_populate_sysroot"
do_kernel_configme[depends] += "virtual/${TARGET_PREFIX}gcc:do_populate_sysroot"
do_kernel_configme[depends] += "bc-native:do_populate_sysroot bison-native:do_populate_sysroot"

BALENA_CONFIGS:append:surface-go = " sgo2_camera"
BALENA_CONFIGS[sgo2_camera] = " \
    CONFIG_MEMSTICK=m \
    CONFIG_MEMSTICK_REALTEK_PCI=m \
    CONFIG_PINCTRL_INTEL=y \
    CONFIG_V4L2_FWNODE=m \
    CONFIG_PINCTRL_SUNRISEPOINT=y \
    CONFIG_MEDIA_PCI_SUPPORT=y \
    CONFIG_VIDEO_IPU3_CIO2=m \
    CONFIG_CIO2_BRIDGE=y \
    CONFIG_VIDEOBUF2_DMA_SG=m \
    CONFIG_VIDEO_OV5693=m \
    CONFIG_STAGING_MEDIA=y \
    CONFIG_VIDEO_IPU3_IMGU=m \
    CONFIG_IOMMU_IOVA=m \
    CONFIG_ARCH_HAS_COPY_MC=y \
    CONFIG_PMIC_OPREGION=y \
    CONFIG_TPS68470_PMIC_OPREGION=y \
    CONFIG_REGMAP_I2C=y \
    CONFIG_I2C_DESIGNWARE_CORE=y \
    CONFIG_GPIO_TPS68470=y \
    CONFIG_MFD_CORE=y \
    CONFIG_MFD_TPS68470=y \
    CONFIG_REGULATOR=y \
    CONFIG_REGULATOR_GPIO=y \
    CONFIG_INTEL_SKL_INT3472=y \
"

#
# EHCI drivers
#
BALENA_CONFIGS:append = " ehci"
BALENA_CONFIGS[ehci] = " \
    CONFIG_USB_EHCI_HCD_PLATFORM=y \
    "

#
# Support for NVME block devices
#
BALENA_CONFIGS:append = " nvme"
BALENA_CONFIGS[nvme] = " \
    CONFIG_BLK_DEV_NVME=y \
    "

#
# Support Intel wrieless LAN adapter
#
BALENA_CONFIGS:append = " iwlwifi"
BALENA_CONFIGS:remove:virtio-x86 = "iwlwifi"
BALENA_CONFIGS_DEPS[iwlwifi] = " \
    CONFIG_PCI=m \
    CONFIG_MAC80211=m \
    CONFIG_HAS_IOMEM=m \
    "
BALENA_CONFIGS[iwlwifi] = " \
    CONFIG_IWLMVM=m \
    CONFIG_IWLDVM=m \
    CONFIG_IWLWIFI=m \
    "

#
# Support Intel NUC Bluetooth
#
BALENA_CONFIGS:append = " nuc_bluetooth"
BALENA_CONFIGS[nuc_bluetooth] = " \
    CONFIG_BT_HCIUART=m \
    CONFIG_BT_HCIUART_INTEL=y \
    CONFIG_BT_HCIBTUSB=m \
    "

#
# Support for DLM module
#
BALENA_CONFIGS:append = " dlm"
BALENA_CONFIGS[dlm] = " \
    CONFIG_DLM=m \
    "

#
# Support for serial console and more than 4 serial ports
#
BALENA_CONFIGS:append = " serial_8250"
BALENA_CONFIGS[serial_8250] = " \
    CONFIG_SERIAL_8250_CONSOLE=y \
    CONFIG_SERIAL_8250_NR_UARTS=32 \
    CONFIG_SERIAL_8250_RUNTIME_UARTS=32 \
    "

#
# Support Intel(R) 82575/82576 PCI-Express Gigabit Ethernet
#
BALENA_CONFIGS:append = " igb"
BALENA_CONFIGS_DEPS[igb] = " \
    CONFIG_PCI=m \
    "
BALENA_CONFIGS[igb] = " \
    CONFIG_IGB=m \
    "

# Support for RTL8723BE and RTL8821AE based WiFi/BT cards
BALENA_CONFIGS:append = " rtl8723be_rtl8821ae"
BALENA_CONFIGS_DEPS[rtl8723be_rtl8821ae] = " \
        CONFIG_RTL_CARDS=m \
"
BALENA_CONFIGS[rtl8723be_rtl8821ae] = " \
    CONFIG_RTL8723BE=m \
    CONFIG_RTL8821AE=m \
"

# Enable Intel Low Power Subsystem Support
# (for detecting the eMMC on some Atom based Intel SoCs)
BALENA_CONFIGS:append = " lpss"
BALENA_CONFIGS[lpss] = " \
    CONFIG_X86_INTEL_LPSS=y \
"

# Enable vxlan support (requested by customer)
BALENA_CONFIGS:append = " vxlan"
BALENA_CONFIGS[vxlan] = " \
    CONFIG_VXLAN=m \
"

# enable audio over HDMI (requested by customer for the Intel Compute Stick)
BALENA_CONFIGS:append = " hdmi_lpe_audio"
BALENA_CONFIGS[hdmi_lpe_audio] = " \
    CONFIG_HDMI_LPE_AUDIO=m \
"

BALENA_CONFIGS:append = " quectel_ec20"
BALENA_CONFIGS_DEPS[quectel_ec20] = "\
    CONFIG_USB_SERIAL_OPTION=m \
    CONFIG_USB_SERIAL_WWAN=m \
"
BALENA_CONFIGS[quectel_ec20] ="\
    CONFIG_USB_SERIAL_QUALCOMM=m \
"

BALENA_CONFIGS:append = " batman"
BALENA_CONFIGS[batman] = "\
    CONFIG_BATMAN_ADV=m \
    CONFIG_BATMAN_ADV_DAT=y \
    CONFIG_BATMAN_ADV_MCAST=y \
    CONFIG_BATMAN_ADV_DEBUGFS=y \
    CONFIG_BATMAN_ADV_DEBUG=y \
"

# Enable USB audio support
BALENA_CONFIGS:append = " usb_audio"
BALENA_CONFIGS[usb_audio]=" \
    CONFIG_SND_USB_AUDIO=m \
"

# Enable WiFi adapters that use Realtek chipset (like Edimax EW-7811Un)
BALENA_CONFIGS:append = " rtl_wifi"
BALENA_CONFIGS[rtl_wifi]=" \
    CONFIG_RTL8192CU=m \
"

# keep overlay as built-in for the following machines as they are using overlay instead of aufs
BALENA_CONFIGS:remove_surface-pro-6 = "overlayfs"
BALENA_CONFIGS:remove_surface-go = "overlayfs"
BALENA_CONFIGS:remove:genericx86-64-ext = "overlayfs"

# install aufs support even when BALENA_STORAGE is overlay2
BALENA_CONFIGS:append:genericx86-64-ext = " aufs"

# Add CAN support (requested by customer)
BALENA_CONFIGS:append = " enable_can"
BALENA_CONFIGS:remove:virtio-x86 = "enable_can"
BALENA_CONFIGS[enable_can] = " \
    CONFIG_CAN=m \
    CONFIG_CAN_DEV=m \
    CONFIG_CAN_RAW=m \
    CONFIG_CAN_SLCAN=m \
"

BALENA_CONFIGS:append = " huawei_modems"
BALENA_CONFIGS:remove:virtio-x86 = "huawei_modems"
BALENA_CONFIGS_DEPS[huawei_modems] = " \
    CONFIG_USB_SERIAL_OPTION=m \
    CONFIG_USB_USBNET=m \
"
BALENA_CONFIGS[huawei_modems] ="\
    CONFIG_USB_NET_HUAWEI_CDC_NCM=m \
"

BALENA_CONFIGS:append = " rndis"
BALENA_CONFIGS_DEPS[rndis] = " \
    CONFIG_USB_SERIAL_OPTION=m \
    CONFIG_USB_USBNET=m \
"
BALENA_CONFIGS[rndis] ="\
    CONFIG_USB_NET_RNDIS_HOST=m \
"

# requested by customer
BALENA_CONFIGS:append = " netfilter_time"
BALENA_CONFIGS[netfilter_time] = " \
    CONFIG_NETFILTER_XT_MATCH_TIME=m \
"

# requested by customer (support for Kontron PLD devices)
BALENA_CONFIGS:append = " gpio_i2c_kempld"
BALENA_CONFIGS_DEPS[gpio_i2c_kempld] = " \
    CONFIG_GPIOLIB=y \
    CONFIG_I2C=y \
    CONFIG_HAS_IOMEM=y \
    CONFIG_MFD_KEMPLD=m \
"
BALENA_CONFIGS[gpio_i2c_kempld] = " \
    CONFIG_GPIO_KEMPLD=m \
    CONFIG_I2C_KEMPLD=m \
"

# requested by customer
BALENA_CONFIGS:append = " snd_dyn_minors"
BALENA_CONFIGS[snd_dyn_minors] = " \
    CONFIG_SND_DYNAMIC_MINORS=y \
"

# requested by customer
BALENA_CONFIGS:append = " tulip"
BALENA_CONFIGS[tulip] = " \
    CONFIG_NET_TULIP=y \
    CONFIG_TULIP=m \
"

# requested by customer
BALENA_CONFIGS:append = " hyperv_net"
BALENA_CONFIGS_DEPS[hyperv_net] = " \
    CONFIG_HYPERV=y \
    CONFIG_HYPERVISOR_GUEST=y \
"
BALENA_CONFIGS[hyperv_net] = " \
    CONFIG_HYPERV_NET=m \
"

# requested by user
BALENA_CONFIGS:append = " temp_sensors"
BALENA_CONFIGS[temp_sensors] = " \
    CONFIG_SENSORS_CORETEMP=m \
    CONFIG_SENSORS_NCT6775=m \
"

# requested by user
BALENA_CONFIGS:append = " acpi_wmi"
BALENA_CONFIGS[acpi_wmi] = " \
    CONFIG_ACPI_WMI=m \
"

BALENA_CONFIGS:append = " mwifiex_pcie"
BALENA_CONFIGS[mwifiex_pcie] = " \
    CONFIG_MWIFIEX=m \
    CONFIG_MWIFIEX_PCIE=m \
"

BALENA_CONFIGS:append = " uinput"
BALENA_CONFIGS_DEPS[uinput] = " \
    CONFIG_INPUT_MISC=y \
"
BALENA_CONFIGS[uinput] = " \
    CONFIG_INPUT_UINPUT=m \
"

BALENA_CONFIGS:append = " ath10k_pci"
BALENA_CONFIGS:remove:virtio-x86 = "ath10k_pci"
BALENA_CONFIGS_DEPS[ath10k_pci] = " \
    CONFIG_ATH10K=m \
"
BALENA_CONFIGS[ath10k_pci] = " \
    CONFIG_ATH10K_PCI=m \
"

BALENA_CONFIGS:append = " mmc_realtek_pci"
BALENA_CONFIGS:remove:virtio-x86 = "mmc_realtek_pci"
BALENA_CONFIGS_DEPS[mmc_realtek_pci] = " \
    CONFIG_MISC_RTSX_PCI=m \
"
BALENA_CONFIGS[mmc_realtek_pci] = " \
    CONFIG_MMC_REALTEK_PCI=m \
"

# enable touchscreen driver for the Microsoft Surface Pro 6
BALENA_CONFIGS:append:surface-pro-6 = " ipts_touchscreen_sp6"
BALENA_CONFIGS[ipts_touchscreen_sp6] = " \
    CONFIG_INTEL_IPTS=m \
"

# the following are not compile deps but rather runtime deps
BALENA_CONFIGS:append:surface-pro-6 = " touchscreen_surfaces"
BALENA_CONFIGS:append:surface-go = " touchscreen_surfaces"
BALENA_CONFIGS_DEPS[touchscreen_surfaces] = " \
    CONFIG_INTEL_MEI=m \
    CONFIG_INTEL_MEI_ME=m \
    CONFIG_HID_MULTITOUCH=m \
"

BALENA_CONFIGS:append = " tpm"
BALENA_CONFIGS:remove:virtio-x86 = "tpm"
BALENA_CONFIGS_DEPS[tpm] = " \
    CONFIG_HW_RANDOM_TPM=y \
    CONFIG_SECURITYFS=y \
"
BALENA_CONFIGS[tpm] = " \
    CONFIG_TCG_TPM=y \
    CONFIG_TCG_TIS_CORE=y \
    CONFIG_TCG_TIS=y \
    CONFIG_TCG_CRB=y \
"

# enable the Intel TCO Watchdog
BALENA_CONFIGS:append = " watchdog"
BALENA_CONFIGS[watchdog] = " \
    CONFIG_ITCO_WDT=m \
"

# requested by user
BALENA_CONFIGS:append:genericx86-64 = " ad5593r"
BALENA_CONFIGS[ad5593r] = " \
    CONFIG_AD5593R=m \
"
BALENA_CONFIGS_DEPS[ad5593r] = " \
    CONFIG_IIO=m \
"

# set ATA_PIIX as built-in so we can boot legacy IDE mode without adding the ata_piix driver in the initramfs
# (some boards do not support AHCI mode)
BALENA_CONFIGS:append:genericx86-64 = " ata_piix"
BALENA_CONFIGS[ata_piix] = " \
    CONFIG_ATA_PIIX=y \
"

# requested by customer
BALENA_CONFIGS:append:genericx86-64 = " pinctrl_baytrail"
BALENA_CONFIGS[pinctrl_baytrail] = " \
    CONFIG_PINCTRL_BAYTRAIL=y \
"

# requested by user (this module was previously available but apparently got removed when we updated to warrior and a new kernel)
BALENA_CONFIGS:append:genericx86-64 = " ch341"
BALENA_CONFIGS[ch341] = " \
    CONFIG_USB_SERIAL_CH341=m \
"

BALENA_CONFIGS:append:genericx86-64 = " i2c_designware"
BALENA_CONFIGS[i2c_designware] = " \
    CONFIG_I2C_DESIGNWARE_PLATFORM=y \
    CONFIG_I2C_DESIGNWARE_PCI=y \
"

# requested by user for mounting HFS drives
BALENA_CONFIGS:append:genericx86-64 = " apple_hfs"
BALENA_CONFIGS[apple_hfs] = " \
    CONFIG_HFS_FS=m \
    CONFIG_HFSPLUS_FS=m \
"

# enable Intel Low Power Subsystem support in PCI mode in order to have the Designware I2C chip functioning on the Microsoft Surface Go
BALENA_CONFIGS:append:surface-go = " mfd_lpss_pci"
BALENA_CONFIGS[mfd_lpss_pci] = " \
    CONFIG_MFD_INTEL_LPSS_PCI=m \
"

# required to get the i2c touchscreen working on the Microsoft Surface Go
BALENA_CONFIGS:append:surface-go = " i2c_hid"
BALENA_CONFIGS[i2c_hid] = " \
    CONFIG_I2C_HID=m \
"

# requested by customer
BALENA_CONFIGS:append:genericx86-64 = " ixgbe"
BALENA_CONFIGS[ixgbe] = " \
    CONFIG_IXGBE=m \
"

# requested by customer
BALENA_CONFIGS:append:genericx86-64 = " xillybus"
BALENA_CONFIGS[xillybus] = " \
    CONFIG_XILLYBUS=m \
    CONFIG_XILLYBUS_PCIE=m \
"

# requested by customer
BALENA_CONFIGS:append:genericx86-64 = " i40e"
BALENA_CONFIGS[i40e] = " \
    CONFIG_I40E=m \
"

#
# Do not include debugging info in kernel and modules
#
BALENA_CONFIGS:append:genericx86-64-ext = " no-debug-info"
BALENA_CONFIGS[no-debug-info] ?= " \
    CONFIG_DEBUG_INFO=n \
    "

# eth controller on Intel NUC 11
BALENA_CONFIGS:append:genericx86-64 = " igc"
BALENA_CONFIGS[igc] = " \
    CONFIG_IGC=m \
"

# We get these patches from https://github.com/libcamera-org/linux/tree/surface/v5.8.18-yocto
SRC_URI:append:surface-go = " \
    file://0001-ARM-LPAE-Invalidate-the-TLB-for-module-addresses-dur.patch \
    file://0002-arm-ARM-EABI-socketcall.patch \
    file://0003-vexpress-Pass-LOADADDR-to-Makefile.patch \
    file://0004-arm-Makefile-Fix-systemtap.patch \
    file://0005-malta-uhci-quirks-make-allowance-for-slow-4k-e-c.patch \
    file://0006-4kc-cache-tlb-hazard-tlbp-cache-coherency.patch \
    file://0007-mips-Kconfig-add-QEMUMIPS64-option.patch \
    file://0008-mips-vdso-fix-jalr-t9-crash-in-vdso-code.patch \
    file://0009-powerpc-Add-unwind-information-for-SPE-registers-of-.patch \
    file://0010-powerpc-kexec-fix-for-powerpc64.patch \
    file://0011-powerpc-add-crtsavres.o-to-archprepare-for-kbuild.patch \
    file://0012-powerpc-Disable-attribute-alias-warnings-from-gcc8.patch \
    file://0013-powerpc-ptrace-Disable-array-bounds-warning-with-gcc.patch \
    file://0014-crtsavres-fixups-for-5.4.patch \
    file://0015-Revert-platform-x86-wmi-Destroy-on-cleanup-rather-th.patch \
    file://0016-arm-serialize-build-targets.patch \
    file://0017-powerpc-serialize-image-targets.patch \
    file://0018-kbuild-exclude-meta-directory-from-distclean-process.patch \
    file://0019-modpost-mask-trivial-warnings.patch \
    file://0020-menuconfig-mconf-cfg-Allow-specification-of-ncurses-.patch \
    file://0021-mount_root-clarify-error-messages-for-when-no-rootfs.patch \
    file://0022-check-console-device-file-on-fs-when-booting.patch \
    file://0023-nfs-Allow-default-io-size-to-be-configured.patch \
    file://0024-Resolve-jiffies-wrapping-about-arp.patch \
    file://0025-vmware-include-jiffies.h.patch \
    file://0026-compiler.h-Undef-before-redefining-__attribute_const.patch \
    file://0027-uvesafb-print-error-message-when-task-timeout-occurs.patch \
    file://0028-uvesafb-provide-option-to-specify-timeout-for-task-c.patch \
    file://0029-linux-yocto-Handle-bin-awk-issues.patch \
    file://0030-arm64-perf-fix-backtrace-for-AAPCS-with-FP-enabled.patch \
    file://0031-initramfs-allow-an-optional-wrapper-script-around-in.patch \
    file://0032-yaffs2-import-git-revision-b4ce1bb-jan-2020.patch \
    file://0033-yaffs2-adjust-to-proper-location-of-MS_RDONLY.patch \
    file://0034-fs-yaffs2-replace-CURRENT_TIME-by-other-appropriate-.patch \
    file://0035-Yaffs-check-oob-size-before-auto-selecting-Yaffs1.patch \
    file://0036-yaffs-Avoid-setting-any-ACL-releated-xattr.patch \
    file://0037-yaffs2-fix-memory-leak-in-mount-umount.patch \
    file://0038-yaffs-Fix-build-failure-by-handling-inode-i_version-.patch \
    file://0039-yaffs-repair-yaffs_get_mtd_device.patch \
    file://0040-yaffs-add-strict-check-when-call-yaffs_internal_read.patch \
    file://0041-yaffs2-fix-memory-leak-when-proc-yaffs-is-read.patch \
    file://0042-yaffs2-v5.6-build-fixups.patch \
    file://0043-yaffs-fix-misplaced-variable-declaration.patch \
    file://0044-aufs5-aufs5-kbuild.patch \
    file://0045-aufs5-aufs5-base.patch \
    file://0046-aufs5-aufs5-mmap.patch \
    file://0047-aufs5-aufs5-standalone.patch \
    file://0048-aufs5-core.patch \
    file://0049-FAT-Add-CONFIG_VFAT_FS_NO_DUALNAMES-option.patch \
    file://0050-FAT-Add-CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES-option.patch \
    file://0051-FAT-Added-FAT_NO_83NAME.patch \
    file://0052-fat-don-t-use-obsolete-random32-call-in-namei_vfat.patch \
    file://0053-perf-force-include-of-stdbool.h.patch \
    file://0054-perf-add-libperl-not-found-warning.patch \
    file://0055-perf-change-root-to-prefix-for-python-install.patch \
    file://0056-perf-add-sgidefs.h-to-for-mips-builds.patch \
    file://0057-perf-add-SLANG_INC-for-slang.h.patch \
    file://0058-perf-fix-bench-numa-compilation.patch \
    file://0059-perf-mips64-Convert-__u64-to-unsigned-long-long.patch \
    file://0060-perf-x86-32-explicitly-include-errno.h.patch \
    file://0061-perf-perf-can-not-parser-the-backtrace-of-app-in-the.patch \
    file://0062-defconfigs-drop-obselete-options.patch \
    file://0063-arm64-perf-Fix-wrong-cast-that-may-cause-wrong-trunc.patch \
    file://0064-perf-Alias-SYS_futex-with-SYS_futex_time64-on-32-bit.patch \
    file://0065-ext4-fix-Wstringop-truncation-warnings.patch \
    file://0066-tipc-fix-Wstringop-truncation-warnings.patch \
    file://0067-media-device-property-Add-a-function-to-test-is-a-fw.patch \
    file://0068-media-v4l2-async-Pass-notifier-pointer-to-match-func.patch \
    file://0069-media-ipu3-cio2-Return-actual-subdev-format.patch \
    file://0070-media-ipu3-cio2-Serialise-access-to-pad-format.patch \
    file://0071-media-ipu3-cio2-Validate-mbus-format-in-setting-subd.patch \
    file://0072-media-ipu3-cio2-Make-the-field-on-subdev-format-V4L2.patch \
    file://0073-media-ipu3-cio2-Use-unsigned-values-where-appropriat.patch \
    file://0074-media-ipu3-cio2-Remove-explicit-type-from-frame-size.patch \
    file://0075-media-ipu3-cio2-Rename-CIO2_IMAGE_MAX_LENGTH-as-CIO2.patch \
    file://0076-media-ipu3-cio2-Remove-traces-of-returned-buffers.patch \
    file://0077-media-ipu3-cio2-Check-receved-the-size-against-paylo.patch \
    file://0078-PCI-ACPI-Fix-up-ACPI-companion-lookup-for-device-0-o.patch \
    file://0079-Revert-ACPI-resources-Use-AE_CTRL_TERMINATE-to-termi.patch \
    file://0080-software_node-Fix-failure-to-put-and-get-references-.patch \
    file://0081-property-Return-true-in-fwnode_device_is_available-f.patch \
    file://0082-property-Add-support-for-calling-fwnode_graph_get_en.patch \
    file://0083-software_node-Enforce-parent-before-child-ordering-o.patch \
    file://0084-software_node-unregister-software_nodes-in-reverse-o.patch \
    file://0085-software_node-Add-support-for-fwnode_graph-family-of.patch \
    file://0086-lib-test_printf.c-Use-helper-function-to-unwind-arra.patch \
    file://0087-ipu3-cio2-Add-T-entry-to-MAINTAINERS.patch \
    file://0088-ipu3-cio2-Rename-ipu3-cio2.c-to-allow-module-to-be-b.patch \
    file://0089-media-v4l2-core-v4l2-async-Check-possible-match-in-m.patch \
    file://0090-acpi-Add-acpi_dev_get_next_match_dev-and-macro-to-it.patch \
    file://0091-ipu3-cio2-Add-functionality-allowing-software_node-c.patch \
    file://0092-acpi-utils-move-acpi_lpss_dep-to-utils.patch \
    file://0093-acpi-utils-Add-function-to-fetch-dependent-acpi_devi.patch \
    file://0094-i2c-i2c-core-base-Use-format-macro-in-i2c_dev_set_na.patch \
    file://0095-i2c-i2c-core-acpi-Add-i2c_acpi_dev_name.patch \
    file://0096-gpio-gpiolib-acpi-Export-acpi_get_gpiod.patch \
    file://0097-platform-x86-Add-intel_skl_int3472-driver.patch \
    file://0098-mfd-Remove-tps68470-MFD-driver.patch \
    file://0099-regulator-Introduce-tps68470-regulator-driver.patch \
    file://0100-clk-Introduce-clk-tps68470-driver.patch \
    file://0101-media-ipu3-cio2-Use-v4l2_get_link_freq-helper.patch \
    file://0102-media-v4l-Add-a-helper-for-obtaining-the-link-freque.patch \
    file://0103-media-v4l-common-Fix-naming-of-v4l2_get_link_rate.patch \
    file://0104-media-ipu3-cio2-Fix-mbus_code-processing-in-cio2_sub.patch \
    file://0105-ipu3-cio2-Fix-pixel-rate-derived-link-frequency.patch \
    file://0106-media-ipu3-cio2-Toggle-sensor-streaming-in-pm-runtim.patch \
    file://0107-media-i2c-Add-support-for-ov5693-sensor.patch \
    file://0108-media-i2c-ov5693-add-delays-to-powerdown.patch \
"

# This device type has been using the aufs storage driver,
# and during a HUP the storage in the inactive sysroot will
# still be aufs, so we need to include the aufs driver going
# further for it, as per the internal thread:
# https://www.flowdock.com/app/rulemotion/resin-devices/threads/K2TQiSUfNDqBT5Ih6cciNI2d9QJ
BALENA_CONFIGS:append:genericx86-64 = " aufs"

# do not build hpwdt (this apparently causes boot issues for a customer; Ubuntu blacklists this for a while now: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1432837)
BALENA_CONFIGS:append:genericx86-64-ext = " no-hpwdt"
BALENA_CONFIGS[no-hpwdt] ?= " \
    CONFIG_HP_WATCHDOG=n \
"

BALENA_CONFIGS:append:genericx86-64 = " optimize-size"
BALENA_CONFIGS[optimize-size] = " \
    CONFIG_CC_OPTIMIZE_FOR_SIZE=y \
"

BALENA_CONFIGS:remove:genericx86-64-ext = " optimize-size"

BALENA_CONFIGS:append = " i2c-dev"
BALENA_CONFIGS[i2c-dev] = " \
    CONFIG_I2C=y \
    CONFIG_I2C_CHARDEV=m \
    "

# requested by customer
BALENA_CONFIGS:append = " pinctrl_broxton"
BALENA_CONFIGS[pinctrl_broxton] = " \
    CONFIG_PINCTRL_BROXTON=y \
"
