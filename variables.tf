variable "aws_region"{
    default = "us-east-1"
}
variable "apache_ami"{
    default = "ami-096fda3c22c1c990a"
}
variable "instance_type"{
    default = "t2.micro"
}
variable "key_name"{
    default = "terrakey"
}
variable "private_key_path" {
  default = "terrakey.pem"
}