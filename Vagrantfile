MACHINES = {
    :centos => {
        :box_name => "centos/7",
        :ip_addr => '192.168.1.2',
        :script => './centos.sh',
    },
    :server2 => {
        :box_name => "centos/7",
        :ip_addr => '192.168.1.3',
        :script => './server2.sh',
    },
}
 

Vagrant.configure("2") do |config|
  MACHINES.each do |boxname, boxconfig|
    config.vm.define boxname do |box|
        config.vm.box = boxconfig[:box_name]
        config.vm.box_check_update = false
        box.vm.host_name = boxname.to_s
        box.vm.network "private_network", ip: boxconfig[:ip_addr], netmask: "255.255.255.0", virtualbox__intnet: "nfs_fuse_net"
        box.vm.provider :virtualbox do |vb|
          vb.customize ["modifyvm", :id, "--memory", "512"]
        end
        box.vm.provision "shell", inline: <<-SHELL
          echo -en "192.168.1.2 centos\n192.168.1.3 server2\n\n" | sudo tee -a /etc/hosts
          sudo useradd student && echo -e "student\nstudent\n" | sudo passwd student
          echo "student ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers
          sudo sed -i 's:^PasswordAuthentication no:PasswordAuthentication yes:' /etc/ssh/sshd_config
          sudo sed -i 's:^#PasswordAuthentication yes:PasswordAuthentication yes:' /etc/ssh/sshd_config
          sudo systemctl reload sshd
          sudo mkdir /home/student/.ssh && sudo chown student:student /home/student/.ssh && sudo chmod 700 /home/student/.ssh
          cat /vagrant/id_rsa.pub | sudo tee /home/student/.ssh/authorized_keys
          sudo cp /vagrant/id_rsa /vagrant/id_rsa.pub /home/student/.ssh && sudo chown student:student /home/student/.ssh/id_rsa /home/student/.ssh/id_rsa.pub /home/student/.ssh/authorized_keys && sudo chmod 600 /home/student/.ssh/id_rsa /home/student/.ssh/authorized_keys
          SHELL
        box.vm.provision "shell", path: boxconfig[:script]
    end
  end
end
