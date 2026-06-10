output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_id" {
  value = module.vpc.public_subnet_id
}

output "private_subnet_id" {
  value = module.vpc.private_subnet_id
}

output "instance_id" {
  value = module.ec2.instance_id
}

output "db_endpoint" {
  value = module.rds.db_endpoint
}

output "queue_url" {
  value = module.sqs.queue_url
}

output "public_ip" {
  value = module.ec2.public_ip
}