# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.define "builder", primary: true do |builder|
    builder.vm.provider "docker" do |d|
      d.has_ssh = true
      d.image = "androsovv/android-docker:latest"
      d.remains_running = false
  
  # Move code below (bash) to dockerfile
      builder.vm.provision "shell", inline: <<-EOC
        sudo chmod 777 /vagrant
        sudo echo 'export ANDROID_HOME=/opt/android' >> /home/vagrant/.bashrc
        sudo echo 'export JAVA_HOME=/usr/lib/jvm/java-8-oracle' >> /home/vagrant/.bashrc
        sudo echo 'export ANDROID_SDK=/opt/android'>> /home/vagrant/.bashrc
        sudo echo 'export PATH=${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools' >> /home/vagrant/.bashrc
        sudo echo 'export PATH=${PATH}:/opt/tools' >> /home/vagrant/.bashrc
        sudo echo 'export JAVA_OPTS="-Xms256m -Xmx512m"'>> /home/vagrant/.bashrc
  
        sudo cp -r /root/.android /home/vagrant/.android
        sudo chown -R vagrant:vagrant /home/vagrant/.android
  
      EOC
    end
  end

  
  config.vm.define "emulator" do |emulator|
    emulator.vm.network "forwarded_port", guest: 5555, host: 5555
    emulator.vm.provider "docker" do |d|
#      d.has_ssh = false
#      d.create_args = ["-v", "/dev/kvm:/dev/kvm", "-e", "ANDROID_ARCH=x86"]
      d.image = "softsam/android-23:latest"
#      d.cmd = ['/bin/sh', '-c', '/start.sh']
      d.remains_running = false

    end

  end
end
