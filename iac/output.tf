output "prodip" {
  value = aws_instance.EC2.public_ip
}

output "testip" {
 value = aws_instance.EC21.public_ip
}
