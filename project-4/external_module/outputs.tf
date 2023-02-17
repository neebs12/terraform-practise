output "ec2_ext_public_ip" {
  description = "public ip address of ec2 instance"
  value = aws_instance.my_ec2.public_ip

  depends_on = [
    aws_instance.my_ec2
  ]
}