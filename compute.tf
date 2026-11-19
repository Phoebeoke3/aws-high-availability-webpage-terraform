
# Latest Amazon Linux 2023 AMI
data "aws_ssm_parameter" "amazon_linux" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

# EC2 Launch Template
resource "aws_launch_template" "web" {
  name_prefix   = "webpage-launch-"
  image_id      = data.aws_ssm_parameter.amazon_linux.value
  instance_type = "t3.micro"

  vpc_security_group_ids = [
    aws_security_group.web.id
  ]

  user_data = filebase64("${path.module}/webserver.sh")

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size           = 8
      volume_type           = "gp3"
      encrypted             = true
      delete_on_termination = true
    }
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "webpage-ec2"
    }
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "web" {
  name             = "webpage-autoscaling"
  min_size         = 2
  max_size         = 3
  desired_capacity = 2
  vpc_zone_identifier = [
    aws_subnet.private_a.id,
    aws_subnet.private_b.id
  ]

  target_group_arns = [
    aws_lb_target_group.web.arn
  ]

  health_check_type         = "ELB"
  health_check_grace_period = 180

  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "webpage-autoscaling-instance"
    propagate_at_launch = true
  }
}
