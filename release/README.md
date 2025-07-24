Before using script in this folder please don't forget to:
1. Add Vault token in file: ansible/.vault.token
2. Inisialize python env for Ansible: ansible/. env.sh
3. Fill in parameters to upload and deploy to the ansible/inventory/group_vars/env_name/main.yml
env_name - environment name
4. To deploy chosen environment run the next command:
deploy.sh env_name
5. Use the additional parameter "--all" or "-a" to avoid answering y/n. It will always be "yes"
deploy.sh env_name -a

6. Right now, if you have unreachable hosts in the inventory, the script will exit after the step with those hosts.
You need to restart the script and answer "no" to the steps you've completed.
It will be fixed after moving to the dynamic inventory.
