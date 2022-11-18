#!/bin/bash



DRIVE="$1"

EFI="$DRIVE"1
SWAP="$DRIVE"2
ROOT="$DRIVE"3

make_volume_btrfs() {
  echo mkfs.btrfs "$1"
  echo mkfs.fat -F32 
  echo mkswap 
  echo mount "$1" /mnt

  SUBVOLS=(
          "@"
          "@home"
          "@opt"
          "@tmp"
          "@var"
  )

  for sub in ${SUBVOLS[@]}; do
    echo btrfs su cr /mnt/$sub
  done


  echo umount /mnt

  echo mount -o notime,compress=zstd,subvol=@ "$ROOT" /mnt

  echo mkdir -p /mnt/{home,opt,tmp,var}
  echo mount  $EFI /mnt/boot
  echo mount -o noatime,compress=zstd,subvol=@home "$ROOT" /mnt/home
  echo mount -o noatime,compress=zstd,subvol=@opt "$ROOT" /mnt/opt
  echo mount -o noatime,compress=zstd,subvol=@tmp "$ROOT" /mnt/tmp
  echo mount -o subvol=@var "$1" /mnt/var

}

make_efi_disk() {
  echo mkfs.fat -F32 "$EFI" 
}

make_swap_disk() {
  echo mkswap "$SWAP"
  echo swapon "$SWAP"
}

install() {
  echo pacstrap /mnt base base-devel linux linux-firmware nano intel-udoce btrfs-progs

  echo "genfstab -U /mnt >> /mnt/etc/fstab"

}

echo $EFI
echo $SWAP
echo $ROOT

make_efi_disk
make_swap_disk
make_volume_btrfs
install
