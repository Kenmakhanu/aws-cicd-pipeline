resource "aws_route_table" "pub" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}
  resource "aws_route_table_association" "a" {
    subnet_id      = aws_subnet.pub1.id 
    route_table_id = aws_route_table.pub.id
  }

# Create a private route table and associate it with the NAT gateway
resource "aws_route_table" "pri" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.natgw.id
  }
}

resource "aws_route_table_association" "b" {
    subnet_id      = aws_subnet.pri4.id
    route_table_id = aws_route_table.pri.id
}

