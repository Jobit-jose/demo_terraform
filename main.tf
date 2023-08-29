terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = ">= 5.0"
        }
    }
}

provider "aws" {
    region = "${var.region_aws}"
}

resource "aws_instance" "web" {
  ami = "ami-0261755bbcb8c4a84" 
  security_groups = ["${aws_security_group.web-sg.name}"]
  instance_type = "t2.micro"
  key_name = "terraform_key"
  tags = {
    Name = "terraform"
  }


  provisioner "remote-exec" {
    inline = [ 
            "sudo apt update -y",   
            "sudo apt install -y apache2",  
            "sudo systemctl start apache2", 
            "sudo systemctl enable apache2"
    ]
  }

  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = file("terraform_key.pem")
    host = "${self.public_ip}"
  }
}

resource "aws_security_group" "web-sg" {
  name        = "security_group"
  description = "security group"

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }  

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  } 

  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
