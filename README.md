# E-Commerce Cloud Infrastructure Project

## Overview

This project implements a cloud-native infrastructure for a distributed e-commerce platform using AWS and Terraform.

The infrastructure was designed following Infrastructure as Code (IaC) principles and includes networking, compute, messaging, database, security, and remote state management components.

## Infrastructure Components

### Networking

* Custom VPC (10.0.0.0/16)
* Public Subnet (10.0.1.0/24)
* Private Subnet (10.0.2.0/24)
* Internet Gateway
* Route Table
* Security Groups

### Compute

* Amazon EC2 Instance

### Database

* Amazon RDS PostgreSQL

### Messaging

* Amazon SQS Queue

### Infrastructure Management

* Terraform Modules

    * VPC Module
    * EC2 Module
    * RDS Module
    * SQS Module
* Remote State Backend (Amazon S3)
* State Locking (Amazon DynamoDB)

### Security

* IAM Role for GitHub Actions
* OpenID Connect (OIDC) Integration
* Security Group-based access control
* Private database deployment

## Technologies

* AWS
* Terraform
* Amazon EC2
* Amazon RDS PostgreSQL
* Amazon SQS
* Amazon S3
* Amazon DynamoDB
* AWS IAM
* GitHub OIDC

## Repository Structure

```text
project/
├── docs/
│   ├── architecture.md
│   ├── setup.md
│   ├── deployment.md
│   ├── security.md
│   ├── limitations.md
│   └── diagrams/
├── infrastructure/
│   └── terraform/
│       ├── modules/
│       │   ├── vpc/
│       │   ├── ec2/
│       │   ├── rds/
│       │   └── sqs/
│       ├── main.tf
│       ├── provider.tf
│       └── backend.tf
└── README.md
```

## Deployment

Terraform is used to provision and manage all infrastructure resources.

### Initialize Terraform

```bash
terraform init
```

### Review Changes

```bash
terraform plan
```

### Apply Infrastructure

```bash
terraform apply
```

## Documentation

Additional documentation is available in the `docs/` directory:

* Architecture Design
* Deployment Process
* Security Decisions
* Setup Guide
* Project Limitations

## Application Services

The application layer consists of three microservices built with Java 21 and Spring Boot 3.4.

### Services

| Service | Port | Description |
|---|---|---|
| **catalog-service** | 8082 | Product catalog management (CRUD) |
| **order-service** | 8083 | Order management, communicates with catalog-service via OpenFeign and publishes events to SQS |
| **notification-service** | 8084 | SQS consumer — reads order events and logs notifications |

### Architecture Flow

```
Client
  │
  ▼
catalog-service (GET /products)
  
Client
  │
  ▼
order-service (POST /orders)
  │
  ├──── OpenFeign ────► catalog-service (validate product + reduce stock)
  │
  ├──── PostgreSQL (RDS) ────► saves order
  │
  └──── SQS ────► notification-service (logs notification)
```

### Asynchronous Communication

When an order is created, `order-service` publishes an `OrderCreatedEvent` to the AWS SQS queue. The `notification-service` polls the queue every 5 seconds and processes the messages.

## Running Locally

### Prerequisites
- Docker and Docker Compose
- AWS credentials configured (for SQS)

### Start all services

```bash
docker compose up --build
```

### Environment variables required

```bash
SQS_QUEUE_URL=https://sqs.eu-west-1.amazonaws.com/ACCOUNT_ID/order-notifications
AWS_REGION=eu-west-1
```

## CI/CD Pipeline

The project uses GitHub Actions for continuous integration and deployment.

### CI — Build & Push (`.github/workflows/ci.yml`)

Triggered on every push to `main` that changes files under `services/`.

1. Builds Docker image for each service (multi-stage build)
2. Pushes images to GitHub Container Registry (ghcr.io)
3. Tags images with the commit SHA

### CD — Deploy (`.github/workflows/cd.yml`)

Triggered automatically when the CI pipeline succeeds.

1. Authenticates with AWS via OIDC (no hardcoded credentials)
2. Runs Ansible playbook to deploy updated containers to EC2 instances

## Ansible

The `ansible/` directory contains the automation for configuring EC2 instances and deploying services.

```bash
# Install dependencies
pip install ansible
ansible-galaxy collection install community.docker

# Run full deployment
ansible-playbook -i ansible/inventory.yml ansible/playbook.yml

# Deploy a single service
ansible-playbook -i ansible/inventory.yml ansible/playbook.yml --limit catalog
```

## Repository Structure (Updated)

```text
project/
├── .github/
│   └── workflows/
│       ├── ci.yml          # Build & Push Docker images
│       └── cd.yml          # Deploy to EC2 via Ansible
├── ansible/
│   ├── playbook.yml        # Install Docker + deploy containers
│   ├── inventory.yml       # EC2 hosts
│   └── vars.yml            # Configuration variables
├── services/
│   ├── catalog-service/    # Product catalog (Spring Boot)
│   ├── order-service/      # Order management + SQS producer (Spring Boot)
│   └── notification-service/ # SQS consumer (Spring Boot)
├── infrastructure/
│   └── terraform/          # AWS infrastructure (Sara)
├── docs/
├── diagrams/
├── docker-compose.yml
└── README.md
```

## Authors

* Sara Serrano (a22307800)
* Núria Fernandes (a22305146)
