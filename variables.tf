# Required AWS settings expected in environment
# AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_DEFAULT_REGION

# Override default region to force match with AZs
provider "aws" {
  region     = "us-west-2"
}

variable "project_name" {
  default = "aws_kata"
}

variable "vpc_name" {
  default = "vpc_aws_kata"
}

variable "vpc_az1" {
  default = "us-west-2a"
}

variable "vpc_az2" {
  default = "us-west-2b"
}

variable "aws_key_name" {
  default = "aws_kata_key"
}

variable "aws_ubuntu18_ami" {
  # us-east-2, updated 20190218
  #default = "ami-0f65671a86f061fcd"
  # us-west-2, updated 20190227
  default = "ami-0bbe6b35405ecebdb"
}

output var.aws_ubuntu18_ami {
  value = "${var.aws_ubuntu18_ami}"
}

