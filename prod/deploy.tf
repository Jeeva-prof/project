// Create Security Group
resource "aws_security_group" "app_SG1" {
  name        = "finance_sg1"
  
  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
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
    Name = "finance_sg1"
  }
}
resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key1"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP/vYB7ZgCxcwRPGP4kJoPttUs5aCrsBWj0QdgBVdJ8D root@master"
}

resource "aws_instance" "EC21" {
  ami           = "ami-0b8eb446c5e792d0d" 
  instance_type = "t2.micro"
  key_name        = "deployer-key1"
  availability_zone = "ap-south-1a"
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.app_SG1.id]
  tags = {
    Name = "Production-Server"
  }
  
}
