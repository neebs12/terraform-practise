# .tf module consisting for an ec2 instance
# input
#   - subnet
#   - sg
#   - port

resource "aws_instance" "my_ec2" {
  instance_type = "t2.micro"
  ami = "ami-0557a15b87f6559cf"
  subnet_id = var.subnet_id
  vpc_security_group_ids = [ var.sg_id ]

  user_data = <<-EOF
              #!/bin/bash
              echo "<h1>Hello, World ${var.instance_name}<h1>" > index.html
              python3 -m http.server ${var.port_num} &
              EOF

  tags = {
    "Name" = "${var.instance_name}"
  }
}

output "public_ip_address" {
  value = aws_instance.my_ec2.public_ip
}