resource "aws_sqs_queue" "orders_queue" {
  name = "ecommerce-orders-queue"

  tags = {
    Name = "ecommerce-orders-queue"
  }
}