# resource "aws_security_group" "public_sg" {
#   name        = "${var.vpc_name}-public-sg"
#   description = "Allow SSH and HTTP from the internet"
#   vpc_id      = var.no-vpc == true ? var.existing_vpc_id : aws_vpc.aws_vpc.id

#   ingress {
#     description = "Allow SSH"
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = [""]
#   }

#   ingress {
#     description = "Allow HTTP"
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = [""]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = var.common_tags
# }

# # resource "aws_security_group" "private_sg" {
# #   name        = "${var.vpc_name}-private-sg"
# #   description = "Allow access only from public subnet EC2s"
# #   vpc_id      = var.no-vpc == true ? var.existing_vpc_id : aws_vpc.aws_vpc.id

# #   ingress {
# #     description     = "Allow SSH from public subnet"
# #     from_port       = 22
# #     to_port         = 22
# #     protocol        = "tcp"
# #     security_groups = [aws_security_group.public_sg.id]
# #   }

# #   ingress {
# #     description     = "Allow HTTP from public subnet"
# #     from_port       = 80
# #     to_port         = 80
# #     protocol        = "tcp"
# #     security_groups = [aws_security_group.public_sg.id]
# #   }

# #   egress {
# #     from_port   = 0
# #     to_port     = 0
# #     protocol    = "-1"
# #     cidr_blocks = ["0.0.0.0/0"]
# #   }

# #   tags = var.common_tags
# # }



# # resource "aws_security_group" "allow_all" {
# #   name        = "${var.vpc_name}-SG"
# #   description = "Allow all inbound traffic"
# #   vpc_id      = var.no-vpc == true ? var.existing_vpc_id : aws_vpc.aws_vpc.id

# #   dynamic "ingress" {
# #     for_each = var.ingress_service
# #     content {
# #       from_port   = ingress.value
# #       to_port     = ingress.value
# #       protocol    = "-1"
# #       cidr_blocks = ["0.0.0.0/0"]
# #     }
# #   }

# #   egress {
# #     from_port   = 0
# #     to_port     = 0
# #     protocol    = "-1"
# #     cidr_blocks = ["0.0.0.0/0"]
# #   }

# #   tags = var.common_tags
# # }