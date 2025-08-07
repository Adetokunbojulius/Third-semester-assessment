###ALB SG VARIAVLES###

variable "prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the security group will be created"
  type        = string
}

variable "env" {
  description = "Environment for the resources (e.g., dev, staging, prod)"
  type        = string
}

