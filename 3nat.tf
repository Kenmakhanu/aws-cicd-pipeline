resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.pub2.id

  tags = {
    Name = "gw NAT"
  }
}

