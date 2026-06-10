# Deployment Guide

## 1. Infrastructure Deployment (Terraform)

```bash
cd infrastructure/terraform
terraform init
terraform plan
terraform apply
```

This creates: VPC, subnets, EC2, RDS, SQS, security groups, IAM roles.

## 2. Application Deployment (Automated via CI/CD)

Every push to `main` that changes files under `services/` triggers the full pipeline automatically:

### CI — Build & Push
1. Builds Docker image for each service (multi-stage build)
2. Pushes images to GitHub Container Registry (`ghcr.io`)
3. Tags images with `latest`

### CD — Deploy
1. Authenticates with AWS via OIDC (no hardcoded credentials)
2. Runs Ansible playbook:
   - Installs Docker on EC2
   - Logs in to GHCR
   - Pulls and runs each container

## 3. Manual Deployment (Ansible)

To deploy manually without CI/CD:

```bash
# Install dependencies
pip install ansible
ansible-galaxy collection install community.docker

# Run full deployment
ansible-playbook -i ansible/inventory.yml ansible/playbook.yml

# Deploy a single service
ansible-playbook -i ansible/inventory.yml ansible/playbook.yml --limit catalog
```

## 4. Running Locally (Docker Compose)

```bash
# Set required environment variables
export SQS_QUEUE_URL=https://sqs.us-east-1.amazonaws.com/ACCOUNT_ID/ecommerce-orders-queue
export AWS_REGION=us-east-1

# Start all services
docker compose up --build
```

Services available at:
- catalog-service: http://localhost:8082
- order-service: http://localhost:8083
- notification-service: http://localhost:8084

## 5. Verifying the Deployment

Check services are running on EC2:
```bash
ssh -i ~/.ssh/deploy_key.pem ec2-user@44.220.172.96 "docker ps"
```

Test catalog-service:
```bash
curl http://44.220.172.96:8082/products
```

Test order creation (triggers SQS event):
```bash
curl -X POST http://44.220.172.96:8083/orders \
  -H "Content-Type: application/json" \
  -d '{"customerName":"Test","customerEmail":"test@test.com","items":[{"productId":1,"quantity":1}]}'
```

## 6. Teardown

After the defense, destroy all AWS resources:
```bash
cd infrastructure/terraform
terraform destroy
```
