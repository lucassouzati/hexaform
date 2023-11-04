resource "aws_security_group_rule" "rds_sg_ingress_rule" {
  type              = "ingress"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]  # Recomenda-se restringir isso para apenas IPs específicos por razões de segurança.
  security_group_id = var.default_security_group_id
}