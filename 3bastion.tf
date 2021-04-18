resource "aws_network_interface" "nic" {
  subnet_id       = aws_subnet.pub1.id
  private_ips     = ["10.0.1.10"]
  security_groups = [aws_security_group.bastion_sg.id]
  

  /*attachment {
    instance     = aws_instance.bastion.id
    device_index = 1
  }*/
}


resource "aws_instance" "bastion" {
  ami           = "ami-013f17f36f8b1fefb"
  instance_type = "t2.micro"
  availability_zone = "us-east-1a"
  key_name      = "k8-key"
  tags = {
    Name = "Bastion-host"
  }
}