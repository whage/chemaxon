resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_security_group" "allow_http_and_ssh" {
  name        = "allow_http_and_ssh"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_http_and_ssh"
  }
}

resource "aws_instance" "web" {
  ami = "ami-08c4be469fbdca0fa" # latest ECS-optimized
  instance_type = "t2.micro"
  associate_public_ip_address = true
  vpc_security_group_ids = [
    aws_security_group.allow_http_and_ssh.id
  ]
  key_name = var.key_name

  tags = {
    Name = "chemaxon-exercise"
  }

  user_data = <<EOF
    #!/bin/bash
    docker login --username AWS --password ${var.ecr_password} ${var.ecr_registry}
    docker run --rm -p 80:61023 ${var.ecr_registry}/sallai-chemaxon:1.0.0
EOF
}

output "instance_ip" {
    value = aws_instance.web.public_ip
}
