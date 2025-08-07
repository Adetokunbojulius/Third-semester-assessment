output "autoscaling_ec2" {
  value = aws_security_group.autoscaling_ec2.id
}

output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

