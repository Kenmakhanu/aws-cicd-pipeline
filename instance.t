#1. Configure the AWS Provider
provider "aws" {
  region = var.aws_region
}



#3. Create an instance and attach security group
resource "aws_instance" "web" {
  ami              = var.apache_ami
  instance_type    = var.instance_type
  key_name         = var.key_name
  vpc_security_group_ids = [ aws_security_group.allow_all.id ]
 #user_data        = "${file("apache.sh")}"
     tags = {
       Name = "Apache"
  }
 # Copies the myapp.conf file to /etc/myapp.conf
  provisioner "file" {
    source      = "apache.sh"
    destination = "/tmp/apache.sh"
  } 
 provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/apache.sh",
      "/tmp/apache.sh",
    ]
  }
# Connection block
connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = file(var.private_key_path)
    host     = self.public_ip
  }
}
