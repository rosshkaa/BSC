# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.provider "docker" do |d|
    d.has_ssh = true
    d.image = "androsovv/android-docker:latest"

# Allowing user to auth by ssh using vagrant ssh -- -l user
    config.vm.provision "shell", inline: <<-EOC
      sudo mkdir /home/user/.ssh
      sudo cp /home/vagrant/.ssh/authorized_keys /home/user/.ssh/authorized_keys
      sudo chown user:root /home/user/.ssh/
      sudo chown user:user /home/user/.ssh/authorized_keys
      sudo chmod 700 /home/user/.ssh
      sudo chmod 600 /home/user/.ssh/authorized_keys
      sudo service ssh restart
    EOC

# Restricting ssh access using password
    config.vm.provision "shell", inline: <<-EOC
      sudo sed -i -e "\\#PasswordAuthentication yes# s#PasswordAuthentication yes#PasswordAuthentication no#g" /etc/ssh/sshd_config
      sudo service ssh restart
    EOC
# Changing default passwords for vagrant and root
    config.vm.provision "shell", inline: <<-EOC
      password=`date +%s | sha256sum | base64 | head -c 32 ; echo`;echo "${password}\n${password}"| passwd 
      password=`date +%s | sha256sum | base64 | head -c 32 ; echo`;echo "${password}\n${password}"| passwd vagrant 
      password=`date +%s | sha256sum | base64 | head -c 32 ; echo`;echo "${password}\n${password}"| passwd user 
    EOC
# Giving access to /vagrant partition to user
    config.vm.provision "shell", inline: <<-EOC
      sudo chmod 777 /vagrant
    EOC
   
  end
end
