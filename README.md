# E-Commerce Cloud Infrastructure Project

## Overview

This project implements a cloud-native infrastructure for a distributed e-commerce platform using AWS and Terraform.

The infrastructure includes:

* Custom VPC
* Public and Private Subnets
* Internet Gateway
* Route Tables
* Security Groups
* EC2 Instance
* Amazon SQS Queue
* Amazon RDS PostgreSQL Database
* Terraform Remote State using S3
* DynamoDB State Locking

## Technologies

* AWS
* Terraform
* Amazon EC2
* Amazon RDS PostgreSQL
* Amazon SQS
* Amazon S3
* Amazon DynamoDB

## Infrastructure Components

### Networking

* Custom VPC
* Public Subnet
* Private Subnet
* Internet Gateway
* Route Table

### Compute

* EC2 Instance

### Messaging

* Amazon SQS Queue

### Persistence

* PostgreSQL Database (RDS)

### Infrastructure Management

* Terraform
* Remote State in S3
* State Locking with DynamoDB

## Deployment

Terraform is used to provision and manage all infrastructure resources.

Main commands:

```bash
terraform init
terraform plan
terraform apply
```

## Author

Cloud Information Systems Project
