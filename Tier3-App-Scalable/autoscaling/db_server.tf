resource "aws_instance" "db_server" {
  ami                         = var.ami_id
  instance_type               = var.backend_instance_type
  key_name                    = var.key_name
  subnet_id                   = var.private_subnets[0].id
  vpc_security_group_ids      = [aws_security_group.db_sg.id]
  associate_public_ip_address = true
  iam_instance_profile = var.linux_instance_profile

  tags = merge({ Name = "${var.common_tags.environment}-db" }, var.common_tags)

  user_data = <<-EOF
    #!/bin/bash
    sudo apt update -y
    sudo apt install docker.io -y
    sudo apt install unzip
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
    # aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin 180294188976.dkr.ecr.us-west-2.amazonaws.com
    
    echo "${var.docker_password}" | docker login -u "${var.docker_username}" --password-stdin
    if [ $? -eq 0 ]; then
      echo "Successfully logged in to Docker Hub."
    else
      echo "Failed to log in to Docker Hub."
      exit 1
    fi
    docker run --rm -d -e POSTGRES_PASSWORD=${var.db_pass} -p 5432:5432 ${var.db_image}
  EOF
}

resource "aws_security_group" "db_sg" {
  name        = "${var.common_tags.environment}-db-sg"
  description = "Allow backend only"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.backend_sg]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [var.frontend_sg] # For SSH if needed from frontend
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}