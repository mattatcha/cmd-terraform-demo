variable "aws_region" {
  default = "us-east-1"
}

variable "cluster" {}

variable "app" {}

variable "subnets" {
  type = "list"
}

variable "vpc" {}
