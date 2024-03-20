resource "aws_sqs_queue" "novo_pedido_queue" {
  name = var.novo_pedido_queue

  # policy = jsonencode({
  #   Version = "2012-10-17"
  #   Statement = [
  #     {
  #       Effect    = "Allow"
  #       Principal = "*"
  #       Action    = "sqs:SendMessage"
  #       Resource  = "${aws_sqs_queue.novo_pedido_queue.arn}"
  #       # Condition = {
  #       #   ArnEquals = {
  #       #     "aws:SourceArn" = var.some_specific_arn
  #       #   }
  #       # }
  #     },
  #   ]
  # })
}

resource "aws_sqs_queue_policy" "novo_pedido_queue_policy" {
  queue_url = aws_sqs_queue.novo_pedido_queue.url

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "sqs:SendMessage"
        Resource  = aws_sqs_queue.novo_pedido_queue.arn
      },
    ]
  })
}

resource "aws_sqs_queue" "pagamento_processado_queue" {
  name = var.pagamento_processado_queue
}

resource "aws_sqs_queue_policy" "pagamento_processado_queue_policy" {
  queue_url = aws_sqs_queue.pagamento_processado_queue.url

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "sqs:SendMessage"
        Resource  = aws_sqs_queue.pagamento_processado_queue.arn
      },
    ]
  })
}

resource "aws_sqs_queue" "pedido_recebido_queue" {
  name = var.pedido_recebido_queue
}

resource "aws_sqs_queue_policy" "pedido_recebido_queue_policy" {
  queue_url = aws_sqs_queue.pedido_recebido_queue.url

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "sqs:SendMessage"
        Resource  = aws_sqs_queue.pedido_recebido_queue.arn
      },
    ]
  })
}

resource "aws_sqs_queue" "pedido_finalizado_queue" {
  name = var.pedido_finalizado_queue
}

resource "aws_sqs_queue_policy" "pedido_finalizado_queue_policy" {
  queue_url = aws_sqs_queue.pedido_finalizado_queue.url

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "sqs:SendMessage"
        Resource  = aws_sqs_queue.pedido_finalizado_queue.arn
      },
    ]
  })
}


# resource "aws_iam_policy" "sqs_access" {
#   name        = "SQSAccessForLabRole"
#   description = "Permite acesso ao SQS para LabRole"

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect    = "Allow"
#         Action    = ["sqs:SendMessage", "sqs:ReceiveMessage", "sqs:DeleteMessage", "sqs:GetQueueUrl"]
#         Resource  = [
#           aws_sqs_queue.novo_pedido_queue.arn,
#           aws_sqs_queue.pagamento_processado_queue.arn,
#           aws_sqs_queue.pedido_recebido_queue.arn,
#         ]
#       },
#     ]
#   })
# }

# resource "aws_iam_policy_attachment" "attach_sqs_access_to_labrole" {
#   name       = "SQSAccess-Attachment"
#   roles      = ["LabRole"]
#   policy_arn = aws_iam_policy.sqs_access.arn
# }
