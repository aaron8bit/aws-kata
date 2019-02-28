##################################################
# Public subnets

resource "aws_subnet" "subnet_public1" {
  vpc_id = "${aws_vpc.vpc_aws_kata.id}"
  cidr_block = "172.100.1.0/24"
  availability_zone = "${var.vpc_az1}"
  tags {
    Name = "${var.vpc_name}-subnet-public1"
  }
}

resource "aws_subnet" "subnet_public2" {
  vpc_id = "${aws_vpc.vpc_aws_kata.id}"
  cidr_block = "172.100.2.0/24"
  availability_zone = "${var.vpc_az2}"
  tags {
    Name = "${var.vpc_name}-subnet-public2"
  }
}

