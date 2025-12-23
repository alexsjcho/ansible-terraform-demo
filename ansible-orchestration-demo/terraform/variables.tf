# Variables for AWS Infrastructure

variable "aws_access_key_id" {
  description = "AWS Access Key ID (can also be set via AWS_ACCESS_KEY_ID env var)"
  type        = string
  sensitive   = true
  default     = null
}

variable "aws_secret_access_key" {
  description = "AWS Secret Access Key (can also be set via AWS_SECRET_ACCESS_KEY env var)"
  type        = string
  sensitive   = true
  default     = null
}

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-2"
}

variable "aws_application_arn" {
  description = "AWS Resource Group Application ARN for tagging resources"
  type        = string
  default     = "arn:aws:resource-groups:us-east-2:579320645987:group/ansible-demo/03si1j8ufh829fyd3wdhgx33vy"
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "ansible-demo"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "web_server_count" {
  description = "Number of web server instances"
  type        = number
  default     = 2
}

variable "key_pair_name" {
  description = "Name of AWS EC2 Key Pair for SSH access (will be created automatically)"
  type        = string
  default     = "ansible-demo-key"
}

variable "ssh_cidr" {
  description = "CIDR block allowed for SSH access"
  type        = string
  default     = "0.0.0.0/0" # Change this to your IP for security
}

variable "ansible_ssh_key_path" {
  description = "Path to SSH private key for Ansible (optional, defaults to ~/.ssh/{key_pair_name}.pem)"
  type        = string
  default     = ""
}

