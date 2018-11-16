#!/bin/bash
set -e
set -x

os="$(facter operatingsystem)"
os_family="$(facter osfamily)"
os_release="$(facter operatingsystemrelease)"
USERNAME=vagrant

if [[ $os_family == "Debian" ]]; then
    if [[ $os == "Debian" ]]; then
        echo "==> Installing ubuntu-desktop"
        sudo apt-get install -y --no-install-recommends gnome-core xorg
        if [[ $os_release < 9 ]]; then
            GDM_CONFIG=/etc/gdm/daemon.conf
        else
            GDM_CONFIG=/etc/gdm3/daemon.conf
        fi
        sudo mkdir -p "$(dirname ${GDM_CONFIG})"
        sudo bash -c "echo "[daemon]" > $GDM_CONFIG"
        sudo bash -c "echo "# Enabling automatic login" >> $GDM_CONFIG"
        sudo bash -c "echo "AutomaticLoginEnable=True" >> $GDM_CONFIG"
        sudo bash -c "echo "AutomaticLogin=${USERNAME}" >> $GDM_CONFIG"
        # LIGHTDM_CONFIG=/etc/lightdm/lightdm.conf
        # echo "==> Configuring lightdm autologin"
        # sudo bash -c "echo "[SeatDefaults]" >> $LIGHTDM_CONFIG"
        # sudo bash -c "echo "autologin-user=${USERNAME}" >> $LIGHTDM_CONFIG"
        elif [[ $os == "Ubuntu" ]]; then
        echo "==> Installing ubuntu-desktop"
        sudo apt-get install -y --no-install-recommends ubuntu-desktop
        if [[ $os_release < 17.10 ]]; then
            GDM_CUSTOM_CONFIG=/etc/gdm/custom.conf
            LIGHTDM_CONFIG=/etc/lightdm/lightdm.conf
            echo "==> Configuring lightdm autologin"
            sudo bash -c "echo "[SeatDefaults]" >> $LIGHTDM_CONFIG"
            sudo bash -c "echo "autologin-user=${USERNAME}" >> $LIGHTDM_CONFIG"
        else
            GDM_CUSTOM_CONFIG=/etc/gdm3/custom.conf
        fi
        sudo mkdir -p "$(dirname ${GDM_CUSTOM_CONFIG})"
        sudo bash -c "echo "[daemon]" >> $GDM_CUSTOM_CONFIG"
        sudo bash -c "echo "# Enabling automatic login" >> $GDM_CUSTOM_CONFIG"
        sudo bash -c "echo "AutomaticLoginEnable=True" >> $GDM_CUSTOM_CONFIG"
        sudo bash -c "echo "AutomaticLogin=${USERNAME}" >> $GDM_CUSTOM_CONFIG"
    fi
    elif [[ $os_family == "RedHat" ]]; then
    if [[ $os_release > 6 ]]; then
        if [[ $os == "CentOS" ]]; then
            sudo yum -y groupinstall "X Window System"
            sudo yum -y install gnome-classic-session gnome-terminal \
            nautilus-open-terminal control-center liberation-mono-fonts
            sudo ln -sf /lib/systemd/system/runlevel5.target /etc/systemd/system/default.target
            GDM_CUSTOM_CONFIG=/etc/gdm/custom.conf
            sudo mkdir -p "$(dirname ${GDM_CUSTOM_CONFIG})"
            sudo bash -c "echo "[daemon]" > $GDM_CUSTOM_CONFIG"
            sudo bash -c "echo "# Enabling automatic login" >> $GDM_CUSTOM_CONFIG"
            sudo bash -c "echo "AutomaticLoginEnable=True" >> $GDM_CUSTOM_CONFIG"
            sudo bash -c "echo "AutomaticLogin=${USERNAME}" >> $GDM_CUSTOM_CONFIG"
        fi
    fi
fi