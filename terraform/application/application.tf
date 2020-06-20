resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    description = "HTTP from anywhere"
    from_port   = 0
    to_port     = 0
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
    Name = "allow_http"
  }
}

resource "aws_instance" "web" {
  ami           = "ami-08c4be469fbdca0fa" # latest ECS-optimized
  instance_type = "t2.micro"
  associate_public_ip_address = true
  vpc_security_group_ids = [
    aws_security_group.allow_http.id
  ]
  key_name = "sallai"

  tags = {
    Name = "chemaxon-exercise"
  }

  # TODO: use variable for docker image
  user_data = <<EOF
    #!/bin/bash
    docker run --rm -p 80:61023 583709312004.dkr.ecr.eu-central-1.amazonaws.com/chemaxon:1.0.0
EOF
}

output "instance_ip" {
    value = aws_instance.web.public_ip
}


/*resource "aws_iam_role" "ecs_service_role" {
    name = "flask-ecs-service-role"
    path = "/"
    assume_role_policy = "${data.aws_iam_policy_document.ecs_service_policy.json}"
}

resource "aws_iam_role_policy_attachment" "ecs_service_role_policy_attachment" {
    role = "${aws_iam_role.ecs_service_role.name}"
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

data "aws_iam_policy_document" "ecs_service_policy" {
    statement {
        actions = ["sts:AssumeRole"]

        principals {
            type = "Service"
            identifiers = ["ecs.amazonaws.com"]
        }
    }
}

resource "aws_iam_role" "ecs_instance_role" {
    name = "flask_ecs_instance_role"
    path = "/"
    assume_role_policy = "${data.aws_iam_policy_document.ecs_instance_policy.json}"
}

resource "aws_iam_role_policy_attachment" "ecs_instance_role_policy_attachment" {
    role = "${aws_iam_role.ecs_instance_role.name}"
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

data "aws_iam_policy_document" "ecs_instance_policy" {
    statement {
        actions = ["sts:AssumeRole"]

        principals {
            type = "Service"
            identifiers = ["ec2.amazonaws.com"]
        }
    }
}

resource "aws_iam_instance_profile" "flask_instance_profile" {
    name = "flask-instance-profile"
    role = "${aws_iam_role.ecs_instance_role.name}"
}


resource "aws_autoscaling_group" "asg" {
    name = "flask-webapp-asg"
    min_size = 1
    max_size = 2
    launch_configuration = "${aws_launch_configuration.lc.name}"
    vpc_zone_identifier = [
        "${aws_subnet.priv_subnet_a.id}",
        "${aws_subnet.priv_subnet_b.id}",
    ]

    tag {
        key = "Name"
        value = "flask-webapp-asg"
        propagate_at_launch = true
    }
}

resource "aws_launch_configuration" "lc" {
    name = "flask-webapp-lc"
    image_id = "ami-0650e7d86452db33b" # amzn2-ami-ecs-hvm-2.0.20190709-x86_64-ebs
    instance_type = "t2.medium"
    key_name = "sallai-key"
    iam_instance_profile = "${aws_iam_instance_profile.flask_instance_profile.id}"
    security_groups = [
        "${aws_security_group.ecs_sg.id}"
    ]
    user_data = <<EOF
        #!/bin/bash
        mkdir /etc/ecs
        echo ECS_CLUSTER=${aws_ecs_cluster.cluster.name} >> /etc/ecs/ecs.config
EOF
}

resource "aws_ecs_cluster" "cluster" {
    name = "flask-webapp-cluster"
}

resource "aws_ecs_service" "service" {
    name = "flask-webapp-service"
    cluster = "${aws_ecs_cluster.cluster.id}"
    task_definition = "${aws_ecs_task_definition.flask_webapp_task_def.arn}"
    desired_count = 3
    iam_role = "${aws_iam_role.ecs_service_role.name}"

    depends_on = [
        "aws_lb_listener.listener"
    ]

    load_balancer {
        target_group_arn = "${aws_lb_target_group.lb_tg.arn}"
        container_name = "flask-webapp"
        container_port = 5000
    }
}

resource "aws_ecs_task_definition" "flask_webapp_task_def" {
    family = "flask-webapp"
    container_definitions = <<EOF
    [
        {
            "name": "flask-webapp",
            "image": "464255417364.dkr.ecr.eu-central-1.amazonaws.com/sallai-test:0.0.1",
            "memory": 512,
            "cpu": 1,
            "essential": true,
            "portMappings": [
                {
                    "containerPort": 5000,
                    "hostPort": 0
                }
            ]
        }
    ]
EOF
}
*/
