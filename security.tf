
# AWS-managed CloudFront origin IP ranges
data "aws_ec2_managed_prefix_list" "cloudfront" {
  name = "com.amazonaws.global.cloudfront.origin-facing"
}

# Security group for Application Load Balancer
resource "aws_security_group" "alb" {
  name_prefix = "webpage-alb-"
  description = "Allow HTTP traffic to the ALB"
  vpc_id      = aws_vpc.main.id


  ingress {
    description     = "HTTP access from CloudFront only"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    prefix_list_ids = [data.aws_ec2_managed_prefix_list.cloudfront.id]
  }


  egress {
    description = "Outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "webpage-alb-sg"
  }
}

# Security group for EC2 web servers
resource "aws_security_group" "web" {
  name_prefix = "webpage-ec2-"
  description = "Allow HTTP only from ALB"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    description = "Outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "webpage-ec2-sg"
  }
}
