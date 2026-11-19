
output "cloudfront_url" {
  description = "Public URL of the webpage"
  value       = "https://${aws_cloudfront_distribution.web.domain_name}"
}

output "load_balancer_dns" {
  description = "Application Load Balancer DNS name"
  value       = aws_lb.web.dns_name
}

output "autoscaling_group_name" {
  description = "EC2 Auto Scaling Group name"
  value       = aws_autoscaling_group.web.name
}
