output "novo_pedido_queue_url" {
    value = aws_sqs_queue.novo_pedido_queue.url
}
output "pagamento_processado_queue_url" {
    value = aws_sqs_queue.pagamento_processado_queue.url
}
output "pedido_recebido_queue_url" {
    value = aws_sqs_queue.pedido_recebido_queue.url
}