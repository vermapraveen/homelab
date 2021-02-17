# ansible -i ./inventory/hosts ubuntu -m ping -u pkv --ask-pass
ansible-playbook ./playbooks/02-k8-config.yml -i ./inventory/hosts -u pkv
ansible-playbook ./playbooks/05-k8-config-master.yml -i ./inventory/hosts -u pkv
ansible-playbook ./playbooks/06-k8-config-worker.yml -i ./inventory/hosts -u pkv 
kubernetes/setups/lb/lb.sh
kubectl apply -f deploy.yml

# ansible-playbook ./playbooks/deploy-ssh.yml -i ./inventory/hosts -u pkv 

# ansible-playbook ./playbooks/apt.yml -u pkv -i ./inventory/hosts
# ansible-playbook ./playbooks/01-setup-ns.yml -u pkv -i ./inventory/hosts

# ansible-playbook ./playbooks/07-cleanup-master.yml /inventory/hosts -u pkv
# ansible-playbook ./playbooks/08-cleanup2.yml -i ./inventory/hosts -u pkv 

