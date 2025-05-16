resource "aws_ecs_service" "frontend" {
  name            = "${var.common_tags.environment}-frontend-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  launch_type     = "FARGATE"
  task_definition = aws_ecs_task_definition.frontend-td.arn
  desired_count   = var.desired_count

  network_configuration {
    subnets          = var.private_subnets
    security_groups  = [var.frontend_sg]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.frontend_tg_arn
    container_name   = "${var.common_tags.environment}-frontend-container"
    container_port   = var.frontend_app_port
  }

  depends_on = [aws_ecs_task_definition.frontend-td]
}

#-----------------------------------------------------------------------------

resource "aws_ecs_service" "backend" {
  name            = "${var.common_tags.environment}-backend-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  launch_type     = "FARGATE"
  task_definition = aws_ecs_task_definition.backend-td.arn
  desired_count   = var.desired_count

  network_configuration {
    subnets          = var.private_subnets
    security_groups  = [var.backend_sg]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.backend_tg_arn
    container_name   = "${var.common_tags.environment}-backend-container"
    container_port   = var.backend_app_port
  }

  depends_on = [aws_ecs_task_definition.backend-td]
}
