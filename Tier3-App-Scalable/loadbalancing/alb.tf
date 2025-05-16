resource "aws_lb" "frontend_alb" {
  name               = "${var.common_tags.environment}-frontend-alb"
  load_balancer_type = "application"
  subnets            = var.public_subnets
  security_groups    = [aws_security_group.frontend_sg.id]
  depends_on         = [aws_security_group.frontend_sg]
  internal = false
}

resource "aws_lb_target_group" "frontend_tg" {
  name        = "${var.common_tags.environment}-frontend-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
}

resource "aws_lb_listener" "frontend_listener" {
  load_balancer_arn = aws_lb.frontend_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend_tg.arn
  }
}

# Internal ALB
resource "aws_lb" "backend_alb" {
  name               = "${var.common_tags.environment}-backend-alb"
  internal           = true
  load_balancer_type = "application"
  subnets            = var.private_subnets
  security_groups    = [aws_security_group.backend_sg.id]
  depends_on         = [aws_security_group.backend_sg]
}

resource "aws_lb_target_group" "backend_tg" {
  name        = "${var.common_tags.environment}-backend-tg"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
}

resource "aws_lb_listener" "backend_listener" {
  load_balancer_arn = aws_lb.backend_alb.arn
  port              = 3000
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend_tg.arn
  }
}
