resource "aws_security_group" "web" {
  name        = "web"
  description = "Allow inbound traffic for web tier"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_security_group_rule" "web" {
  security_group_id = aws_security_group.web.id

  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "web_ssh" {
  security_group_id = aws_security_group.web.id

  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"] # Intentionally kept permissive, update as per requirement
}