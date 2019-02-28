##################################################
# Routing table for public subnets

resource "aws_route_table" "public_routes" {
  vpc_id = "${aws_vpc.vpc_aws_kata.id}"
  tags { Name = "${var.vpc_name}-public-routes" }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.vpc_aws_kata_igw.id}"
  }
}

resource "aws_route_table_association" "public1" {
  subnet_id = "${aws_subnet.subnet_public1.id}"
  route_table_id = "${aws_route_table.public_routes.id}"
}

resource "aws_route_table_association" "public2" {
  subnet_id = "${aws_subnet.subnet_public2.id}"
  route_table_id = "${aws_route_table.public_routes.id}"
}

