# Setup Guide

## Prerequisites

Before deploying the infrastructure, ensure the following tools are installed:

* AWS CLI v2
* Terraform >= 1.9
* Git
* AWS Account

## AWS Configuration

Configure AWS credentials:

```bash
aws configure
```

Verify connectivity:

```bash
aws sts get-caller-identity
```

## Terraform Initialization

Navigate to:

```bash
cd infrastructure/terraform
```

Initialize Terraform:

```bash
terraform init
```
