output "queue_url" {
  value = aws_sqs_queue.orders_queue.id
}