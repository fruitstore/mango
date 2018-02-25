resource "aws_vpc" "grape_demo" {
  cidr_block = "172.16.0.0/16"
  enable_dns_hostnames  = true
}

resource "aws_subnet" "grape_demo_a" {
  vpc_id     = "${aws_vpc.grape_demo.id}"
  cidr_block = "172.16.16.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "grape_demo_b" {
  vpc_id     = "${aws_vpc.grape_demo.id}"
  cidr_block = "172.16.18.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true
}

resource "aws_security_group" "grape_demo_ec2" {
  name        = "grape_demo"
  description = "Allow ssh and grpc and http"
  vpc_id      = "${aws_vpc.grape_demo.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 50051
    to_port     = 50051
    protocol    = "tcp"
    security_groups = ["${aws_security_group.grape_demo_lambda.id}"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "grape_demo_lambda" {
  name        = "grape_demo_lambda"
  description = "Only egress"
  vpc_id      = "${aws_vpc.grape_demo.id}"

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}