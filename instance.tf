data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "lesson7-instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  subnet_id = aws_subnet.lesson7-subnet-public.id

  vpc_security_group_ids = [aws_security_group.lesson7-http-ssh.id]

  key_name = "lesson7_key"

#   user_data = file("script.sh")

  tags = {
    Name = "lesson7-instance"
  }
}