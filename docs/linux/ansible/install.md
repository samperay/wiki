## local setup

We could do a local installation of the setup using vagrant + virtualbox.

**versions**

Vagrant: 2.4.1

Oracle virtual box: 7.x

## configure vagrant

```
mkdir ansibledev
vim Vagrantfile

# start
Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"
  config.vm.network "private_network", ip: "192.168.56.10"
end

# save & quit

vagrant up
```

## configure ansible

Now, you are required to make a modification to the newly created server from your physical machine for exeuting and working on with the playbooks

```
# mkdir ansibledev
# vim ansible.cfg
[defaults]
inventory = ./hosts
remote_user = vagrant
ask_pass = false
host_key_checking = false
private_key_file=/Users/sunilamperayani/vagrant/ansibledev/.vagrant/machines/default/virtualbox/private_key

[privlege escalation]
become= true
become_method = sudo
become_user = root
become_ask_pass = false

# Note: this is the same IP which you have created using oracle virtual box.

# build ansible inventory!

# vim hosts
[test]
192.168.56.10
```

## test

Test your connectivity using ping command

```
ansible -m ping all
192.168.56.10 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": false,
    "ping": "pong"
}
```