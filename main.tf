terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
        }
    }
}

provider "aws" { 
  region = "eu-central-1"
}

resource "aws_instance" "jira_app" {
  count = 3
  ami = "ami-042ad9eec03638628"
  instance_type = "t2.micro"
  key_name   = "fow_work"
  tags = {
    Name = "jira_app-${count.index}"
  }
}

output "app_privat_ip" {
  value = "${aws_instance.jira_app.*.private_ip}"
}

resource "aws_instance" "db_server" {
  count = 1
  ami = "ami-042ad9eec03638628"
  instance_type = "t2.micro"
  key_name   = "fow_work"
  tags = {
    Name = "db_server-${count.index}"
  }
}

output "db_privat_ip" {
  value = "${aws_instance.db_server.*.private_ip}"
}
