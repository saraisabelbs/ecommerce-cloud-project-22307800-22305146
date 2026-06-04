terraform {
  backend "s3" {
    bucket         = "ecommerce-tf-state-saras-2025"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "ecommerce-tf-locks"
    encrypt        = true
  }
}