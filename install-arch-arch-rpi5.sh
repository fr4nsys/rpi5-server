#!/bin/sh

# Variables:
export SDDEV="/dev/sdX"
export SDPARTBOOT="${SDDEV}1"
export SDPARTROOT="${SDDEV}2"
export SDMOUNT="/mnt/sdrpi"
export DOWNLOADDIR="/tmp/pi"
export DISTURL="https://fl.us.mirror.archlinuxarm.org/os/ArchLinuxARM-rpi-aarch64-latest.tar.gz"

# Crear directorio de descarga
mkdir -p "$DOWNLOADDIR"

# Descargar Arch Linux ARM
(
  cd "$DOWNLOADDIR" || exit 1
  curl -JLO "$DISTURL"
)

# Desmontar particiones si están montadas (para evitar errores)
umount "$SDPARTBOOT" 2>/dev/null
umount "$SDPARTROOT" 2>/dev/null

# Formatear particiones
mkfs.vfat -n BOOT -F32 "$SDPARTBOOT"
mkfs.ext4 -L ROOT -E lazy_itable_init=0,lazy_journal_init=0 -F "$SDPARTROOT"

# Montar particiones
mkdir -p "$SDMOUNT"
mount "$SDPARTROOT" "$SDMOUNT"
mkdir -p "${SDMOUNT}/boot"
mount "$SDPARTBOOT" "${SDMOUNT}/boot"

# Extraer sistema de archivos Arch Linux ARM
bsdtar -xpf "${DOWNLOADDIR}/ArchLinuxARM-rpi-aarch64-latest.tar.gz" -C "$SDMOUNT"

# Eliminar U-Boot y el kernel principal manualmente
rm -rf "${SDMOUNT}/boot/*"

# Agregar el kernel de la Fundación Raspberry Pi
mkdir -p "${DOWNLOADDIR}/linux-rpi"
pushd "${DOWNLOADDIR}/linux-rpi" || exit 1

# Si el enlace no funciona, encuentra una nueva versión aquí: http://fl.us.mirror.archlinuxarm.org/aarch64/core/
curl -JLO http://fl.us.mirror.archlinuxarm.org/aarch64/core/linux-rpi-6.12.6-1-aarch64.pkg.tar.xz

# Extracción y copia del kernel
tar xf linux-rpi*aarch64.pkg.tar.xz
cp -rf boot/* "${SDMOUNT}/boot/"
popd

# Desmontar la tarjeta SD de manera segura
sync
umount -R "$SDMOUNT"

echo "Ahora, retire la tarjeta microSD y arranque su Raspberry Pi para completar la instalación."
