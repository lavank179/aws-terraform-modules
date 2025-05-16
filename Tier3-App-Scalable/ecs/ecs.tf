resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.common_tags.environment}-cluster"
  tags = var.common_tags
}