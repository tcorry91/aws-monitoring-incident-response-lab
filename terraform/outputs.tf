output "aws_account_id" {
  description = "AWS account ID used for this deployment."
  value       = data.aws_caller_identity.current.account_id
}

output "web_server_instance_id" {
  description = "EC2 instance ID for the monitored web server."
  value       = aws_instance.web_server.id
}

output "web_server_public_ip" {
  description = "Public IP address of the EC2 web server."
  value       = aws_instance.web_server.public_ip
}

output "web_server_url" {
  description = "HTTP URL for the deployed web server."
  value       = "http://${aws_instance.web_server.public_ip}"
}

output "sns_topic_arn" {
  description = "SNS topic ARN used for CloudWatch alarm notifications."
  value       = aws_sns_topic.alerts.arn
}

output "cloudwatch_alarm_name" {
  description = "Name of the high CPU CloudWatch alarm."
  value       = aws_cloudwatch_metric_alarm.high_cpu.alarm_name
}