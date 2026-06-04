# Architecture

## System Components

The infrastructure is composed of:

* AWS VPC
* Public Subnet
* Private Subnet
* EC2 Instance
* PostgreSQL RDS Database
* Amazon SQS Queue

## Communication Flow

User/Application
→ EC2 Instance

EC2 Instance
→ PostgreSQL Database (RDS)

EC2 Instance
→ Amazon SQS Queue

The database is protected using a dedicated Security Group and is only accessible from the EC2 Security Group.

## Infrastructure Diagram

![AWS Architecture](diagrams/aws-architecture.png)

## Components

- VPC (10.0.0.0/16)
- Public Subnet (10.0.1.0/24)
- Private Subnet (10.0.2.0/24)
- EC2 Instance
- PostgreSQL RDS
- Amazon SQS
- Internet Gateway
- GitHub OIDC Integration