variable "vpc_id" {

}

variable "common_tags" {

}

variable "taskRoleArn" {

}

variable "executionRoleArn" {

}

variable "frontend_image" {

}

variable "internal_backend_dns" {

}

variable "backend_image" {

}

variable "db_image" {

}

variable "frontend_dns" {

}

variable "desired_count" {

}

variable "frontend_sg" {

}

variable "backend_sg" {

}

variable "private_subnets" {

}

variable "frontend_tg_arn" {

}

variable "backend_tg_arn" {

}

variable "db_user" {

}

variable "db_password" {

}

variable "ami_id" {

}
variable "backend_instance_type" {

}

variable "key_name" {

}

variable "aws_region" {

}

variable "conatiner_cpu" {
  default = "256"
}

variable "container_memory" {
  default = "512"
}

variable "frontend_app_port" {

}

variable "backend_app_port" {

}

variable "db_name" {

}

variable "db_port" {

}