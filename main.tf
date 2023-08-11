terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = ">= 3.0"
        }
    }
}

provider "aws" {
    region = "${var.region_aws}"
}

resource "aws_instance" "web" {
  ami           = "ami-053b0d53c279acc90" 
  security_groups = ["${aws_security_group.web-sg.name}"]
  instance_type = "t2.micro"

    tags = {
    Name = "terraform"
  }
}

resource "aws_security_group" "web-sg" {
  name        = "security_group"
  description = "security group"

  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }  

  ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  } 

  ingress {
    description      = "TLS from VPC"
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