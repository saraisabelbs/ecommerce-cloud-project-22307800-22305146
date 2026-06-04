terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

resource "aws_vpc" "ecommerce_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "ecommerce-vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.ecommerce_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "ecommerce-public-subnet"
  }
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.ecommerce_vpc.id

  tags = {
    Name = "ecommerce-igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.ecommerce_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "ecommerce-public-rt"
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_security_group" "web_sg" {
  name        = "ecommerce-web-sg"
  description = "Allow SSH and HTTP"
  vpc_id      = aws_vpc.ecommerce_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ecommerce-web-sg"
  }
}
data "aws_ami" "amazon_linux" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}
resource "aws_instance" "web_server" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t3.micro"

  subnet_id              = aws_subnet.public_subnet.id

  vpc_security_group_ids = [
    aws_security_group.web_sg.id
  ]

  key_name = "ecommerce-key"

  tags = {
    Name = "ecommerce-server"
  }
}

resource "aws_sqs_queue" "orders_queue" {
  name = "ecommerce-orders-queue"

  tags = {
    Name = "ecommerce-orders-queue"
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "ecommerce-rds-sg"
  description = "Allow PostgreSQL access"
  vpc_id      = aws_vpc.ecommerce_vpc.id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }

  tags = {
    Name = "ecommerce-rds-sg"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.ecommerce_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "ecommerce-private-subnet"
  }
}
resource "aws_db_subnet_group" "db_subnet_group" {
  name = "ecommerce-db-subnet-group"

  subnet_ids = [
    aws_subnet.public_subnet.id,
    aws_subnet.private_subnet.id
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