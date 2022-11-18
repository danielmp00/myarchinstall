#!/bin/bash


localtime_config() {
  echo ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
  hwclock --systohc
}

lang_config() {
  echo -e "### adicionado na instalação ###\n\npt_BR.UTF-8" >> /etc/locale.gen
  echo locale-gen
  export LANG=pt_BR.UTF-8
  echo "LANG=pt_BR.UTF-8" > /etc/locale.conf
  echo "KEYMAP=br-abnt2" > /etc/vconsole.conf
}

host_config() {
  echo arch > /etc/hostname
  echo "127.0.0.1      localhost" >> /etc/hosts
  echo "::1            localhost" >> /etc/hosts
  echo "127.0.0.1      arch.localdomain  arch" >> /etc/hosts
}

install_pkgs() {
  pacman -S grub grub-btrfs efibootmgr \
            linux-headers networkmanager xorg pulseaudio pavucontrol \
            network-manager-applet wpa_supplicant \
            dialog os-prober mtools dosfstools reflector \
            git xdg-utils xdg-user-dirs \
            lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings \
            gpicview lxappearance lxappearance-obconf lxde-common \
            lxde-icon-theme lxhotkey lxinput lxlauncher lxpanel lxrandr \
            lxsession openbox pacmanfm obconf \
            arc-gtk-theme papirus-icon-theme \
            kvantum qt5ct ttf-fira-code ttf-firacode-nerd \
            ttf-hack-nerd ttf-nerd-fonts-symbols-2048-em-mono \
            xfce4-terminal xfce4-notifyd neovim rust nodejs yarn \
            dhcpcd dhclient firefox --no-confirm
}

enable_services() {
  systemctl enable NetworkManager
  systemctl enable dhcpcd
  systemctl enable lightdm
}

enable_btrfs() {
  sed 's/MODULES=()/MODULES=(btrfs i915)/g' /etc/mkinitcpio.conf
  mkinitcpio -p linux
}

install_grub() {
  grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=Arch
  grub-mkconfig -o /boot/grub/grub.cfg
}

create_user() {
  useradd -mG wheel "daniel"
  passwd daniel
}

finish() {
  echo "Saia do arch-chroot mode"
  echo 
  echo "Rode o Commando umount -l /mnt"
  echo
  echo "Reboot o sistema"
}


localtime_config
lang_config
host_config
install_pkgs
enable_services
enable_btrfs
install_grub
create_user
finish
