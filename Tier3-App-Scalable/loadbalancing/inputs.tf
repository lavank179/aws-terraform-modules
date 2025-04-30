variable "common_tags" {

}

variable "vpc_id" {

}

variable "public_subnets" {

}

variable "private_subnets" {

}

output "frontend_tg_arns" {
  value = aws_lb_target_group.frontend_tg.arn
}

output "backend_tg_arns" {
  value = aws_lb_target_group.backend_tg.arn
}

output "frontend_sg" {
  value = aws_security_group.frontend_sg.id
}

output "backend_sg" {
  value = aws_security_group.backend_sg.id
}

output "backend_alb_internal_dns" {
  value = aws_lb.backend_alb.dns_name
}

output "frontend_alb_public_dns" {
  value = aws_lb.frontend_alb.dns_name
}