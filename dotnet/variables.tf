variable "aws_region" {
  default = "eu-west-2"
}

variable "image_url" {
  default = "ghcr.io/bethcryer/answerking-cs-beth:refs-heads-develop"
  #default = "ghcr.io/AnswerConsulting/AnswerKing-CS:latest"
}

variable "project_name" {
  default = "ak-dotnet-api"
}

variable "owner" {
  default = "ak-dotnet-team"
}