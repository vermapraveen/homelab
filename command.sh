#ansible -i ./inventory/hosts ubuntu -m ping -u pkv --ask-pass
#ansible-playbook ./playbooks/apt.yml -u pkv --ask-pass --ask-become-pass -i ./inventory/hosts
ansible-playbook ./playbooks/basic-tools.yml -u pkv --ask-pass --ask-become-pass -i ./inventory/hosts