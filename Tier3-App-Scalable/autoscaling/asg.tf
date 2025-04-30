resource "aws_autoscaling_group" "frontend_asg" {
  desired_capacity = var.desired_size
  min_size         = var.min_size
  max_size         = var.max_size
  name = "${var.common_tags.environment}-frontend-asg"
  launch_template {
    id      = aws_launch_template.frontend_lt.id
    version = aws_launch_template.frontend_lt.latest_version
  }
  vpc_zone_identifier = [var.public_subnets[0].id, var.public_subnets[1].id]
  target_group_arns   = var.frontend_tg_arns

  depends_on = [ aws_launch_template.frontend_lt ]
}

resource "aws_autoscaling_group" "backend_asg" {
  desired_capacity = var.desired_size
  min_size         = var.min_size
  max_size         = var.max_size
  name = "${var.common_tags.environment}-backend-asg"
  launch_template {
    id      = aws_launch_template.backend_lt.id
    version = aws_launch_template.backend_lt.latest_version
  }
  vpc_zone_identifier = [var.private_subnets[0].id, var.private_subnets[1].id]
  target_group_arns   = var.backend_tg_arns

  depends_on = [ aws_launch_template.backend_lt ]
}
