resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "${var.env}_vpc"
    Env  = var.env
  }
}

resource "aws_subnet" "public_subnet" {
  cidr_block              = var.public_subnet
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = "true"
  availability_zone       = var.az

  tags = {
    Name = "${var.env}_subnet_public"
    Env  = var.env
  }
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.env}_igw"
    Env  = var.env
  }
}
resource "aws_default_route_table" "default_route_table" {
  default_route_table_id = aws_vpc.vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_subnet" "private_subnet" {
  cidr_block              = var.public_subnet
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = "false"
  availability_zone       = var.az

  tags = {
    Name = "${var.env}_subnet_private"
    Env  = var.env
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id

  route = {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }
}

resource "aws_subnet" "nat_gw_subnet" {
  cidr_block              = var.nat_gw_subnet
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = "false"
  availability_zone       = var.az

  tags = {
    Name = "${var.env}_subnet_nat_gw"
    Env  = var.env
  }
}
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.nat_gw_subnet.id

}

resource "aws_eip" "eip" {
  vpc = true

  tags = {
    Name = "${var.env}_eip"
    Env  = var.env
  }
}

resource "aws_route_table_association" "private_subnet" {
  route_table_id = aws_route_table.private_route_table.id
  subnet_id      = aws_subnet.private_subnet.id
}

resource "aws_security_group" "public_sg" {
  name   = "public_sg"
  vpc_id = aws_vpc.vpc.id
  ingress {
    from_port = 22
    protocol  = "SSH"
    to_port   = 22
    cidr_blocks = [
    "0.0.0.0/0"]
  }
  ingress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0
    cidr_blocks = [
    "0.0.0.0/0"]


  }

  tags = {
    Name = "${var.env}_public_sg"
    Env  = var.env
  }
}

resource "aws_security_group" "private_sg" {
  name   = "private_sg"
  vpc_id = aws_vpc.vpc.id
  ingress {
    from_port   = 0
    protocol    = "-"
    to_port     = 0
    cidr_blocks = [var.vpc_cidr_block]
  }
  ingress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0
    cidr_blocks = [
    "0.0.0.0/0"]


  }

  tags = {
    Name = "${var.env}_public_sg"
    Env  = var.env
  }
}