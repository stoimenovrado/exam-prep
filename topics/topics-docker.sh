#!/bin/bash

echo "* Enable the rabbitmq_federation plugin ..."
sleep 40
docker container exec rabbitmq-1 rabbitmq-plugins enable rabbitmq_federation

echo "* Get the TF ..."
cd /home/vagrant
mkdir -p terraform/topics-docker
cd terraform/topics-docker
cp /vagrant/topics/main.tf .

echo "* Start the cluster ..."
terraform init
terraform apply -auto-approve
