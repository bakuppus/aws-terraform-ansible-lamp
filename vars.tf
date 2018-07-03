##### Terraform LAMP  Module  Variables    ###########

variable "name" {
  description = "lamp server"
  default = "server"
}


variable "instance_type" {
  description = "AWS instance type to launch lamp server"
  default = "t2.micro"
}


variable "aws_key_path" {
  default = "/home/ec2-user/lamp.pem" 
}

variable "key_pair" {
  description = "Name of key pair to attach to the  lamp server instance."
  default = "devec2-keypair"
}

