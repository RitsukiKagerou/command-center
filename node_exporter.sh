#!/bin/bash

# buat user untuk node_exporter 
sudo useradd --system --no-create-home --shell /bin/false node_exporter

# download binnary node_exporter
wget https://github.com/prometheus/node_exporter/releases/download/v1.5.0/node_exporter-1.5.0.linux-amd64.tar.gz

# extract
tar -xvf node_exporter-1.5.0.linux-amd64.tar.gz

# pindah binnary node_exporter ke /usr/local/bin/
sudo mv node_exporter-1.5.0.linux-amd64/node_exporter /usr/local/bin/

# hapus node exporter archived dan folder
# rm -rf node_exporter*

# check versi node_exporter 
node_exporter --version

# membuat service node_exporter
sudo cat <<EOF > vim /etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

StartLimitIntervalSec=500
StartLimitBurst=5

[Service]
User=node_exporter
Group=node_exporter
Type=simple
Restart=on-failure
RestartSec=5s
ExecStart=/usr/local/bin/node_exporter \
    --collector.logind

[Install]
WantedBy=multi-user.target
EOF

# set enable service node_exporter
sudo systemctl enable node_exporter

# start service node_exporter
sudo systemctl start node_exporter

# tampilkan status service node_eporter
# sudo systemctl status node_exporter

# gunakan perintah berikut jika terjadi error
# journalctl -u node_exporter -f --no-pager

#tambah ini di config prometheus untuk job node_exporter
sudo cat <<EOF >> /etc/prometheus/prometheus.yml
   - job_name: node_export
     static_configs:
       - targets: ["localhost:9100"]
EOF

# check configurasi prometheus
# promtool check config /etc/prometheus/prometheus.yml

# repload prometheus
curl -X POST http://localhost:9090/-/reload