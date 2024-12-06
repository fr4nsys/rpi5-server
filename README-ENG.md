# rpi5-server
Raspberry Pi 5 | Arch Linux ARM server

***Language***
- [🇪🇸 Español](https://github.com/fr4nsys/rpi5-server/blob/main/README.md)
- 🇺🇸 English

### Important Note

This repository is a work in progress. The processes will be updated and detailed over time.  
Commands are for Arch Linux; if you are using Debian on your rpi5, you will need to find alternative installation commands.

You should have basic Linux knowledge, be comfortable working on the command line, and have basic networking skills.

---

# Installing Arch Linux ARM on the Raspberry Pi 5 (aarch64)

1. Run the following command to partition the SD card (replace `/dev/sdx` with the appropriate device name for your SD card):
   ```bash
   fdisk /dev/sdx
   ```
   ```bash
   a. Type 'p' to verify this is the correct SD card.
   b. Type 'g' to create a new GPT partition table on the card.
   c. Type 'n' to create a new partition.
   d. Press 'Enter' to accept partition number 1.
   e. Specify the first sector for the partition (e.g., '65536' for 32MiB).
   f. Specify the size of the partition as '+256M' for 256MiB.
   g. Type 't' to set the partition type.
   h. Press 'Enter' to select partition 1.
   i. Type '1' to set the partition type as 'EFI System'.
   j. Type 'n' to create another partition.
   k. Press 'Enter' to accept partition number 2.
   l. Press 'Enter' to accept the default first and last sectors.
   m. Type 'w' to write changes to the card.
   ```

2. Automate the installation of Arch Linux ARM on the microSD and install the Raspberry Pi Foundation's kernel `linux-rpi`.  
Make sure to review and adjust the script variables to match your environment.

   ```bash
   wget https://github.com/fr4nsys/rpi5-server/blob/main/install-arch-arch-rpi5.sh
   chmod +x install-arch-arch-rpi5.sh
   sudo ./install-arch-arch-rpi5.sh
   
   # Variables:
   export SDDEV=/dev/sdX
   export SDPARTBOOT=/dev/sdX1
   export SDPARTROOT=/dev/sdX2
   export SDMOUNT=/mnt/sdrpi
   export DOWNLOADDIR=/tmp/pi   
   ```

   **Script Content:**

   ```bash
   #!/bin/sh

   # Variables
   export SDDEV="/dev/sdX"
   export SDPARTBOOT="${SDDEV}1"
   export SDPARTROOT="${SDDEV}2"
   export SDMOUNT="/mnt/sdrpi"
   export DOWNLOADDIR="/tmp/pi"
   export DISTURL="https://fl.us.mirror.archlinuxarm.org/os/ArchLinuxARM-rpi-aarch64-latest.tar.gz"

   mkdir -p "$DOWNLOADDIR"
   cd "$DOWNLOADDIR" || exit 1
   curl -JLO "$DISTURL"

   umount "$SDPARTBOOT" 2>/dev/null
   umount "$SDPARTROOT" 2>/dev/null

   mkfs.vfat -n BOOT -F32 "$SDPARTBOOT"
   mkfs.ext4 -L ROOT -E lazy_itable_init=0,lazy_journal_init=0 -F "$SDPARTROOT"

   mkdir -p "$SDMOUNT"
   mount "$SDPARTROOT" "$SDMOUNT"
   mkdir -p "${SDMOUNT}/boot"
   mount "$SDPARTBOOT" "${SDMOUNT}/boot"

   bsdtar -xpf "${DOWNLOADDIR}/ArchLinuxARM-rpi-aarch64-latest.tar.gz" -C "$SDMOUNT"

   rm -rf "${SDMOUNT}/boot/*"

   mkdir -p "${DOWNLOADDIR}/linux-rpi"
   pushd "${DOWNLOADDIR}/linux-rpi" || exit 1
   curl -JLO http://fl.us.mirror.archlinuxarm.org/aarch64/core/linux-rpi-6.6.13-2-aarch64.pkg.tar.xz
   tar xf linux-rpi-6.6.13-2-aarch64.pkg.tar.xz
   cp -rf boot/* "${SDMOUNT}/boot/"
   popd

   sync
   umount -R "$SDMOUNT"
   echo "Eject the microSD card and boot your Raspberry Pi to complete the installation."
   ```

3. Boot your Raspberry Pi 5 with the installed Arch Linux ARM system.

   - Insert the microSD card into your Raspberry Pi, connect it to a wired network, and power it on.
   - Access the device via HDMI with a keyboard or via SSH over the wired network.

---

# Services

### 1. CasaOS Installation on Arch Linux ARM
   - Follow the [official guide](https://wiki.casaos.io/en/guides/install-on-arch-linux).

---

### 2. CasaOS Store Applications

Applications available in the [CasaOS App Store](https://store.casaos.io/):

#### Proxies and DNS
- **Nginx Proxy Manager:** [Official Site](https://nginxproxymanager.com/) | [GitHub](https://github.com/NginxProxyManager/nginx-proxy-manager)
- **DDNS Updater:** [GitHub](https://github.com/qdm12/ddns-updater)
- **Cloudflare Tunnel:** [Documentation](https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/)
- **Pi-hole:** [Official Site](https://pi-hole.net/) | [GitHub](https://github.com/pi-hole/pi-hole)

#### Monitoring and Diagnostics
- **Uptime Kuma:** [GitHub](https://github.com/louislam/uptime-kuma)
- **IT-Tools:** [GitHub](https://github.com/CorentinTh/it-tools)

#### Dashboards and Organizers
- **Dashy:** [GitHub](https://github.com/Lissy93/dashy)
- **Heimdall:** [GitHub](https://github.com/linuxserver/Heimdall)
- **Flame:** [GitHub](https://github.com/pawelmalak/flame)

#### Storage and Collaboration
- **PrivateBin:** [Official Site](https://privatebin.info/) | [GitHub](https://github.com/PrivateBin/PrivateBin)
- **Immich:** [GitHub](https://github.com/alextran1502/immich)

#### Multimedia and Downloads
- **MeTube:** [GitHub](https://github.com/alexta69/metube)
- **Excalidraw:** [Official Site](https://excalidraw.com/) | [GitHub](https://github.com/excalidraw/excalidraw)
