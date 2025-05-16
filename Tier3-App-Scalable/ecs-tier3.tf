data "aws_region" "current" {}

# module "vpc-module" {
#   source          = "./vpc"
#   vpc_name        = "lavan-test"
#   vpc_cidr_block = "172.31.0.0/16"
#   no-vpc          = false
#   public_cidr_block = ["172.31.7.0/28", "172.31.8.0/28"]
#   private_cidr_block = ["172.31.9.0/28", "172.31.10.0/28"]
#   enable_nat_gate = false
#   common_tags = {
#     environment = "lavan-test"
#     region = data.aws_region.current.name
#   }
# }

module "load-balancer" {
  source          = "./loadbalancing"
  vpc_id          = ""
  public_subnets  = ["", ""]
  private_subnets = ["", ""]
  common_tags = {
    environment = "lavan-test"
    region      = data.aws_region.current.name
  }
  # depends_on = [ module.vpc-module.public_subs, module.vpc-module.private_subs ]
}

module "ecs" {
  source                = "./ecs"
  vpc_id                = ""
  private_subnets       = ["", ""]
  backend_instance_type = "t2.micro"
  ami_id                = var.ami_id
  desired_count         = 1
  key_name              = var.key_name
  frontend_sg           = module.load-balancer.frontend_sg
  backend_sg            = module.load-balancer.backend_sg
  frontend_tg_arn       = module.load-balancer.frontend_tg_arns
  backend_tg_arn        = module.load-balancer.backend_tg_arns
  internal_backend_dns  = module.load-balancer.backend_alb_internal_dns
  frontend_dns          = module.load-balancer.frontend_alb_public_dns
  taskRoleArn           = var.ecs_task_execution_role_arn
  executionRoleArn      = var.ecs_task_execution_role_arn
  frontend_image        = var.frontend_image
  backend_image         = var.backend_image
  db_image              = var.db_image
  db_user               = var.db_user
  db_password           = var.db_pass
  db_name               = var.db_name
  db_port               = var.db_port
  frontend_app_port     = 80
  backend_app_port      = 3000
  conatiner_cpu         = "256"
  container_memory      = "512"
  aws_region            = data.aws_region.current.name
  common_tags = {
    environment = "lavan-test"
    region      = data.aws_region.current.name
  }

  depends_on = [module.load-balancer.frontend_tg_arns, module.load-balancer.backend_tg_arns]
}

# resource "aws_iam_instance_profile" "ec2_ecr_profile" {
#   name = "lavan-test-profile"
#   role = aws_iam_role.ec2_ecr_ssm_role.name
# }

# resource "aws_iam_role" "ec2_ecr_ssm_role" {
#   name = "lavan-test"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Principal = {
#           Service = "ec2.amazonaws.com"
#         }
#         Action = "sts:AssumeRole"
#       }
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "ec2_ecr_attachment" {
#   role       = aws_iam_role.ec2_ecr_ssm_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
# }

# resource "aws_iam_role_policy_attachment" "ssm_access" {
#   role       = aws_iam_role.ec2_ecr_ssm_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
# }
