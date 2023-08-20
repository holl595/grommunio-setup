#!/bin/bash
# Add Swap
fallocate -l 4G /swapfile
mkswap /swapfile
swapon /swapfile
cp /etc/fstab /etc/fstab.bak
echo '/swapfile none swap sw 0 0' | tee -a /etc/fstab

# Install
./grommunio-setup

# edit /etc/apt/sources.list and uncomment deb-src
sed -i -e "s/^# deb-src/deb-src/g" /etc/apt/sources.list

# Fix admin page
./alien8.sh

echo "[Allow users to manage services]
Identity=unix-user:grommunio
Action=org.freedesktop.systemd1.manage-units
ResultAny=yes" > /etc/polkit-1/localauthority/50-local.d/manage-units.pkla

echo "options:
  dashboard:
    services: 0" > /etc/grommunio-admin-api/conf.d/01-services.yaml

echo "options:
  dashboard:
    services:
      - unit: rspamd.service
      - unit: gromox-delivery.service
      - unit: gromox-event.service
      - unit: gromox-http.service
      - unit: gromox-imap.service
      - unit: gromox-midb.service
      - unit: gromox-pop3.service
      - unit: gromox-delivery-queue.service
      - unit: gromox-timer.service
      - unit: gromox-zcore.service
      - unit: nginx.service
      - unit: php7.4-fpm.service
      - unit: postfix.service
      - unit: redis@grommunio.service" > /etc/grommunio-admin-api/conf.d/02-services.yaml

systemctl restart grommunio-admin-api