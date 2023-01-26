# VPC Subnet module

module "vpc_subnet" {
  source = "../Terraform_modules/vpc_subnets"

  project_name        = var.project_name
  owner               = var.owner
  num_public_subnets  = 2
  num_private_subnets = 0
}

# Security Group: Defines network traffic rules

resource "aws_security_group" "ecs_sg" {
  name        = "${var.project_name}-ecs-sg"
  description = "Security group for ec2-sg"
  vpc_id       = module.vpc_subnet.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "${var.project_name}-ecs-sg"
    Owner = var.owner
  }
}

#ECS Cluster

data "aws_iam_policy_document" "ecs_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_task_role" {
  name               = "${var.project_name}-ecs-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_role_policy.json

  tags = {
    Name = "${var.project_name}-ecs-task-role"
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task_role_policy" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs_instance_profile" {
  name = "${var.project_name}-iam-instance-profile"
  role = aws_iam_role.ecs_task_role.name
}

# CloudWatch

resource "aws_cloudwatch_log_group" "log_group" {
  name              = "${var.project_name}-logs"
  retention_in_days = var.aws_cloudwatch_retention_in_days
  
  # keep log files when terraform destroy runs
  #skip_destroy      = true

  tags = {
    Name = "${var.project_name}-logs"
  }
}

# AMI: Provides image info for Amazon Linux 2

data "aws_ami" "ecs_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }
}

# Autoscaling group

resource "aws_launch_configuration" "ecs_launch_config" {
    image_id             = data.aws_ami.ecs_ami.id
    iam_instance_profile = aws_iam_instance_profile.ecs_instance_profile.name
    security_groups      = [aws_security_group.ecs_sg.id]
    user_data            = "#!/bin/bash\necho ECS_CLUSTER=${var.project_name}-ecs_cluster >> /etc/ecs/ecs.config"
    instance_type        = var.ec2_type
}

resource "aws_autoscaling_group" "failure_analysis_ecs_asg" {
    name                      = "${var.project_name}-auto-scaling-group"
    vpc_zone_identifier       = [module.vpc_subnet.public_subnet_ids[0]]
    launch_configuration      = aws_launch_configuration.ecs_launch_config.name

    desired_capacity          = 2
    min_size                  = 1
    max_size                  = 5
    health_check_grace_period = 300
    health_check_type         = "EC2"
}

resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.project_name}-ecs_cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name = "${var.project_name}-ecs-cluster"
  }
}

/*
data "template_file" "env_vars" {
  template = file("env_vars.json")
}

"environment": ${data.template_file.env_vars.rendered},
*/

resource "aws_ecs_task_definition" "aws_ecs_task" {
  family = "${var.project_name}-task"

  container_definitions = <<DEFINITION
  [
    {
      "name": "${var.project_name}-container",
      "image": "${var.image_url}",
      "entryPoint": [],
      
      "essential": true,
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${aws_cloudwatch_log_group.log_group.id}",
          "awslogs-region": "${var.aws_region}",
          "awslogs-stream-prefix": "${var.project_name}"
        }
      },
      "portMappings": [
        {
          "containerPort": 80,
          "hostPort": 80
        },
        {
          "containerPort": 443,
          "hostPort": 443
        }
      ],
      "cpu": 256,
      "memory": 512,
      "networkMode": "awsvpc"
    }
  ]
  DEFINITION

  requires_compatibilities = ["FARGATE", "EC2"]
  network_mode             = "awsvpc"
  memory                   = "512"
  cpu                      = "256"
  execution_role_arn       = aws_iam_role.ecs_task_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  tags = {
    Name = "${var.project_name}-ecs-task"
  }
}

data "aws_ecs_task_definition" "main" {
  task_definition = aws_ecs_task_definition.aws_ecs_task.family
}

resource "aws_ecs_service" "aws_ecs_service" {
  name                 = "${var.project_name}-ecs-service"
  cluster              = aws_ecs_cluster.ecs_cluster.id
  task_definition      = "${aws_ecs_task_definition.aws_ecs_task.family}:${max(aws_ecs_task_definition.aws_ecs_task.revision, data.aws_ecs_task_definition.main.revision)}"
  launch_type          = "FARGATE"
  scheduling_strategy  = "REPLICA"
  platform_version     = "LATEST"
  desired_count        = 1
  force_new_deployment = true

  network_configuration {
    subnets          = module.vpc_subnet.public_subnet_ids
    assign_public_ip = true
    security_groups = [
      aws_security_group.ecs_sg.id
    ]
  }
}

/*
resource "aws_security_group" "service_security_group" {
  vpc_id = module.vpc_subnet.vpc_id

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.ecs_sg.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.project_name}-service-sg"
  }
}



resource "aws_alb" "application_load_balancer" {
  name               = "${var.project_name}-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = module.vpc_subnet.public_subnet_ids
  security_groups    = [aws_security_group.load_balancer_security_group.id]

  tags = {
    Name = "${var.project_name}-alb"
  }
}

resource "aws_security_group" "load_balancer_security_group" {
  vpc_id = module.vpc_subnet.vpc_id

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.project_name}-sg"
  }
}

resource "aws_lb_target_group" "target_group" {
  name        = "${var.project_name}-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = module.vpc_subnet.vpc_id

  health_check {
    healthy_threshold   = "3"
    interval            = "300"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/v1/status"
    unhealthy_threshold = "2"
  }

  tags = {
    Name = "${var.project_name}-lb-tg"
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_alb.application_load_balancer.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.id
  }
}

*/