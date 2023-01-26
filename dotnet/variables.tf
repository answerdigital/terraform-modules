/*
variable "aws_access_key" {
  type        = string
  description = "AWS Access Key"
}

variable "aws_secret_key" {
  type        = string
  description = "AWS Secret Key"
}
*/

variable "aws_region" {
  type        = string
  description = "AWS Region"
  default     = "eu-west-2"
}

variable "project_name" {
  type        = string
  description = "Project Name"
  default     = "answerking-dotnet-api"
}

variable "owner" {
  type        = string
  description = "Resource Owner"
  default     = "answerking-dotnet-team"
}

variable "image_url" {
  type        = string
  description = "AnswerKing C# API image"
  default     = "ghcr.io/answerconsulting/answerking-cs:latest"
}

variable "ec2_type" {
  type        = string
  description = "EC2 Instance Type"
  default     = "t2.micro"
}

variable "aws_cloudwatch_retention_in_days" {
  type        = number
  description = "AWS CloudWatch Logs Retention in Days"
  default     = 1
}