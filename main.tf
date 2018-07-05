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

#Install Ansible
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

# Run Ansible Playbook
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

#Create Security Group
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

# Create Elastic Loadbalancer
resource "aws_elb" "web" {
name = "lamp-elb"

subnets = ["subnet-94a51bdf"]

security_groups = ["${aws_security_group.lamp-sec-grp.id}"]

listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  # The instance is registered automatically

  instances                   = ["${aws_instance.ec2-lamp.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400
}




