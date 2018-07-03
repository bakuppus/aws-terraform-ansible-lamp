###### Terraform Module to install LAMP on EC2 #######

resource "aws_instance" "ec2-lamp" {
  ami                    = "ami-b70554c8"                              
  instance_type          = "${var.instance_type}"
  subnet_id              = "subnet-94a51bdf"                   
  key_name               = "${var.key_pair}"
  vpc_security_group_ids = ["${aws_security_group.lamp-sec-grp.id}"]
  
 tags {
    Name = "lamp-${var.name}"
  }


provisioner "file" {
    source      = "install_ansible.sh"
    destination = "/tmp/install_ansible.sh"
    connection {
      user = "ec2-user"
      private_key = "${file(var.aws_key_path)}"
      agent = "false" 
      timeout = "30s"
  }
}


provisioner "remote-exec" {
    inline = [
        "sudo chmod +x /tmp/install_ansible.sh",
        "sudo  /tmp/install_ansible.sh"
     ]
      connection { 
      type = "ssh"
      user = "ec2-user"
      private_key = "${file(var.aws_key_path)}"      
      timeout = "30s"

  }
}


provisioner "file" {
    source      = "."
    destination = "/home/ec2-user"
    connection {
      user = "ec2-user"
      private_key = "${file(var.aws_key_path)}"
      agent = "false"
      timeout = "30s"
  }
}

provisioner "remote-exec" {
    inline = [
         "ansible-playbook /home/ec2-user/lamp.yml"
    ]
      connection {
      type = "ssh"
      user = "ec2-user"
      private_key = "${file(var.aws_key_path)}"
      timeout = "30s"
   }
 }

}


resource "aws_security_group" "lamp-sec-grp" {
  name        = "lamp Security Group"
  description = "lamp access"
  vpc_id      = "vpc-f052e488"

  ingress {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }


  ingress {
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
  
  tags {
    Name = "lamp Security Group"
  }

}

