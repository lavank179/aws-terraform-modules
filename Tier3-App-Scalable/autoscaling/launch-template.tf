resource "aws_launch_template" "frontend_lt" {
  image_id      = var.ami_id
  instance_type = var.frontend_instance_type
  key_name      = var.key_name

  iam_instance_profile {
    name = var.linux_instance_profile
  }

  network_interfaces {
    associate_public_ip_address = true
    delete_on_termination       = true
    security_groups             = [var.frontend_sg]
  }

  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_type           = "gp3"
      delete_on_termination = true
    }
  }

  tag_specifications {
    resource_type = "instance"

    tags = merge({ Name = "${var.common_tags.environment}-frontend" }, var.common_tags)
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash
    sudo apt update -y
    sudo apt install docker.io -y
    sudo apt install unzip
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
    # aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin 180294188976.dkr.ecr.us-west-2.amazonaws.com

    DOCKER_USER=$(aws ssm get-parameter --name "/${var.common_tags.environment}/docker_username" --region ${var.common_tags.region} --query "Parameter.Value" --output text)
    DOCKER_PASS=$(aws ssm get-parameter --name "/${var.common_tags.environment}/docker_password" --region ${var.common_tags.region} --query "Parameter.Value" --output text)
    echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
    if [ $? -eq 0 ]; then
      echo "Successfully logged in to Docker Hub."
    else
      echo "Failed to log in to Docker Hub."
      exit 1
    fi

    docker run --rm -d -e API_URL=${var.internal_backend_dns}:3000 -p 80:80 ${var.frontend_image}
  EOF
  )
}

resource "aws_launch_template" "backend_lt" {
  image_id      = var.ami_id
  instance_type = var.backend_instance_type
  key_name      = var.key_name

  iam_instance_profile {
    name = var.linux_instance_profile
  }

  network_interfaces {
    associate_public_ip_address = true
    delete_on_termination       = true
    security_groups             = [var.backend_sg]
  }
  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_type           = "gp3"
      delete_on_termination = true
    }
  }

  tag_specifications {
    resource_type = "instance"

    tags = merge({ Name = "${var.common_tags.environment}-backend" }, var.common_tags)
  }
  depends_on = [ aws_instance.db_server ]

  user_data = base64encode(<<-EOF
    #!/bin/bash
    sudo apt update -y
    sudo apt install docker.io -y
    sudo apt install unzip
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
    # aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin 180294188976.dkr.ecr.us-west-2.amazonaws.com

    DOCKER_USER=$(aws ssm get-parameter --name "/${var.common_tags.environment}/docker_username" --region ${var.common_tags.region} --query "Parameter.Value" --output text)
    DOCKER_PASS=$(aws ssm get-parameter --name "/${var.common_tags.environment}/docker_password" --region ${var.common_tags.region} --query "Parameter.Value" --output text)
    echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
    if [ $? -eq 0 ]; then
      echo "Successfully logged in to Docker Hub."
    else
      echo "Failed to log in to Docker Hub."
      exit 1
    fi
    DB_IP=$(aws ssm get-parameter --name "/${var.common_tags.environment}/db_private_ip" --region ${var.common_tags.region} --query "Parameter.Value" --output text)
    DB_USER=$(aws ssm get-parameter --name "/${var.common_tags.environment}/db_user" --region ${var.common_tags.region} --query "Parameter.Value" --output text)
    DB_PASSWORD=$(aws ssm get-parameter --name "/${var.common_tags.environment}/db_password" --region ${var.common_tags.region} --query "Parameter.Value" --output text)


    docker run --rm -d -e DB_HOST=$DB_IP -e FRONTEND_URL=${var.frontend_dns} -e PORT=3000 -e DB_USER=$DB_USER -e DB_PASSWORD=$DB_PASSWORD -e DB_NAME=postgres -e DB_PORT=5432 -p 3000:3000 ${var.backend_image}
  EOF
  )
}
