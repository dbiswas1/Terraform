# Creates a VPC with Public and Private Subnets
# https://nickcharlton.net/posts/terraform-aws-vpc.html
# https://letslearndevops.com/2017/07/24/how-to-create-a-vpc-with-terraform/
# https://ascisolutions.com/blog/2018/07/05/importing-infrastructure-in-terraform-networking/

provider "aws" {
  region = var.m2go_aws_region.beijing

}

resource "aws_vpc" "m2go-pilot-vpc" {
  cidr_block = "${var.m2go_vpc_cidr}"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = "m2go-pilot-vpc"
  }
}

resource "aws_internet_gateway" "m2go-pilot-igw" {
  vpc_id = "${aws_vpc.m2go-pilot-vpc.id}"
  tags = {
    Name = "m2go-pilot-igw"
  }
}

resource "aws_subnet" "m2go-pilot-cn-north-1a-public" {
  vpc_id = "${aws_vpc.m2go-pilot-vpc.id}"
  cidr_block = "${var.m2go_public_subnet_cidr.az1}"
  map_public_ip_on_launch = true
  availability_zone = "cn-north-1a"
  tags = {
    Name = "m2go-pilot-cn-north-1a-public-subnet"
  }
}

resource "aws_subnet" "m2go-pilot-cn-north-1b-public" {
  vpc_id = "${aws_vpc.m2go-pilot-vpc.id}"
  cidr_block = "${var.m2go_public_subnet_cidr.az2}"
  availability_zone = "cn-north-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "m2go-pilot-cn-north-1b-public-subnet"
  }
}

resource "aws_subnet" "m2go-pilot-cn-north-1a-private" {
  vpc_id = "${aws_vpc.m2go-pilot-vpc.id}"
  cidr_block = "${var.m2go_private_subnet_cidr.az3}"
  availability_zone = "cn-north-1a"
  tags = {
    Name = "m2go-pilot-cn-north-1a-private-subnet"
  }
}

resource "aws_subnet" "m2go-pilot-cn-north-1b-private" {
  vpc_id = "${aws_vpc.m2go-pilot-vpc.id}"
  cidr_block = "${var.m2go_private_subnet_cidr.az4}"
  availability_zone = "cn-north-1b"
  tags = {
    Name = "m2go-pilot-cn-north-1b-private-subnet"
  }
}


resource "aws_route_table" "m2go-pilot-public-route" {
  vpc_id = "${aws_vpc.m2go-pilot-vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.m2go-pilot-igw.id}"
  }
}

resource "aws_route_table_association" "m2go-pilot-public-cn-north-1a" {
  subnet_id = "${aws_subnet.m2go-pilot-cn-north-1a-public.id}"
  route_table_id = "${aws_route_table.m2go-pilot-public-route.id}"
}

resource "aws_route_table_association" "m2go-pilot-public-cn-north-1b" {
  subnet_id = "${aws_subnet.m2go-pilot-cn-north-1b-public.id}"
  route_table_id = "${aws_route_table.m2go-pilot-public-route.id}"
}

resource "aws_eip" "m2go-pilot-nat-eip" {
  vpc = true
}

resource "aws_nat_gateway" "m2go-pilot-nat-gw" {
  allocation_id = "${aws_eip.m2go-pilot-nat-eip.id}"
  subnet_id = "${aws_subnet.m2go-pilot-cn-north-1a-public.id}"
  depends_on = ["aws_internet_gateway.m2go-pilot-igw"]
}

resource "aws_route_table" "m2go-pilot-private-route" {
  vpc_id = "${aws_vpc.m2go-pilot-vpc.id}"
  route  {
      cidr_block = "0.0.0.0/0"
      nat_gateway_id = "${aws_nat_gateway.m2go-pilot-nat-gw.id}"
  }

}

resource "aws_route_table_association" "m2go-pilot-private-cn-north-1a" {
  subnet_id = "${aws_subnet.m2go-pilot-cn-north-1a-private.id}"
  route_table_id = "${aws_route_table.m2go-pilot-private-route.id}"
}

resource "aws_route_table_association" "m2go-pilot-private-cn-north-1b" {
  subnet_id = "${aws_subnet.m2go-pilot-cn-north-1b-private.id}"
  route_table_id = "${aws_route_table.m2go-pilot-private-route.id}"
}