#ansible -i ./inventory/hosts ubuntu -m ping -u pkv --ask-pass
#ansible-playbook ./playbooks/apt.yml -u pkv --ask-pass --ask-become-pass -i ./inventory/hosts
# ansible-playbook ./playbooks/02-k8-config.yml -u pkv --ask-pass --ask-become-pass -i ./inventory/hosts
# ansible-playbook ./playbooks/03-k8-basic-tools.yml -u pkv --ask-pass --ask-become-pass -i ./inventory/hosts
# ansible-playbook ./playbooks/04-k8-config-after-tool.yml -u pkv --ask-pass --ask-become-pass -i ./inventory/hosts
ansible-playbook ./playbooks/05-k8-config-master.yml -u pkv --ask-pass --ask-become-pass -i ./inventory/hosts
# ansible-playbook ./playbooks/06-k8-config-worker.yml -u pkv --ask-pass --ask-become-pass -i ./inventory/hosts