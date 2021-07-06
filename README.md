# devops_final
# Code for AWS ec2 instance with nginx server working from docker container, server configuration via Ansible

**Start ec2 instance:**
  1. from terraform_ec2 directory execute  _terraform init_
  2. _terraform plan_
  3. _terraform apply_
  4. make sure that instance is running in AWS console 


**Configurate server and start Docker container:**
  1. from ansible directory execute  ansible-playbook _playbook.yml -i inventory_
  2. check ip_address:8000 -> you should have nginx page with text: "DevOps Course"
