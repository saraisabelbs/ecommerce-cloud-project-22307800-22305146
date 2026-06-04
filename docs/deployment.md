# Deployment Guide

## Infrastructure Deployment

Run:

```bash
terraform init
terraform plan
terraform apply
```

Approve the deployment when prompted.

## Provisioned Resources

The deployment creates:

* VPC
* Public Subnet
* Private Subnet
* Internet Gateway
* Route Table
* Security Groups
* EC2 Instance
* Amazon SQS Queue
* PostgreSQL RDS Database
* Terraform Backend Resources

## Verification

Verify resources in the AWS Console:

* EC2
* RDS
* SQS
* VPC
