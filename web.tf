resource "aws_launch_template" "web" {
  name_prefix   = "web-lt-"
  image_id      = "ami-04a5ce820a419d6da" #"ami-04747637c5c87cf26" "ami-007855ac798b5175e"
  instance_type = var.web_instance_type

  vpc_security_group_ids = [aws_security_group.web.id]

  user_data = base64encode(templatefile("${path.module}/userdata_web.tpl", {}))

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "web" {
  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }
  name_prefix         = "web-asg-"
  min_size            = 1
  max_size            = 3
  desired_capacity    = 1
  vpc_zone_identifier = module.vpc.public_subnets
  target_group_arns   = [aws_lb_target_group.web.arn]

  tag {
    key                 = "Name"
    value               = "web"
    propagate_at_launch = true
  }

  tag {
    key                 = "Terraform"
    value               = "true"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = "dev"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_lb" "web" {
  name               = "web-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web.id]
  subnets            = module.vpc.public_subnets

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_lb_target_group" "web" {
  name     = "web-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
}

resource "aws_lb_listener" "web" {
  load_balancer_arn = aws_lb.web.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}

