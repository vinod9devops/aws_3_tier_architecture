resource "aws_security_group" "db" {
  name        = "db"
  description = "Allow inbound traffic for db tier"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_security_group_rule" "db" {
  security_group_id = aws_security_group.db.id

  type        = "ingress"
  from_port   = 3306
  to_port     = 3306
  protocol    = "tcp"
  cidr_blocks = ["10.0.3.0/24", "10.0.4.0/24"]
}
