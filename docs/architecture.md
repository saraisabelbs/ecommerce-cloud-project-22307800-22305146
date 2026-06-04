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

```text
             Internet
                 |
                 |
              EC2 Instance
              /         \
             /           \
            /             \
 PostgreSQL RDS      Amazon SQS
```
