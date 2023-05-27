# create application load balancer
resource "aws_lb" "application_load_balancer" {
  name               = "${var.PROJECT_NAME}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.ALB_SG_ID]
  subnets            = [var.PUB_SUB_1_A_ID,var.PUB_SUB_2_B_ID]
  enable_deletion_protection = false

  tags   = {
    Name = "${var.PROJECT_NAME}-alb"
  }
}

# create target group
resource "aws_lb_target_group" "alb_target_group" {
  name        = "${var.PROJECT_NAME}-tg"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.VPC_ID

  health_check {
    enabled             = true
    interval            = 300
    path                = "/"
    timeout             = 60
    matcher             = 200
    healthy_threshold   = 5
    unhealthy_threshold = 5
  }

  lifecycle {
    create_before_destroy = true
  }
}

# create a listener on port 80 with redirect action
resource "aws_lb_listener" "alb_http_listener" {
  load_balancer_arn = aws_lb.application_load_balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.arn
  }
}

