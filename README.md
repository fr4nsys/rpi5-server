# rpi5-server

### Nota Importante

Este repositorio está en proceso, se actualizará y detallarán los procesos.
Los comandos son para Arch Linux, si usas debian en tu rpi5 tendrás que buscar los comandos alternativos de instalación.

Deberás tener conocimientos básicos en Linux y estar cómodo trabajando con la línea de comandos.

Dado que la idea ejecutar múltiples servicios en una sola Raspberry Pi 5, es crucial monitorizar el rendimiento, utilizar refrigeración y ajustar la carga de trabajo según sea necesario para evitar sobrecargar el sistema.

La idea es dar servicio en la LAN y no exponer nada en internet, en caso de querer hacerlo tendrás que buscar la documentación de como hacerlo con tu router y que servicio exponer en cada puerto, también podrás utilizar un reverse proxy pero si planeas utilizar eso supongo que sabrás hacerlo y en un principio no tengo pensado incluirlo en esta documentación.

### 1. Servidor de Medios con Plex o Kodi

**Instalación y Configuración de Plex en Arch Linux:**

1. **Instalación:**
   - Actualiza tus paquetes: `sudo pacman -Syu`
   - Instala Plex Media Server: `sudo pacman -S plex-media-server`

2. **Configuración:**
   - Habilita y arranca Plex Media Server:
     ```
     sudo systemctl enable plexmediaserver.service
     sudo systemctl start plexmediaserver.service
     ```
   - Configura tu biblioteca de medios siguiendo las instrucciones en la interfaz web de Plex: `http://tu_raspberry_pi_ip:32400/web`

### 2. Estación de Juegos Retro con RetroPie

**Instalación de RetroPie:**

1. **Descarga e Instalación:**
   - RetroPie no tiene una instalación directa para Arch Linux, por lo que deberás compilar desde el código fuente.
   - Clona el repositorio de RetroPie: `git clone --depth=1 https://github.com/RetroPie/RetroPie-Setup.git`
   - Entra en el directorio: `cd RetroPie-Setup`
   - Ejecuta el script de instalación: `sudo ./retropie_setup.sh`

2. **Configuración:**
   - Sigue las instrucciones en el script para instalar los emuladores y configurar tus controladores.

### 3. Servidor de Archivos NAS con Samba

**Configuración de Samba para NAS:**

1. **Instalación:**
   - Instala Samba: `sudo pacman -S samba`

2. **Configuración:**
   - Edita el archivo de configuración `/etc/samba/smb.conf` para configurar tus comparticiones.
   - Reinicia el servicio Samba: `sudo systemctl restart smb.service`

### 4. Estación de Monitoreo de Red con Nagios

**Instalación de Nagios:**

1. **Instalación:**
   - Instala Nagios: `sudo pacman -S nagios`
   - Instala los plugins de Nagios: `sudo pacman -S nagios-plugins`

2. **Configuración:**
   - Configura Nagios editando los archivos en `/etc/nagios`.
   - Inicia Nagios: `sudo systemctl start nagios.service`

### 5. VPN o Firewall de Red

**Configuración de OpenVPN o iptables. Aunque seguramente utilize WireGuard:**

1. **OpenVPN:**
   - Instala OpenVPN: `sudo pacman -S openvpn`
   - Configura OpenVPN siguiendo la documentación oficial.

2. **Iptables:**
   - Instala iptables: `sudo pacman -S iptables`
   - Configura las reglas de iptables según tus necesidades de red.

### 6. Servidor Web o de Desarrollo

**Instalación de Apache/NGINX y Lenguajes de Programación:**

1. **Servidor Web:**
   - Instala Apache o NGINX: `sudo pacman -S apache` o `sudo pacman -S nginx`
   - Configura tu servidor editando los archivos de configuración en `/etc/httpd` (para Apache) o `/etc/nginx` (para NGINX).

2. **Lenguajes de Programación:**
   - Instala PHP, Python, etc., según tus necesidades: `sudo pacman -S php python`

### Consideraciones Finales
- **Gestión de recursos**: Monitoriza el uso de CPU y memoria regularmente.
- **Almacenamiento**: Utiliza discos duros externos o almacenamiento en red para archivos multimedia y juegos.
