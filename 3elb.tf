# Create a new load balancer
resource "aws_elb" "publiclb" {
  name               = "publiclb"
  security_groups    = [aws_security_group.bastion_sg.id]
  internal           = false
  subnets            = [aws_subnet.pub1.id, aws_subnet.pub2.id]
  listener {
    instance_port     = 8000
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  listener {
    instance_port      = 8000
    instance_protocol  = "tcp"
    lb_port            = 22
    lb_protocol        = "tcp"
    
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:8000/"
    interval            = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining_timeout = 400

  tags = {
    Name = "publiclb"
  }
}

# Create a private load balancer
resource "aws_elb" "privatelb" {
  name               = "privatelb"
  security_groups    = [aws_security_group.int_sg.id]
  internal           = true
  subnets            = [aws_subnet.pri3.id, aws_subnet.pri4.id]
  listener {
    instance_port     = 8000
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  listener {
    instance_port      = 8000
    instance_protocol  = "tcp"
    lb_port            = 22
    lb_protocol        = "tcp"
    
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:8000/"
    interval            = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining_timeout = 400

  tags = {
    Name = "privatelb"
  }
}