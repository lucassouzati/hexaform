resource "aws_sqs_queue" "novo_pedido_queue" {
  name = var.novo_pedido_queue
}

resource "aws_sqs_queue" "pagamento_processado_queue" {
  name = var.pagamento_processado_queue
}

resource "aws_sqs_queue" "pedido_recebido_queue" {
  name = var.pedido_recebido_queue
}
