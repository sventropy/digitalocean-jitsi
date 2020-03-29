create:
	terraform apply -var-file="./main.tfvars"
delete:
	terraform destroy -var-file="./main.tfvars"
check:
	terraform plan -var-file="./main.tfvars"
connect:
	ssh root@${HOST_IP_ADDRESS} -i ~/.ssh/id_rsa_digitalocean
