# aws-terraform-ansible-lamp

Cloud  : Amazon AWS Cloud

Operating System used :  Amazon Linux


Install Terraform 
https://www.terraform.io/downloads.html

Before run the module, please do below changes according to your AWS cloud Environment

In main.tf
-----------

subnet_id              = "subnet-94a51bdf"

 vpc_id      = "vpc-f052e488"
 
 In vars.tf
 ----------
 
  default = "/home/ec2-user/lamp.pem"
  
   default = "devec2-keypair"
 

Please report issues on https://github.com/bakuppus/aws-terraform-ansible-lamp/issues
