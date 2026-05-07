variable "aws_region" {
  description = "AWS region to deploy resources into."
  type        = string
  default     = "ap-southeast-2"
}

variable "project_name" {
  description = "Project name used for tagging AWS resources."
  type        = string
  default     = "aws-monitoring-incident-response-lab"
}

variable "allowed_ssh_cidr" {
  description = "CIDR block allowed to SSH into the EC2 instance. Use your public IP with /32."
  type        = string
}

variable "alert_email" {
  description = "Email address that will receive CloudWatch alarm notifications via SNS."
  type        = string
}

variable "cpu_alarm_threshold" {
  description = "CPU utilisation percentage that triggers the CloudWatch alarm."
  type        = number
  default     = 70
}