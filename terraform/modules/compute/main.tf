data "aws_ami" "amazon_linux" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_security_group" "app_sg" {
  name        = "app-security-group"
  description = "Allow traffic from load balancer"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_launch_template" "app" {
  name_prefix   = "app-template"
  image_id = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }

  vpc_security_group_ids = [aws_security_group.app_sg.id]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name        = "capstone-instance"
      Project     = "capstone"
      Environment = "dev"
    }
  }

  user_data = base64encode(<<-EOF
#!/bin/bash

yum update -y
curl -fsSL https://rpm.nodesource.com/setup_18.x | bash -
yum install -y nodejs amazon-cloudwatch-agent

# Create app
cat <<EOT > /home/ec2-user/server.js
const http = require("http");

const server = http.createServer((req, res) => {
  if (req.url.startsWith("/health")) {
    res.writeHead(200);
    return res.end("OK");
  }

  if (req.url === "/" || req.url.startsWith("/?")) {
    res.writeHead(200, { "Content-Type": "application/json" });
    return res.end(JSON.stringify({
      instance_id: "metadata-unavailable",
      availability_zone: "metadata-unavailable",
      status: "healthy"
    }, null, 2));
  }

  res.writeHead(404);
  res.end("Not Found");
});

server.listen(3000);
EOT

chown ec2-user:ec2-user /home/ec2-user/server.js
sleep 5

# Start app
sudo -u ec2-user node /home/ec2-user/server.js > /home/ec2-user/app.log 2>&1 &

# Create CloudWatch config
cat <<CWCONFIG > /opt/aws/amazon-cloudwatch-agent/bin/config.json
{
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/home/ec2-user/app.log",
            "log_group_name": "capstone-app-logs",
            "log_stream_name": "{instance_id}",
            "timezone": "UTC"
          }
        ]
      }
    }
  }
}
CWCONFIG

# Start CloudWatch agent
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \\
-a fetch-config \\
-m ec2 \\
-c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json \\
-s

EOF
  )
}

resource "aws_autoscaling_group" "app_asg" {
  desired_capacity = 3
  max_size         = 3
  min_size         = 3

  vpc_zone_identifier = var.private_subnet_ids
  target_group_arns   = [aws_lb_target_group.app_tg.arn]

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "capstone-instance"
    propagate_at_launch = true
  }

  tag {
    key                 = "Project"
    value               = "capstone"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = "dev"
    propagate_at_launch = true
  }
}

resource "aws_security_group" "alb_sg" {
  name        = "alb-security-group"
  description = "Allow HTTP from internet"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "app_alb" {
  name               = "capstone-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = var.public_subnet_ids

  tags = {
    Project     = "capstone"
    Environment = "dev"
    Owner       = "theo"
  }
}

resource "aws_lb_target_group" "app_tg" {
  name     = "app-target-group"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  tags = {
    Project     = "capstone"
    Environment = "dev"
  }

  health_check {
    path                = "/health"
    port                = "traffic-port"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "high-cpu-utilisation"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 70

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.app_asg.name
  }

  alarm_description = "CPU exceeds 70%"
}

resource "aws_cloudwatch_metric_alarm" "unhealthy_hosts" {
  alarm_name          = "unhealthy-hosts"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "UnHealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Average"
  threshold           = 0

  dimensions = {
    TargetGroup  = aws_lb_target_group.app_tg.arn_suffix
    LoadBalancer = aws_lb.app_alb.arn_suffix
  }

  alarm_description = "Instance unhealthy"
}

resource "aws_cloudwatch_metric_alarm" "high_latency" {
  alarm_name          = "high-response-time"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "TargetResponseTime"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Average"
  threshold           = 1

  dimensions = {
    LoadBalancer = aws_lb.app_alb.arn_suffix
  }

  alarm_description = "High latency"
}

resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "capstone-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            ["AWS/EC2", "CPUUtilization", "AutoScalingGroupName", aws_autoscaling_group.app_asg.name]
          ]
          period = 60
          stat   = "Average"
          region = "eu-west-2"
          title  = "EC2 CPU Utilisation"
        }
      }
    ]
  })
} 