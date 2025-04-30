variable "desired_size" {

}

variable "min_size" {

}

variable "max_size" {

}

variable "vpc_id" {

}

variable "public_subnets" {

}

variable "private_subnets" {

}

variable "frontend_tg_arns" {

}

variable "backend_tg_arns" {

}

variable "common_tags" {

}

variable "ami_id" {

}

variable "frontend_instance_type" {
  default = "t2.micro"
}

variable "backend_instance_type" {
  default = "t2.micro"
}

variable "key_name" {

}

variable "linux_instance_profile" {

}

variable "frontend_sg" {

}

variable "backend_sg" {

}

variable "internal_backend_dns" {
  
}

variable "frontend_dns" {
  
}

variable "docker_username" {
  
}

variable "docker_password" {
  
}

variable "frontend_image" {
  
}

variable "backend_image" {
  
}

variable "db_image" {
  
}

variable "db_user" {
  
}

variable "db_pass" {
  
}

