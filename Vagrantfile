IMAGE_NAME = "geerlingguy/centos7"
VMs = ["target-app-server","target-db-server"]
NODE_CPU = 1 
NODE_MEM = 512

IP_BASE = "192.168.56."

Vagrant.configure("2") do |config|
      (0..VMs.length-1).each do |i|      
        config.vm.define "#{VMs[i]}" do |target|
            target.vm.box = IMAGE_NAME
            target.vm.network "private_network", ip: "#{IP_BASE}#{i + 20}"
            target.vm.hostname = "#{VMs[i]}"
            target.ssh.forward_agent = true
            target.vm.provider "virtualbox" do |v|
                v.memory = NODE_MEM
                v.cpus = NODE_CPU
            end            
            # target.vm.provision "ansible" do |ansible|
            #   ansible.extra_vars = {
            #         host_name:    target.vm.hostname,
            #     }
            #     # ansible.playbook = "./ansible/playbook.yaml"
            # end
        end
    end

end