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
  ami = "ami-0d51579f02ac97d77"
  instance_type = "t2.micro"
  # os            = "Ubuntu, 18.04 LTS"
	security_groups = ["launch-wizard-7"]
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
  ami = "ami-0d51579f02ac97d77"
  instance_type = "t2.micro"
  # os            = "Ubuntu, 18.04 LTS"
  security_groups = ["launch-wizard-7"]
  key_name   = "fow_work"
  tags = {
    Name = "db_server-${count.index}"
  }
    user_data = <<-EOF
          #!/bin/bash 
          sudo apt -y update
          apt install -y software-properties-common
          apt-add-repository --yes --update ppa:ansible/ansible
          apt install -y ansible
          EOF
}

output "db_privat_ip" {
  value = "${aws_instance.db_server.*.private_ip}"
}
