output "TG_ARN" {
  value = aws_lb_target_group.alb_target_group.arn
}

output "ALB_DNS_NAME" {
  value = aws_lb.application_load_balancer.dns_name
}