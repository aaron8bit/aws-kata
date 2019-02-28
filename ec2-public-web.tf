##################################################
# Basic EC2 instance, security groups

resource "aws_instance" "web" {
  ami = "${var.aws_ubuntu18_ami}"
  instance_type = "t2.micro"
  key_name = "${var.aws_key_name}"
  vpc_security_group_ids = ["${aws_security_group.web_ec2_sg.id}"]
  subnet_id = "${aws_subnet.subnet_public1.id}"
  associate_public_ip_address = true
  tags {
    Name = "${var.vpc_name}-web"
  }
  user_data = "${file("ec2-user-data-ubuntu-web.sh")}"
}

resource "aws_eip" "web_eip" {
  instance = "${aws_instance.web.id}"
  vpc      = true
}

resource "aws_security_group" "web_ec2_sg" {
  name = "${var.vpc_name}-web-ec2-sg"
  description = "Allow inbound SSH traffic from Internet"
  tags {
    Name = "${var.vpc_name}-web-ec2-sg"
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id = "${aws_vpc.vpc_aws_kata.id}"
}

output aws_eip.web_eip.public_ip {
  value = "${aws_eip.web_eip.public_ip}"
}
output aws_eip.web_eip.private_ip {
  value = "${aws_eip.web_eip.private_ip}"
}

output aws_instance.web.public_ip {
  value = "${aws_instance.web.public_ip}"
}
output aws_instance.web.private_ip {
  value = "${aws_instance.web.private_ip}"
}

output ssh_command {
  value = "ssh -i ~/.ssh/${var.aws_key_name}.pem ubuntu@${aws_eip.web_eip.public_ip}"
}
