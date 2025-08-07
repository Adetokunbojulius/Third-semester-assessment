

resource "aws_launch_template" "asg_template" {
  name_prefix   = var.launch_template_name
  image_id      = var.ami_id
  instance_type = var.instance_type


  vpc_security_group_ids = var.vpc_security_group_ids


  user_data = filebase64(var.user_data_path)


  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "${var.asg_name}-instance"
      Env         = var.env
      SSMManaged  = "true"
    }
  }
}



###AUTO-SCALING GROUP###

resource "aws_autoscaling_group" "web_asg" {
  name                      = var.asg_name
  desired_capacity          = 1
  max_size                  = 2
  min_size                  = 1
  vpc_zone_identifier       = var.private_subnet_ids
  target_group_arns         = var.target_group_arns
  health_check_type         = "EC2"
  health_check_grace_period = 60
  launch_template {
    id      = aws_launch_template.asg_template.id
    version = "$Latest"
  }
  

  tag {
    key                 = "Name"
    value               = "${var.asg_name}-ec2"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}


###SCALING POLICY AUTOMATIC###
resource "aws_autoscaling_policy" "target_tracking_cpu" {
  name                   = "${var.asg_name}-target-tracking-cpu"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.web_asg.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value       = 50.0  # Aim to maintain 50% average CPU
    # cooldown           = 60    # Optional: wait time after a scale action
    # disable_scale_in   = false # Allow scale in (true = only scale out)
  }
}
