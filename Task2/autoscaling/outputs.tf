output "asg_name" {
  value = aws_autoscaling_group.web_asg.name
}

output "launch_template_id" {
  value = aws_launch_template.asg_template.id
}

output "target_tracking_policy_name" {
  value = aws_autoscaling_policy.target_tracking_cpu.name
}

# output "user_data" {
#   value = 
# }