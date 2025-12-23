# Auto-generated Ansible inventory from Terraform
# This file is generated automatically - do not edit manually

[loadbalancer]
lb ansible_host=${lb_ip}

[webservers]
web1 ansible_host=${web1_ip}
web2 ansible_host=${web2_ip}

[all:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=${key_path}
ansible_ssh_common_args='-o StrictHostKeyChecking=no'

