#!/bin/bash
# NovaOS 0.1.0 - Script Definitivo de Construcción (NovaCode Horizon)

set -e

echo "=== INICIANDO CONSTRUCCIÓN DEFINITIVA DE NOVAOS 0.1.0 ==="

# 1. Preparar directorio de trabajo
mkdir -p build_iso
cd build_iso

# 2. Configurar la estructura de la ISO
lb config \
    --architectures amd64 \
    --linux-flavours amd64 \
    --distribution bookworm \
    --archive-areas "main contrib non-free non-free-firmware" \
    --binary-images iso-hybrid \
    --bootloader syslinux

# 3. Definir paquetes del sistema operativo final
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
EOF

# 4. Compilar la imagen ISO final
echo "=== COMPILANDO LA ISO FINAL DE NOVAOS ==="
lb build

echo "=== NOVAOS 0.1.0 COMPILADO CON ÉXITO ==="
