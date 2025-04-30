# module "vpc-module" {
#   source          = "./vpc"
#   vpc_name        = "Tier3-App-lavan"
#   existing_vpc_id = "vpc-35633852"
#   no-vpc          = true
#   public_cidr_block = ["172.31.7.0/28"]
#   private_cidr_block = ["172.31.8.0/28"]
#   common_tags = {
#     environment = "tier3-app-lavan"
#   }
# }

module "vpc-module" {
  source          = "./vpc"
  vpc_name        = "lavan-test"
  vpc_cidr_block = "172.31.0.0/16"
  no-vpc          = false
  public_cidr_block = ["172.31.7.0/28", "172.31.8.0/28"]
  private_cidr_block = ["172.31.9.0/28", "172.31.10.0/28"]
  enable_nat_gate = false
  common_tags = {
    environment = "lavan-test"
  }
}

module "load-balancer" {
  source = "./loadbalancing"
  vpc_id = module.vpc-module.custom_vpc.id
  public_subnets = module.vpc-module.public_subs
  private_subnets = module.vpc-module.private_subs
  common_tags = {
    environment = "lavan-test"
  }
  depends_on = [ module.vpc-module.public_subs, module.vpc-module.private_subs ]
}

module "asg" {
  source = "./autoscaling"
  vpc_id = module.vpc-module.custom_vpc.id
  public_subnets = module.vpc-module.public_subs
  private_subnets = module.vpc-module.private_subs
  desired_size = 1
  min_size = 1
  max_size = 2
  ami_id = var.ami_id
  key_name = var.key_name
  linux_instance_profile = aws_iam_instance_profile.ec2_ecr_profile.name
  frontend_sg = module.load-balancer.frontend_sg
  backend_sg = module.load-balancer.backend_sg
  frontend_tg_arns = [module.load-balancer.frontend_tg_arns]
  backend_tg_arns = [module.load-balancer.backend_tg_arns]
  internal_backend_dns = module.load-balancer.backend_alb_internal_dns
  frontend_dns = module.load-balancer.frontend_alb_public_dns
  frontend_image = var.frontend_image
  backend_image = var.backend_image
  db_image = var.db_image
  db_user = var.db_user
  db_pass = var.db_pass
  docker_username = var.docker_username
  docker_password = var.docker_password
  common_tags = {
    environment = "lavan-test"
  }

  depends_on = [ module.load-balancer.frontend_tg_arns, module.load-balancer.backend_tg_arns ]
}

resource "aws_iam_instance_profile" "ec2_ecr_profile" {
  name = "lavan-test-profile"
  role = aws_iam_role.ec2_ecr_role.name
}

resource "aws_iam_role" "ec2_ecr_role" {
  name = "lavan-test"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_ecr_attachment" {
  role       = aws_iam_role.ec2_ecr_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}