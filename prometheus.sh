#!/bin/bash

# buat user untuk prometheus
sudo useradd --system --no-create-home --shell /bin/false prometheus

# download promtheus di https://prometheus.io/download/
wget https://github.com/prometheus/prometheus/releases/download/v2.43.1/prometheus-2.43.1.linux-amd64.tar.gz

# ekstract
tar -xvf prometheus-2.43.1.linux-amd64.tar.gz

# buat direktori untuk prometheus
sudo mkdir -p /data /etc/prometheus

# masuk ke folder
cd prometheus-2.43.1.linux-amd64

# pindah binnary prometheus dan promtool ke /usr/local/bin/
sudo mv prometheus promtool /usr/local/bin/

# pindah library dan kebutuhan prometheus ke folder /etc/prometheus/
sudo mv consoles/ console_libraries/ /etc/prometheus/

# pindah file konfigurasi ke /etc/prometheus/prometheus.yml
sudo mv prometheus.yml /etc/prometheus/prometheus.yml

# ganti pemilik file dan folder untuk user prometheus
sudo chown -R prometheus:prometheus /etc/prometheus/ /data/

# check versi prometheus
prometheus --version

# file konfigurasi prometeus 
sudo cat <<EOF > /etc/systemd/system/prometheus.service
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

StartLimitIntervalSec=500
StartLimitBurst=5

[Service]
User=prometheus
Group=prometheus
Type=simple
Restart=on-failure
RestartSec=5s
ExecStart=/usr/local/bin/prometheus \
  --config.file=/etc/prometheus/prometheus.yml \
  --storage.tsdb.path=/data \
  --web.console.templates=/etc/prometheus/consoles \
  --web.console.libraries=/etc/prometheus/console_libraries \
  --web.listen-address=0.0.0.0:9090 \
  --web.enable-lifecycle

[Install]
WantedBy=multi-user.target
EOF

# enable service, supaya kalau system up service juga ikut up
sudo systemctl enable prometheus

# start service prometheus
sudo systemctl start prometheus

# cek status service prometheus
# sudo systemctl status prometheus

# jika ingin melihat log dari service prometehus
# journalctl -u prometheus -f --no-pager