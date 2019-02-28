##################################################
# VPC
# vpc_aws_kata
# 172.100.0.0/16

resource "aws_vpc" "vpc_aws_kata" {
  cidr_block = "172.100.0.0/16"
  enable_dns_hostnames = true
  tags {
    Name = "${var.vpc_name}"
    Project = "${var.project_name}"
  }
}
output aws_vpc.vpc_aws_kata.id {
  value = "${aws_vpc.vpc_aws_kata.id}"
}
