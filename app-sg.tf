resource "aws_security_group" "app" {
  name        = "app"
  description = "Allow inbound traffic for app tier"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_security_group_rule" "app" {
  security_group_id = aws_security_group.app.id

  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"]
}