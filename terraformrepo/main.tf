provider "aws" {
  region     = "us-east-2"
  access_key = "AKIAWLQURUPUJPPKDGXN"
  secret_key = "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"
}

resource "aws_security_group" "asg" {
  name        = "asg"
  description = "allowing ssh and http traffic"

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }

}

resource "aws_instance" "ec2" {
  ami             = "ami-0f924dc71d44d23e2"
  instance_type   = "t2.micro"
  security_groups = ["${aws_security_group.asg.name}"]
  tags = {
    name = "webserver"

  }
  user_data = <<-EOF
              #! /bin/bash
              sudo yum install httpd -y
              sudo systemctl start httpd
              sudo systemctl enable httpd
              echo "<h1>Sample Webserver creating using terraform<br>Webserver</h1>" >> /var/www/html/index.html
EOF
}

terraform {
  backend "s3" {
    bucket = "devops4545name"
    key = "main"
    region = "us-east-1"
  }
}
