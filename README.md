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

## Authors

* Sara Serrano (a22307800)
* Núria Fernandes (a22305146)
