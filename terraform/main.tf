data "aws_caller_identity" "current" {}

data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "web_server" {
  name        = "${var.project_name}-web-sg"
  description = "Allow HTTP and SSH access for monitoring lab"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH from allowed IP only"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${var.project_name}-web-sg"
    Project = var.project_name
  }
}

resource "aws_iam_role" "ssm_role" {
  name = "${var.project_name}-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name    = "${var.project_name}-ssm-role"
    Project = var.project_name
  }
}

resource "aws_iam_role_policy_attachment" "ssm_managed_instance_core" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_instance_profile" {
  name = "${var.project_name}-ssm-instance-profile"
  role = aws_iam_role.ssm_role.name
}

resource "aws_instance" "web_server" {
  ami                         = data.aws_ami.amazon_linux_2023.id
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.web_server.id]
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.ssm_instance_profile.name

  user_data = <<-EOF
              #!/bin/bash

              dnf update -y

              # Install web server and stress testing tool
              dnf install -y httpd stress-ng

              # Start web server
              systemctl enable httpd
              systemctl start httpd

              cat > /var/www/html/index.html <<HTML
              <!DOCTYPE html>
              <html>
              <head>
                <title>AWS Monitoring Lab</title>
              </head>
              <body>
                <h1>AWS Monitoring & Incident Response Lab</h1>
                <p>Web server is running.</p>
                <p>This instance is monitored by CloudWatch.</p>
              </body>
              </html>
              HTML

              # Start SSM Agent if available on the AMI
              systemctl enable amazon-ssm-agent || true
              systemctl start amazon-ssm-agent || true

              # Simulate a high CPU incident after boot
              sleep 120
              nohup stress-ng --cpu 2 --timeout 1200s --metrics-brief > /var/log/stress-ng.log 2>&1 &
              EOF

  tags = {
    Name    = "${var.project_name}-web-server"
    Project = var.project_name
  }
}

resource "aws_sns_topic" "alerts" {
  name = "${var.project_name}-alerts"

  tags = {
    Name    = "${var.project_name}-alerts"
    Project = var.project_name
  }
}

resource "aws_sns_topic_subscription" "email_alert" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "${var.project_name}-high-cpu"
  alarm_description   = "Triggers when EC2 CPU utilisation exceeds the configured threshold."
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  datapoints_to_alarm = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 50
  treat_missing_data  = "notBreaching"

  dimensions = {
    InstanceId = aws_instance.web_server.id
  }

  alarm_actions = [aws_sns_topic.alerts.arn]
  ok_actions    = [aws_sns_topic.alerts.arn]

  tags = {
    Name    = "${var.project_name}-high-cpu"
    Project = var.project_name
  }
}