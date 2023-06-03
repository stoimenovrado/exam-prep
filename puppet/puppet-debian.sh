#!/bin/bash

echo "* Install Puppet for Debian ..."
wget https://apt.puppet.com/puppet7-release-bullseye.deb
dpkg -i puppet7-release-bullseye.deb
apt-get update
apt-get install -y puppet-agent
