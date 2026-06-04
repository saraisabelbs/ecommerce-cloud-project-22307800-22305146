resource "aws_security_group" "rds_sg" {
  name        = "ecommerce-rds-sg"
  description = "Allow PostgreSQL access"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.ec2_sg_id]
  }

  tags = {
    Name = "ecommerce-rds-sg"
  }
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name = "ecommerce-db-subnet-group"

  subnet_ids = [
    var.public_subnet_id,
    var.private_subnet_id
  ]

  tags = {
    Name = "ecommerce-db-subnet-group"
  }
}

resource "aws_db_instance" "postgres_db" {
  identifier = "ecommerce-db"

  engine         = "postgres"
  engine_version = "17.4"

  instance_class = "db.t3.micro"

  allocated_storage = 20

  db_name  = "ecommerce"
  username = "postgres"
  password = "Password123!"

  publicly_accessible = false

  vpc_security_group_ids = [
    aws_security_group.rds_sg.id
  ]

  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name

  skip_final_snapshot = true

  tags = {
    Name = "ecommerce-db"
  }
}