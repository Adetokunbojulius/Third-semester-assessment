

variable "launch_template_name" {
  description = "Prefix name for the launch template"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  # default     = "t3.micro"
}

variable "vpc_security_group_ids" {
  description = "List of security group IDs for the EC2 instances"
  type        = list(string)
}

variable "instance_profile_name" {
  description = "IAM instance profile name for SSM access"
  type        = string
}

variable "user_data_path" {
  description = "Path to user data script"
  type        = string
  # default     = "${path.module}/scripts/web_server_user_data.sh"
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for ASG"
  type        = list(string)
}

variable "target_group_arns" {
  description = "List of ALB target group ARNs"
  type        = list(string)
}

variable "asg_name" {
  description = "Name of the Auto Scaling Group"
  type        = string
}

variable "env" {
  description = "Deployment environment (e.g., dev, staging, prod)"
  type        = string
}
