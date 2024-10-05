resource "aws_launch_template" "app" {
  name_prefix   = "app-lt-"
  image_id      = "ami-01811d4912b4ccb26"
  instance_type = var.app_instance_type

  vpc_security_group_ids = [aws_security_group.app.id]

  user_data = base64encode(templatefile("${path.module}/userdata_app.tpl", {}))

  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_autoscaling_group" "app" {
  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }
  name_prefix         = "app-asg-"
  min_size            = 1
  max_size            = 3
  desired_capacity    = 1
  vpc_zone_identifier = module.vpc.private_subnets
  target_group_arns   = [aws_lb_target_group.app.arn]

  tag {
    key                 = "Name"
    value               = "app"
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


resource "aws_lb" "app" {
  name               = "app-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.app.id]
  subnets            = module.vpc.private_subnets

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_lb_target_group" "app" {
  name     = "app-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
}

resource "aws_lb_listener" "app" {
  load_balancer_arn = aws_lb.app.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}