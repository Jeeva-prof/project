// Create Security Group
resource "aws_security_group" "app_SG" {
  name        = "finance_sg"
  
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
    Name = "finance_sg"
  }
}
resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINbgziXYhMEhfAMi5T/jrKajtzSLb0w7JpkiiNeTZAG+ root@master"
}
resource "aws_instance" "EC2" {
  ami           = "ami-0b8eb446c5e792d0d" 
  instance_type = "t2.micro"
  key_name        = "deployer-key"
  availability_zone = "ap-south-1a"
  vpc_security_group_ids = [aws_security_group.app_SG.id]
  associate_public_ip_address = true
  
  tags = {
    Name = "test-server"
  }
  
}
