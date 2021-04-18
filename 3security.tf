resource "aws_security_group" "int_sg" {
  name        = "int_sg"
  description = "Allow all inbound traffic"
  vpc_id      = aws_vpc.myvpc.id

  ingress {
    description = "All traffic from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "int-sg"
  }
}

# Create external Application Load Balancer security group
resource "aws_security_group" "ext_sg" {
  name        = "ext_sg"
  description = "Allow http inbound traffic"
  vpc_id      = aws_vpc.myvpc.id

  ingress {
    description = "All HTTP traffic VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

   ingress {
    description = "All HTTPS traffic VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
  
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ext-sg"
  }
}

# Create a bastion security group
resource "aws_security_group" "bastion_sg" {
  name        = "bastion_sg"
  description = "Allow ssh inbound traffic"
  vpc_id      = aws_vpc.myvpc.id

  ingress {
    description = "All ssh traffic VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bastion_sg"
  }
}




