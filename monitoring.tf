
# Automatically scale EC2 instances based on CPU usage
resource "aws_autoscaling_policy" "cpu_scaling" {
  name                   = "webpage-cpu-scaling"
  autoscaling_group_name = aws_autoscaling_group.web.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }


    target_value = 50.0
  }
}

# Monitor unhealthy EC2 targets behind the ALB
resource "aws_cloudwatch_metric_alarm" "unhealthy_hosts" {
  alarm_name          = "webpage-unhealthy-hosts"
  alarm_description   = "Detect unhealthy web server targets"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "UnHealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Maximum"
  threshold           = 0
  treat_missing_data  = "notBreaching"

  dimensions = {
    LoadBalancer = aws_lb.web.arn_suffix
    TargetGroup  = aws_lb_target_group.web.arn_suffix
  }
}
