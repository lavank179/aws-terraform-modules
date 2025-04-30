variable "vpc_name" {
  default = "TestVpc"
}
variable "vpc_cidr_block" {
  default = "172.2.0.0/16"
}

variable "no-vpc" {
  default = false
}

variable "existing_vpc_id" {
  default = ""
}

variable "common_tags" {
  default = {
    environment = "test-lavan"
  }
}

variable "environment" {
  default = "test-lavan"
}

variable "public_cidr_block" {
  default = ["172.2.1.0/24"]
}

variable "private_cidr_block" {
  default = ["172.2.10.0/24"]
}

variable "azs_pub" {
  default = ["us-west-2a", "us-west-2b"]
}

variable "azs_pri" {
  default = ["us-west-2a", "us-west-2b"]
}
variable "ingress_service" {
  default = []
}

variable "enable_nat_gate" {
  default = false
}

output "public_subs" {
  value = aws_subnet.public-subnets
}

output "private_subs" {
  value = aws_subnet.private-subnets
}

output "custom_vpc" {
  value = aws_vpc.aws_vpc
}