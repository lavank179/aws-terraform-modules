resource "aws_ecs_task_definition" "frontend-td" {
  family                   = "${var.common_tags.environment}-frontend-task-def"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.conatiner_cpu
  memory                   = var.container_memory
  task_role_arn            = var.taskRoleArn
  execution_role_arn       = var.executionRoleArn

  container_definitions = jsonencode([
    {
      name  = "${var.common_tags.environment}-frontend-container"
      image = var.frontend_image
      portMappings = [
        {
          containerPort = var.frontend_app_port
          hostPort      = var.frontend_app_port
          protocol      = "tcp"
          appProtocol   = "http"
        }
      ],
      essential = true,
      environment = [
        {
          "name" : "API_URL",
          "value" : "${var.internal_backend_dns}:${var.backend_app_port}"
        }
      ],
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group         = "/ecs/${var.common_tags.environment}-frontend",
          mode                  = "non-blocking",
          awslogs-create-group  = "true",
          max-buffer-size       = "25m",
          awslogs-region        = "${var.aws_region}",
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])

  depends_on = [aws_ecs_cluster.ecs_cluster]
}

#-----------------------------------------------------------------------------

resource "aws_ecs_task_definition" "backend-td" {
  family                   = "${var.common_tags.environment}-backend-task-def"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.conatiner_cpu
  memory                   = var.container_memory
  task_role_arn            = var.taskRoleArn
  execution_role_arn       = var.executionRoleArn

  container_definitions = jsonencode([
    {
      name  = "${var.common_tags.environment}-backend-container"
      image = var.backend_image
      portMappings = [
        {
          containerPort = var.backend_app_port
          hostPort      = var.backend_app_port
          protocol      = "tcp"
          appProtocol   = "http"
        }
      ],
      essential = true,
      environment = [
        {
          "name" : "DB_HOST",
          "value" : aws_instance.db_server.private_ip
        },
        {
          "name" : "FRONTEND_URL",
          "value" : var.frontend_dns
        },
        {
          "name" : "PORT",
          "value" : tostring(var.backend_app_port)
        },
        {
          "name" : "DB_USER",
          "value" : var.db_user
        },
        {
          "name" : "DB_PASSWORD",
          "value" : var.db_password
        },
        {
          "name" : "DB_NAME",
          "value" : var.db_name
        },
        {
          "name" : "DB_PORT",
          "value" : tostring(var.db_port)
        }
      ],
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group         = "/ecs/${var.common_tags.environment}-backend",
          mode                  = "non-blocking",
          awslogs-create-group  = "true",
          max-buffer-size       = "25m",
          awslogs-region        = "${var.aws_region}",
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])

  depends_on = [aws_ecs_cluster.ecs_cluster]
}