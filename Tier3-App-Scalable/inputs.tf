variable "ami_id" {
 
}

variable "key_name" {
 
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

variable "db_name" {

}

variable "db_port" {

}

variable "docker_username" {

}

variable "docker_password" {

}

variable "ecs_task_execution_role_arn" {
  
}

output "website_url" {
  value = module.load-balancer.backend_alb_internal_dns
}