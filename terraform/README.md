terraform plan -input=false -var-file=./env/staging.tfvars

terraform apply -input=false -var-file=./env/staging.tfvars -auto-approve
terraform apply -input=false -var-file=./env/prod.tfvars -auto-approve

terraform destroy -input=false -var-file=./env/staging.tfvars -auto-approve
terraform destroy -input=false -var-file=./env/prod.tfvars -auto-approve

## Docker Auth
```
ACCOUNT_ID=$(aws sts get-caller-identity | jq -r ".Account")
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin "482921978381.dkr.ecr.us-east-1.amazonaws.com"
```

## Docker
docker tag hello-world:latest aws_account_id.dkr.ecr.region.amazonaws.com/hello-world:latest
docker tag hello-world:latest aws_account_id.dkr.ecr.region.amazonaws.com/hello-world:latest

## Pull from docker
docker pull aws_account_id.dkr.ecr.region.amazonaws.com/hello-world:latest


## Backend app
* Required secrets
    * AWS_ACCESS_KEY_ID
    * AWS_SECRET_ACCESS_KEY
    * AWS_DEFAULT_REGION
    * ECR_REPOSITORY_NAME


# todo
* check health check url in api
* fix concurrency issues
