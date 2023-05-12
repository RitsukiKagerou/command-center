#!/bin/bash

# update repo dari https://mariadb.org/download/?t=repo-config
sudo apt-get install apt-transport-https curl
sudo curl -o /etc/apt/trusted.gpg.d/mariadb_release_signing_key.asc 'https://mariadb.org/mariadb_release_signing_key.asc'
sudo sh -c "echo 'deb https://download.nus.edu.sg/mirror/mariadb/repo/10.11/debian bullseye main' >>/etc/apt/sources.list"

# update repo list
sudo apt-get update

# check repo 
# apt show mariadb-server

# install mariadb-server
sudo apt-get install mariadb-server
