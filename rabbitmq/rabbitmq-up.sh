#!/bin/bash

echo "* Get the TF ..."
mkdir -p terraform
cd terraform
cp /vagrant/rabbitmq/main.tf .

echo "* Create the cluster formation config ..."
mkdir -p rabbitmq/node-1
cat <<EOF | tee rabbitmq/node-1/rabbitmq
cluster_formation.peer_discovery_backend = rabbit_peer_discovery_classic_config
cluster_formation.classic_config.nodes.1 = rabbit@rabbitmq-1
EOF

echo "* Start the cluster ..."
terraform init
terraform apply -auto-approve
