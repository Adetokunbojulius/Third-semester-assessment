output "alb_name" {
#   value = aws_lb.web.dns_name
    value = "http://${aws_lb.web.dns_name}"
}

output "target_group_arn" {
  value = aws_lb_target_group.web_target_group.arn
}
