data "aws_subnet" "pub_sub1" {
  id = var.public_subnets[0]
}

data "aws_subnet" "pub_sub2" {
  id = var.public_subnets[1]
}

data "aws_subnet" "pri_sub1" {
  id = var.private_subnets[0]
}

data "aws_subnet" "pri_sub2" {
  id = var.private_subnets[1]
}

resource "aws_security_group" "frontend_sg" {
  name        = "${var.common_tags.environment}-frontend-sg"
  description = "Allow HTTP and SSH"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [data.aws_subnet.pub_sub1.cidr_block, data.aws_subnet.pub_sub2.cidr_block] # ALB to Frontend
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # ALB to Frontend
    self = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "backend_sg" {
  name        = "${var.common_tags.environment}-backend-sg"
  description = "Allow from frontend only"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.frontend_sg.id] # Only from Frontend
  }

  ingress {
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    self = true
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.frontend_sg.id] # For SSH if needed from frontend
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


