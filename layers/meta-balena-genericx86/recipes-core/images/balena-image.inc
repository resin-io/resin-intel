#
# Genericx86-64
#

IMAGE_FSTYPES:append = " balenaos-img"

# Do not support live USB stick
NOISO = "1"
NOHDD = "1"

# Customize balenaos-img
BALENA_IMAGE_BOOTLOADER = "grub-efi grub"
BALENA_BOOT_PARTITION_FILES = " \
    grub-efi-bootx64.efi:/EFI/BOOT/bootx64.efi \
    grub:/grub/ \
    grub/i386-pc:/grub/i386-pc/ \
    grub/x86_64-efi:/EFI/BOOT/x86_64-efi/ \
    grubenv:/grub/grubenv \
    grubenv:/EFI/BOOT/grubenv \
    grub_extraenv:/grub/grub_extraenv \
    grub_extraenv:/EFI/BOOT/grub_extraenv \
    "

# virtio-x86 only supports PC/MBR booting
BALENA_IMAGE_BOOTLOADER:remove:virtio-x86 = "grub-efi"
BALENA_BOOT_PARTITION_FILES:remove:x86 = " \
    grub-efi-bootx64.efi:/EFI/BOOT/bootx64.efi \
    grub/x86_64-efi:/EFI/BOOT/x86_64-efi/ \
    "

write_mbr() {
    # Write MBR with first stage bootloader
    dd if=${DEPLOY_DIR_IMAGE}/grub/boot.img of=${BALENA_RAW_IMG} conv=notrunc bs=1
    # Write Post-MBR with second stage bootloader
    dd if=${DEPLOY_DIR_IMAGE}/grub/core.img of=${BALENA_RAW_IMG} conv=notrunc bs=1 seek=512
}

IMAGE_POSTPROCESS_COMMAND:append = " write_mbr; "

IMAGE_INSTALL:append = " efibootmgr"
