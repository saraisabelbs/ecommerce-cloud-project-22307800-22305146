# Setup Guide

## Prerequisites

### Local tools
- AWS CLI v2
- Terraform >= 1.9
- Docker Desktop
- Ansible (`pip install ansible`)
- Git
- Java 21 + Maven (for local development)

### AWS Account
- AWS account with billing configured
- IAM user with admin permissions (for initial setup)
- GitHub OIDC role configured (see `infrastructure/terraform/`)

## AWS Configuration

Configure AWS credentials:
```bash
aws configure
```

Verify connectivity:
```bash
aws sts get-caller-identity
```

## GitHub Configuration

### Required Secrets
Go to **Settings → Secrets and variables → Actions** and add:

| Secret | Description |
|---|---|
| `AWS_ROLE_ARN` | ARN of the GitHub Actions IAM role |
| `AWS_REGION` | AWS region (e.g. `us-east-1`) |
| `EC2_SSH_PRIVATE_KEY` | Contents of the EC2 key pair `.pem` file |
| `CATALOG_EC2_IP` | Public IP of the catalog EC2 instance |
| `ORDER_EC2_IP` | Public IP of the order EC2 instance |
| `NOTIFICATION_EC2_IP` | Public IP of the notification EC2 instance |
| `SQS_QUEUE_URL` | Full URL of the SQS queue |
| `DB_HOST` | RDS endpoint |
| `DB_USER` | Database username |
| `DB_PASSWORD` | Database password |
| `GHCR_TOKEN` | GitHub Personal Access Token with `read:packages` scope |

## Terraform Initialization

```bash
cd infrastructure/terraform
terraform init
terraform plan
terraform apply
```

## Ansible Setup

```bash
pip install ansible
ansible-galaxy collection install community.docker
```

Update `ansible/vars.yml` with the values from `terraform output`.
