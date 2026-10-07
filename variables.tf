variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "admin_cidr" {
  description = "CIDR block allowed to SSH into the EC2 instance"
  type        = string
}

variable "ami_id" {
  description = "Ubuntu AMI ID for the EC2 instance"
  type        = string
}
