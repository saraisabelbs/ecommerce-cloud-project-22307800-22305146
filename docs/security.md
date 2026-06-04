# Security Considerations

## Network Isolation

The database is deployed inside a dedicated subnet group and protected by a dedicated security group.

## Security Groups

EC2 Security Group:

* SSH (22)
* HTTP (80)

RDS Security Group:

* PostgreSQL (5432)
* Access restricted to EC2 Security Group

## Terraform Backend Security

Terraform state is stored in:

* Amazon S3
* Server-side encryption enabled
* Versioning enabled

State locking is implemented using DynamoDB.

## Public Access

Public access is blocked on the Terraform state bucket.
