###APPLICATION LOAD BALANCER### 

resource "aws_lb" "web" {
  name               = var.lb_name
  internal           = false
  load_balancer_type = "application"
  subnets            = var.public_subnet_ids  # best to pass this from networking module
  security_groups = [var.alb_security_group_id]

  tags = {
    Name = var.lb_name
    Env  = var.env
  }
}


###ALB TARGET GROUP###

resource "aws_lb_target_group" "web_target_group" {
  name     = "${var.prefix}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "instance"  # or "ip" if using ECS or Fargate

  health_check {
    enabled             = true
    interval            = 30
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
  }

  tags = {
    Name = "${var.prefix}-tg"
    Env  = var.env
  }
}


###ALB LISTENER###

resource "aws_lb_listener" "web_http" {
  load_balancer_arn = aws_lb.web.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_target_group.arn
  }
}
