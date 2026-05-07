# AWS Monitoring & Incident Response Lab

## Overview

This project demonstrates a small AWS monitoring and incident response workflow using EC2, CloudWatch, SNS, and Terraform.

The goal is to simulate a basic cloud operations scenario: deploy a simple web server, monitor its health and CPU usage, trigger an alarm, receive a notification, and follow a documented incident response runbook.

## Why This Project Exists

Cloud support and cloud operations roles require more than deploying infrastructure. They require the ability to monitor systems, respond to alerts, investigate incidents, document findings, and improve reliability.

This lab is designed to demonstrate practical operational thinking around:

- AWS infrastructure
- monitoring and alerting
- incident response
- documentation
- runbooks
- basic troubleshooting
- infrastructure as code

## Architecture

The lab provisions:

- An EC2 instance running a simple web server
- A security group allowing HTTP and SSH access
- CloudWatch metrics for instance monitoring
- A CloudWatch alarm for high CPU usage
- An SNS topic for email notifications
- A documented incident response runbook

Architecture diagram to be added in `/architecture`.

## AWS Services Used

- EC2
- CloudWatch
- SNS
- IAM
- VPC / Security Groups
- Terraform

## Repository Structure

```text
aws-monitoring-incident-response-lab/
  README.md
  architecture/
  screenshots/
  runbooks/
    high-cpu-alarm-response.md
  terraform/
    versions.tf
    provider.tf
    variables.tf
    main.tf
    outputs.tf
    terraform.tfvars.example
