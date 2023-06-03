# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.ssh.insert_key = false

  # Docker Machine - Debian 11
  config.vm.box = "shekeriev/debian-11"
  config.vm.define "docker" do |docker|
    docker.vm.hostname = "docker"
    docker.vm.network "private_network", ip: "192.168.89.181"

    docker.vm.provision "shell", inline: <<-SHELL
    sudo apt-get update
  SHELL

    docker.vm.provision "ansible_local" do |ansible|
      ansible.become = true
      ansible.install_mode = :default
      ansible.playbook = "ansible/docker-terraform.yml"
      ansible.galaxy_role_file = "ansible/requirements.yml"
      ansible.galaxy_roles_path = "/etc/ansible/roles"
      ansible.galaxy_command = "sudo ansible-galaxy install --role-file=%{role_file} --roles-path=%{roles_path} --force"
    end
    docker.vm.provision "shell", path: "rabbitmq/rabbitmq-up.sh"
    docker.vm.provision "shell", path: "monitoring/monitoring-up.sh"
    docker.vm.provision "shell", path: "topics/topics-docker.sh"
    docker.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "2048", "--cpus", "4"]
      vb.gui = false
    end
  end

  # WEB - Debian 11
  config.vm.define "web" do |web|
    web.vm.box = "shekeriev/debian-11"
    web.vm.hostname = "web.do2.prep"
    web.vm.network "private_network", ip: "192.168.89.182"
    web.vm.provision "shell", path: "puppet/puppet-debian.sh"
    web.vm.provision "shell", path: "puppet/puppet-web.sh"
    web.vm.provision "puppet" do |puppet|
      puppet.manifests_path = "puppet"
      puppet.manifest_file = "web.pp"
      puppet.options = "--verbose --debug"
    end
    web.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "1024", "--cpus", "2"]
      vb.gui = false
    end
  end

  # DB - CentOS 8
  config.vm.define "db" do |db|
    db.vm.box = "shekeriev/debian-11"
    db.vm.hostname = "db.do2.prep"
    db.vm.network "private_network", ip: "192.168.89.183"
    db.vm.provision "shell", path: "puppet/puppet-debian.sh"
    db.vm.provision "shell", path: "puppet/puppet-db.sh"
    db.vm.provision "puppet" do |puppet|
      puppet.manifests_path = "puppet"
      puppet.manifest_file = "db.pp"
      puppet.options = "--verbose --debug"
    end
    db.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "1024", "--cpus", "2"]
      vb.gui = false
    end
  end

end
