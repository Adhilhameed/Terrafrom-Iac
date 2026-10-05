# Task 3: Infrastructure as Code with Terraform

Provision a local Docker container (nginx) using Terraform and the Docker provider.

## Files
- `main.tf` - Terraform configuration (Docker provider, image, container, outputs)
- `.terraform.lock.hcl` - provider version lock file
- `logs/` - execution logs for every command

## Prerequisites
- Docker installed and running
- Terraform installed (`terraform -version`)
- Tested on WSL Ubuntu (Terraform v1.16.5, Docker provider kreuzwerker/docker v3.9.0)

## Steps performed

```bash
terraform init
terraform validate
terraform plan
terraform apply -auto-approve
docker ps --filter name=terraform-nginx
curl http://localhost:8080
terraform state list
terraform state show docker_container.nginx
terraform destroy -auto-approve
docker ps -a --filter name=terraform-nginx
```

## What I did
1. Declared the `kreuzwerker/docker` provider in `main.tf`.
2. Defined a `docker_image` (nginx:latest) and a `docker_container` (`terraform-nginx`) that uses it, mapping host port 8080 to container port 80.
3. Ran `terraform init`, then `terraform plan` to preview 2 resources to add.
4. Ran `terraform apply`, which created the image and container. Verified with `docker ps` and `curl`, which returned the "Welcome to nginx!" page.
5. Inspected the state with `terraform state list` and `terraform state show`.
6. Ran `terraform destroy` to remove both resources, and confirmed the container no longer exists.

## Execution logs
| Log | Command |
|---|---|
| `logs/01-init.log` | terraform init |
| `logs/02-validate.log` | terraform validate |
| `logs/03-plan.log` | terraform plan |
| `logs/04-apply.log` | terraform apply |
| `logs/05-docker-ps.log` | docker ps (container running) |
| `logs/06-curl.log` | curl http://localhost:8080 |
| `logs/07-state-list.log` | terraform state list |
| `logs/08-state-show.log` | terraform state show |
| `logs/09-destroy.log` | terraform destroy |
| `logs/10-docker-after-destroy.log` | docker ps -a (container gone) |

## Notes
- If port 8080 is busy: `terraform apply -var="external_port=8081"`
- State files (`terraform.tfstate`) and `.terraform/` are excluded via `.gitignore`.
