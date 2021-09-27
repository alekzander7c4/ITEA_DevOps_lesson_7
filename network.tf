resource "aws_vpc" "lesson7-vpc" {
  cidr_block       = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "lesson7-vpc"
  }
}

resource "aws_subnet" "lesson7-subnet-public" {
  vpc_id     = aws_vpc.lesson7-vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "eu-central-1a"

  tags = {
    Name = "lesson7-subnet-public"
  }
}

resource "aws_internet_gateway" "lesson7-igw" {
  vpc_id = aws_vpc.lesson7-vpc.id

  tags = {
    Name = "lesson7-igw"
  }
}

resource "aws_route_table" "lesson7-public-crt" {
  vpc_id = aws_vpc.lesson7-vpc.id

  route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.lesson7-igw.id
    }

  tags = {
    Name = "lesson7-public-crt"
  }
}

resource "aws_route_table_association" "lesson7-crta-public-subnet" {
  subnet_id      = aws_subnet.lesson7-subnet-public.id
  route_table_id = aws_route_table.lesson7-public-crt.id
}

resource "aws_security_group" "lesson7-http-ssh" {
  name        = "lesson7-http-ssh"
  description = "lesson7-http-ssh"
  vpc_id      = aws_vpc.lesson7-vpc.id

  ingress {
      description      = "http"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  ingress {
      description      = "ssh"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }

  egress {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }

  tags = {
    Name = "lesson7-http-ssh"
  }
}

resource "aws_db_subnet_group" "lesson7-db-sg" {
  name       = "lesson7-db-sg"
  subnet_ids = [aws_subnet.lesson7-db-subnet-1.id, aws_subnet.lesson7-db-subnet-2.id]

  tags = {
    Name = "lesson7-db-sg"
  }
}

resource "aws_subnet" "lesson7-db-subnet-1" {
  vpc_id     = aws_vpc.lesson7-vpc.id
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone = "eu-central-1a"

  tags = {
    Name = "lesson7-db-subnet-1"
  }
}

resource "aws_subnet" "lesson7-db-subnet-2" {
  vpc_id     = aws_vpc.lesson7-vpc.id
  cidr_block = "10.0.3.0/24"
  map_public_ip_on_launch = true
  availability_zone = "eu-central-1b"

  tags = {
    Name = "lesson7-db-subnet-2"
  }
}

resource "aws_security_group" "lesson7-mysql" {
  name        = "lesson7-mysql"
  description = "lesson7-mysql"
  vpc_id      = aws_vpc.lesson7-vpc.id

  ingress {
      description      = "mysql port"
      from_port        = 3306
      to_port          = 3306
      protocol         = "tcp"
      cidr_blocks      = [aws_vpc.lesson7-vpc.cidr_block]
    }

  egress {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
    }

  tags = {
    Name = "lesson7-mysql"
  }
}