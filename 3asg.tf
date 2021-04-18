#1. Front end asg
# Create a front end autoscaling group with a launch template
resource "aws_launch_template" "frontend-temp" {
  name_prefix   = "front-end"
  image_id      = "ami-013f17f36f8b1fefb"
  instance_type = "t2.micro"
  key_name      = "k8-key"
}

resource "aws_autoscaling_group" "front-asg" {
  #availability_zones = ["us-east-1a", "us-east-1b"]
  desired_capacity   = 2
  max_size           = 4
  min_size           = 1
  vpc_zone_identifier = [aws_subnet.pub1.id, aws_subnet.pub2.id]
  health_check_type   = "ELB"
  launch_template {
    id      = aws_launch_template.frontend-temp.id
    version = "$Latest"
  }
}

# Create a new load balancer attachment
resource "aws_autoscaling_attachment" "front_attachment" {
  autoscaling_group_name = aws_autoscaling_group.front-asg.id
  elb                    = aws_elb.publiclb.id
}

# Create a Back-end autoscaling group with a launch template.
resource "aws_launch_template" "backend-temp" {
  name_prefix   = "back-end"
  image_id      = "ami-013f17f36f8b1fefb"
  instance_type = "t2.micro"
  key_name      = "k8-key"
}

resource "aws_autoscaling_group" "back-asg" {
  #availability_zones = ["us-east-1a", "us-east-1b"]
  desired_capacity   = 1
  max_size           = 4
  min_size           = 1
  vpc_zone_identifier = [aws_subnet.pri3.id, aws_subnet.pri4.id]
  health_check_type   = "ELB"
  launch_template {
    id      = aws_launch_template.backend-temp.id
    version = "$Latest"
  }
}

# Create a new load balancer attachment
resource "aws_autoscaling_attachment" "back_attachment" {
  autoscaling_group_name = aws_autoscaling_group.back-asg.id
  elb                    = aws_elb.privatelb.id
}

