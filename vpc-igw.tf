##################################################
# Internet gateway

resource "aws_internet_gateway" "vpc_aws_kata_igw" {
  vpc_id = "${aws_vpc.vpc_aws_kata.id}"
  tags {
    Name = "${var.vpc_name}-igw"
  }
}
