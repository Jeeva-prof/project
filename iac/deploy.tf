// Create Security Group
import {
  to = aws_security_group.app_SG
  id = "sg-0b581c1f2b03eeaf5"
}
}
resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP/vYB7ZgCxcwRPGP4kJoPttUs5aCrsBWj0QdgBVdJ8D root@master"
}
resource "aws_instance" "EC2" {
  ami           = "ami-0b8eb446c5e792d0d" 
  instance_type = "t2.micro"
  key_name        = "deployer-key"
  availability_zone = "ap-south-1a"
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.app_SG.id]
  tags = {
    Name = "test-server"
  }
  
}
resource "aws_instance" "EC21" {
  ami           = "ami-0b8eb446c5e792d0d" 
  instance_type = "t2.micro"
  key_name        = "deployer-key"
  availability_zone = "ap-south-1a"
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.app_SG.id]
  tags = {
    Name = "production-server"
  }
  
}
