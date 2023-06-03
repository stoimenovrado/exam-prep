#!/bin/bash

echo "* Get the TF ..."
cd /home/vagrant
mkdir -p terraform/monitoring
cd terraform/monitoring
cp /vagrant/monitoring/main.tf .

echo "* Start the containers ..."
terraform init
terraform apply -auto-approve
