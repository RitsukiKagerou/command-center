#!/bin/bash

# install kebutuhan grafana
sudo apt-get install -y apt-transport-https software-properties-common

# download grafana key
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -

# tambahkan package list grafana
echo "deb https://packages.grafana.com/oss/deb stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list

# install grafana via apt
sudo apt-get update
sudo apt-get -y install grafana

# automatic up setelah restart
sudo systemctl enable grafana-server

# jalankan service grafana
sudo systemctl start grafana-server

# lihat status service grafana
# sudo systemctl status grafana-server

# tambahkan datasource promtheus ke grafana
sudo bash -c 'cat <<EOF > /etc/grafana/provisioning/datasources/datasources.yaml
apiVersion: 1

datasources:
  - name: Prometheus
    type: prometheus
    url: http://localhost:9090
    isDefault: true
EOF'

# restart grafana supaya datasource ter load
sudo systemctl restart grafana-server
