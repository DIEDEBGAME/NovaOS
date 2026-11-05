#!/bin/bash
# NovaOS 0.1.0 - Script Definitivo de Construcción (NovaCode Horizon)

set -e

echo "=== INICIANDO CONSTRUCCIÓN DEFINITIVA DE NOVAOS 0.3.3 ==="

# 1. Asegurarnos de estar en la raíz del proyecto (fuera de carpetas temporales viejas si las hubiera)
# Si tu script está en la carpeta 'scripts/', subimos un nivel para trabajar en la raíz
cd "$(dirname "$0")/.."

# Limpiar configuraciones anteriores de live-build si existen
lb clean || true

# 2. Configurar la estructura de la ISO directamente en la raíz
lb config \
    --architectures amd64 \
    --linux-flavours amd64 \
    --distribution bookworm \
    --archive-areas "main contrib non-free non-free-firmware" \
    --binary-images iso-hybrid \
    --bootloader syslinux

# 3. Definir paquetes del sistema operativo final (si no los tenías creados por archivo)
mkdir -p config/package-lists
cat <<EOF > config/package-lists/novaos.list.chroot
linux-image-amd64
live-boot
systemd-sysv
network-manager
network-manager-gnome
xfce4
xfce4-goodies
lightdm
firefox-esr
sudo
flatpak
gnome-software
gnome-software-plugin-flatpak
appstream
appstream-util
papirus-icon-theme
git
gtk2-engines-murrine
gtk2-engines-pixbuf
EOF

# 4. Dar permisos de ejecución obligatorios a los hooks para que corran sí o sí
if [ -d "config/hooks/live" ]; then
    chmod +x config/hooks/live/*
fi

# 5. Compilar la imagen ISO final
echo "=== COMPILANDO LA ISO FINAL DE NOVAOS ==="
lb build

# 6. Mover la ISO resultante a una carpeta limpia para que GitHub Actions la encuentre fácil
mkdir -p scripts/build_iso
mv *.iso scripts/build_iso/

echo "=== NOVAOS 0.1.0 COMPILADO CON ÉXITO ==="
