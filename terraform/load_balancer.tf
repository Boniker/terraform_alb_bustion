# Target groups

resource "aws_lb_target_group" "tg-app1" {
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    port     = 8080
    protocol = "HTTP"
    path     = "/app1"
    interval = 10
    timeout  = 5
  }

  tags = {
    "Name" = "tg-app1-terraform"
  }
}

resource "aws_lb_target_group" "tg-app2" {
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    port     = 8081
    protocol = "HTTP"
    path     = "/app2"
    interval = 10
    timeout  = 5
  }

  tags = {
    "Name" = "tg-app2-terraform"
  }
}

# Attachment target group

resource "aws_lb_target_group_attachment" "tg-app1-attachment" {
  target_group_arn = aws_lb_target_group.tg-app1.arn
  target_id        = aws_instance.instance-nginx-host.id
  port             = 8080
}

resource "aws_lb_target_group_attachment" "tg-app2-attachment" {
  target_group_arn = aws_lb_target_group.tg-app2.arn
  target_id        = aws_instance.instance-nginx-host.id
  port             = 8081
}

# ALB

resource "aws_lb" "alb" {
  name               = "alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_default_security_group.sg-default.id]
  subnets            = [aws_subnet.subnet-public-1a.id, aws_subnet.subnet-public-1b.id]

  tags = {
    Environment = "alb-terraform"
  }

  depends_on = [aws_lb_target_group.tg-app1, aws_lb_target_group.tg-app2]
}

# Listeners alb

resource "aws_lb_listener" "alb-listeners" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  depends_on = [aws_lb_target_group.tg-app1, aws_lb_target_group.tg-app2]

  default_action {
    type = "forward"
    forward {
      target_group {
        arn = aws_lb_target_group.tg-app1.arn
      }
      target_group {
        arn = aws_lb_target_group.tg-app2.arn
      }
    }
  }

  tags = {
    "Name" = "alb-listeners-terraform"
  }
}

# ALB rules

resource "aws_lb_listener_rule" "alb-listeners-rules-app1" {
  listener_arn = aws_lb_listener.alb-listeners.arn
  priority     = 97

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg-app1.arn
  }

  condition {
    path_pattern {
      values = ["/app1"]
    }
  }

  tags = {
    "Name" = "alb-listeners-app1-terrafrom"
  }
}

resource "aws_lb_listener_rule" "alb-listeners-rules-app2" {
  listener_arn = aws_lb_listener.alb-listeners.arn
  priority     = 98

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg-app2.arn
  }

  condition {
    path_pattern {
      values = ["/app2"]
    }
  }

  tags = {
    "Name" = "alb-listeners-app2-terrafrom"
  }
}
