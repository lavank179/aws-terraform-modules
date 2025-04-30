resource "aws_vpc" "aws_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true

  tags = merge({ Name = var.vpc_name }, var.common_tags)
}