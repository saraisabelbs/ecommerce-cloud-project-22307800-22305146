# Limitations and Future Improvements

## Current Limitations

### Infrastructure
- Single EC2 instance hosts all three services — no high availability
- No auto-scaling configured
- Single availability zone deployment

### Application
- No API Gateway or load balancer in front of services
- `notification-service` logs notifications instead of sending real emails
- No authentication/authorization on the REST APIs
- Stock reduction is not atomic — race condition possible under high load

### CI/CD
- No rollback mechanism if deployment fails
- All three services deploy to the same EC2 instance

### Monitoring
- No CloudWatch alarms configured
- No centralized logging (logs are per-container on EC2)

## What Was Implemented

- ✅ Custom VPC with public and private subnets
- ✅ All infrastructure provisioned via Terraform modules
- ✅ Three containerized microservices (catalog, order, notification)
- ✅ PostgreSQL on RDS in private subnet
- ✅ Asynchronous communication via AWS SQS
- ✅ Ansible for EC2 configuration and container deployment
- ✅ GitHub Actions CI/CD with OIDC authentication
- ✅ No hardcoded credentials anywhere in the codebase

## Future Improvements

- Add CloudWatch Logs and alarms for monitoring
- Implement blue/green deployment strategy
- Add API Gateway with rate limiting
- Move to ECS/Fargate for better container orchestration
- Add multi-AZ RDS for high availability
- Implement proper secrets rotation via AWS Secrets Manager
