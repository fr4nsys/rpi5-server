# rpi5-server
Raspberry Pi 5 | Arch Linux ARM server

***Idioma***
- 🇪🇸 Español
- [🇺🇸 English](https://github.com/fr4nsys/rpi5-server/blob/main/README-ENG.md)

### Nota Importante

Este repositorio está en proceso, se actualizará y detallarán los procesos.
Los comandos son para Arch Linux, si usas debian en tu rpi5 tendrás que buscar los comandos alternativos de instalación.

Deberás tener conocimientos básicos en Linux, estar cómodo trabajando con la línea de comandos y tener conocimientos básicos de redes.

# Instalación de Arch Linux ARM en la Raspberry Pi 5 (aarch64)

1. Ejecuta el siguiente comando para particionar la tarjeta SD (sustituye `/dev/sdx` por el nombre del dispositivo apropiado para tu tarjeta SD):
   ```bash
   fdisk /dev/sdx
   ```
   ```bash
   a. Escribe 'p' para verificar que esta sea la tarjeta SD correcta.
   b. Escribe 'g' para crear una nueva tabla de particiones GPT en la tarjeta.
   c. Escribe 'n' para crear una nueva partición.
   d. Presiona 'Enter' para aceptar el número de partición 1.
   e. Especifica el primer sector para la partición (por ejemplo, '65536' para 32MiB).
   f. Especifica el tamaño de la partición como '+256M' para 256MiB.
   g. Escribe 't' para establecer el tipo de partición.
   h. Presiona 'Enter' para aceptar la partición de destino 1.
   i. Escribe '1' para establecer el tipo de partición como 'EFI System'.
   j. Escribe 'n' para crear una nueva partición.
   k. Presiona 'Enter' para aceptar el número de partición 2.
   l. Presiona 'Enter' para aceptar el primer y último sector por defecto.
   m. Escribe 'w' para escribir los cambios en la tarjeta.
   ```
2. Script para automatizar la descarga de Arch Linux ARM, instalación en la microSD e instalción del kernal de la Raspberry Pi Foundation 'linux-rpi',
Asegurate de entender el script y definir las variables correspondientes a tu entorno.

	```bash
	wget https://github.com/fr4nsys/rpi5-server/blob/main/install-arch-arch-rpi5.sh
	chmod +x install-arch-arch-rpi5.sh
	sudo ./install-arch-arch-rpi5.sh
	
	#Variables:
	export SDDEV=/dev/sdX
	export SDPARTBOOT=/dev/sdX1
	export SDPARTROOT=/dev/sdX2
	export SDMOUNT=/mnt/sdrpi
	export DOWNLOADDIR=/tmp/pi	
	```

	```bash
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
	curl -JLO http://fl.us.mirror.archlinuxarm.org/aarch64/core/linux-rpi-6.6.13-2-aarch64.pkg.tar.xz

	# Extracción y copia del kernel
	tar xf linux-rpi*aarch64.pkg.tar.xz
	cp -rf boot/* "${SDMOUNT}/boot/"
	popd

	# Desmontar la tarjeta SD de manera segura
	sync
	umount -R "$SDMOUNT"

	echo "Ahora, retire la tarjeta microSD y arranque su Raspberry Pi para completar la instalación."
	```
3. Configuración de la Raspberry Pi 5 con Arch Linux ARM ya instalado.

	Inicia la Raspberry Pi para actualizar Arch Linux ARM

	Inserta la tarjeta microSD en el Raspberry Pi, conéctalo a una red cableada con acceso a Internet y aplica la alimentación.
	Iniciar sesión

	Obtén acceso al Pi usando una pantalla HDMI y un teclado USB, o utiliza una conexión de red cableada (configurada para DHCP de forma predeterminada) con SSH o una conexión serial.

	Utiliza las credenciales predeterminadas de Arch Linux ARM.

	Nombre de usuario: alarm
	Contraseña: alarm

	Después de iniciar sesión, usa `su root` para obtener acceso de root. La contraseña de la cuenta root es 'root'.

	Todos los comandos siguientes se ejecutan en el Raspberry Pi como root.
	Actualizar Arch Linux ARM

	En los pasos anteriores, se eliminó el cargador de arranque y se reemplazó el kernel de manera forzada. Este "estado sucio" de archivos reemplazados manualmente no refleja los paquetes de Arch Linux ARM actualmente instalados. Esto debe corregirse primero eliminando los paquetes de los archivos que ya no están presentes. Luego, se debe instalar el paquete para el kernel actualmente utilizado.

	```bash
	pacman-key --init
	pacman-key --populate archlinuxarm

	pacman -R linux-aarch64 uboot-raspberrypi
	pacman -Syu --overwrite "/boot/*" linux-rpi
	```
![firtspacman](img/IMG_20240124_103040_244.jpg)
![secondpacman](img/IMG_20240124_103100_776.jpg)

	Reinicia la rpi. Antes puedes realizar configuraciones como definir el hostname, editar el archivo hosts, definir una ip statica, instalar openssh, etc.
	
![staticip](img/IMG_20240124_104743_597.jpg)


	```bash
	reboot
	```

Cuando el Pi llegue al prompt de inicio de sesión de usuario, la señal de video HDMI cambiará a una resolución más alta. Si tienes un ventilador compatible instalado en el encabezado del ventilador del Pi, este se controlará ahora en lugar de funcionar a velocidad máxima. Una vez que inicies sesión, notarás que con `ip addr` el adaptador de red inalámbrica está disponible.

Eso es todo. Ahora tienes Arch Linux ARM básico funcionando en tu Pi 5.
	
![neofech](img/IMG_20240124_104336_485.jpg)

	Actualización

	Si bien es cierto que Arch Linux ARM aún no admite la instalación en Raspberry Pi 5, efectivamente admite su funcionamiento, ya que todos los paquetes necesarios están disponibles en los repositorios oficiales. Esto incluye los últimos archivos de firmware. Estos archivos son necesarios para funciones como Wi-Fi y Bluetooth, y no se mencionaron anteriormente en esta guía porque no eran necesarios. Se actualizaron cuando se ejecutó `pacman -Syu`.

	Ejecutar `pacman -Syu` en el futuro también instalará el último kernel de la Fundación Raspberry Pi si hay una actualización disponible. Dado que las versiones actuales y más nuevas de los paquetes instalados admiten el Pi 5, seguirá funcionando sin problemas con software actualizado utilizando solo paquetes proporcionados por Arch Linux ARM.

	Manejo del futuro soporte oficial del Pi 5

	Cuando Arch Linux ARM comience a admitir el Pi 5, el kernel de la Fundación Raspberry Pi se podrá reemplazar por el kernel principal mediante la ejecución de:

	```bash
	pacman -Syu linux-aarch64 uboot-raspberrypi
	```

	Habrá una advertencia de que esos paquetes entran en conflicto con el paquete `linux-rpi` y si deseas reemplazarlo. Si lo haces, `linux-rpi` se eliminará antes de instalar los nuevos paquetes. Después de eso, tu instalación de Arch Linux ARM debería ser igual a la imagen oficial de Arch Linux ARM Raspberry Pi que admite el Pi 5.

# Servicios

## Instalación de CasaOS en Arch Linux ARM

**Seguir la guía oficial de CasaOS para Arch Linux ARM:**
   - [Instrucciones oficiales](https://wiki.casaos.io/en/guides/install-on-arch-linux)

---

## Instalación desde CasaOS Store

La mayoría de estas aplicaciones están disponibles en la [CasaOS App Store](https://store.casaos.io/), lo que facilita la instalación, actualizaciones y configuración directamente desde la interfaz web.

---

### 1. Gestión de Proxies y DNS

- **Nginx Proxy Manager:** Proxy inverso fácil de usar.
  - [Sitio oficial](https://nginxproxymanager.com/)
  - [Repositorio GitHub](https://github.com/NginxProxyManager/nginx-proxy-manager)

- **DDNS Updater:** Actualización automática para dominios dinámicos.
  - [Repositorio GitHub](https://github.com/qdm12/ddns-updater)

- **Cloudflare Tunnel:** Acceso seguro a servicios locales desde cualquier lugar.
  - [Documentación](https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/)

- **Pi-hole:** Bloqueo de anuncios y rastreadores a nivel de red.
  - [Sitio oficial](https://pi-hole.net/)
  - [Repositorio GitHub](https://github.com/pi-hole/pi-hole)

---

### 2. Monitoreo y Diagnóstico

- **Uptime Kuma:** Monitoreo de servicios con notificaciones.
  - [Repositorio GitHub](https://github.com/louislam/uptime-kuma)

- **IT-Tools:** Herramientas útiles para administradores de sistemas.
  - [Repositorio GitHub](https://github.com/CorentinTh/it-tools)

---

### 3. Dashboards y Organizadores

- **Dashy:** Dashboard personalizable para tus servicios.
  - [Repositorio GitHub](https://github.com/Lissy93/dashy)

- **Heimdall:** Panel organizador de aplicaciones.
  - [Repositorio GitHub](https://github.com/linuxserver/Heimdall)

- **Flame:** Alternativa ligera para panel de inicio.
  - [Repositorio GitHub](https://github.com/pawelmalak/flame)

---

### 4. Almacenamiento y Colaboración

- **PrivateBin:** Bloc de notas cifrado y autohospedado.
  - [Sitio oficial](https://privatebin.info/)
  - [Repositorio GitHub](https://github.com/PrivateBin/PrivateBin)

- **Immich:** Galería multimedia para fotos y videos.
  - [Repositorio GitHub](https://github.com/alextran1502/immich)

---

### 5. Multimedia y Descargas

- **MeTube:** Descargador de videos en streaming.
  - [Repositorio GitHub](https://github.com/alexta69/metube)

- **Excalidraw:** Herramienta de dibujo colaborativo.
  - [Sitio oficial](https://excalidraw.com/)
  - [Repositorio GitHub](https://github.com/excalidraw/excalidraw)
