terraform plan -input=false -var-file=./env/staging.tfvars

terraform apply -input=false -var-file=./env/staging.tfvars -auto-approve
terraform apply -input=false -var-file=./env/prod.tfvars -auto-approve

terraform destroy -input=false -var-file=./env/staging.tfvars -auto-approve
terraform destroy -input=false -var-file=./env/prod.tfvars -auto-approve
