resource "aws_ssm_parameter" "db_private_ip" {
  name  = "/${var.common_tags.environment}/db_private_ip"
  type  = "String"
  value = aws_instance.db_server.private_ip
}

resource "aws_ssm_parameter" "db_user" {
  name  = "/${var.common_tags.environment}/db_user"
  type  = "String"
  value = var.db_user
}

resource "aws_ssm_parameter" "db_password" {
  name  = "/${var.common_tags.environment}/db_password"
  type  = "String"
  value = var.db_pass
}

resource "aws_ssm_parameter" "docker_username" {
  name  = "/${var.common_tags.environment}/docker_username"
  type  = "String"
  value = var.docker_username
}

resource "aws_ssm_parameter" "docker_password" {
  name  = "/${var.common_tags.environment}/docker_password"
  type  = "String"
  value = var.docker_password
}