# Assignment 3: Infrastructure as Code

**Name:** Kaushik Gnanasekar \
**Email:** gnanasekar.ka@northeastern.edu \
**NUID:** 002766012

## Prerequisites

- AWS account with permissions to create networking resources
- AWS cli configured with proper permissions and profile
- Installed and configured Terraform

## Steps

- Clone the repository
- Change the directory to the required environment (dev/production)
- Initialize the Terraform working directory:
  ```
  terraform init
  ```
- Add the required variables in a .tfvars file
- Run terraform plan to review the changes that Terraform will make:
  ```
  terraform plan
  ```
- Confirm the changes and apply if it looks good
  ```
  terraform apply
  ```
- For graceful teardown
  ```
  terraform destroy
  ```