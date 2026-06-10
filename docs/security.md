# Security Considerations

## Network Isolation

The RDS database is deployed in a **private subnet** and is not accessible from the internet. It can only be reached from the EC2 security group.

## Security Groups

**EC2 Security Group:**
- SSH (22) — for Ansible access
- HTTP (8082, 8083, 8084) — application ports

**RDS Security Group:**
- PostgreSQL (5432) — restricted to EC2 security group only

## IAM — Least Privilege

Each component has a dedicated IAM role with only the permissions it needs:

- **GitHub Actions role** — can assume role via OIDC, push/pull ECR images, send SQS messages
- **EC2 role** — can read SQS, write CloudWatch logs

## OIDC Authentication

GitHub Actions authenticates with AWS using **OpenID Connect (OIDC)** — no AWS access keys are stored in GitHub Secrets. The `AWS_ROLE_ARN` secret contains only the role ARN, not credentials.

## Secrets Management

- Database credentials are passed as environment variables at runtime via Ansible
- No credentials are hardcoded in source code or Dockerfiles
- The `.pem` key file is stored as a GitHub Secret (`EC2_SSH_PRIVATE_KEY`) and written to disk only during the CI/CD run, then discarded

## Terraform State Security

- State stored in **S3** with server-side encryption enabled
- State locking via **DynamoDB**
- Public access blocked on the S3 bucket
- Versioning enabled for state recovery

## Container Security

- Docker images use **non-root users** (`spring` user in all containers)
- Multi-stage builds ensure no build tools are included in final images
- Images are scanned for vulnerabilities via GitHub Container Registry
