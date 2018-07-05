##### Terraform LAMP  Module  Variables    ###########

variable "name" {
  description = "lamp server"
  default = "server"
}

# Instance type 
variable "instance_type" {
  description = "AWS instance type to launch lamp server"
  default = "t2.micro"
}

# private key 
variable "aws_key_path" {
  default = "/home/ec2-user/lamp.pem" 
}

# Keypair to login as ec2-user
variable "key_pair" {
  description = "Name of key pair to attach to the  lamp server instance."
  default = "devec2-keypair"
}

