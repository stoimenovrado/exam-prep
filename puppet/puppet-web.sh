#!/bin/bash

echo "* Installing the WEB modules for Puppet"
puppet module install puppetlabs-vcsrepo
puppet module install puppetlabs-stdlib
