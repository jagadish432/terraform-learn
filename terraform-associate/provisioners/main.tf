terraform {
  /*
  cloud {
    organization = "jagadishdachepalli"

    workspaces {
      name = "provisioners"
    }
  }
  */
  
}

provider "aws" {
  region = "us-east-1"
}

data "aws_vpc" "main" {
  id = "vpc-0161b7812d2dd71e7"
}

data "template_file" "user_data" {
  template = file("./userdata.yaml")
}

resource "aws_security_group" "sg_my_server_tf" {
  name        = "sg_my_server_tf"
  description = "My server tf security group"
  vpc_id      = data.aws_vpc.main.id

  ingress {
    description      = "Http"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = [] # using default VPC, it doesn't have IPV6
  }

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["183.83.253.71/32"]
    ipv6_cidr_blocks = []
  }

  egress {
    description = "outgoing traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "sg-tf"
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDgIDsuOCkCoP3/vmumoueyNNjPVmovNVH/RDbQi8JvrzJp/II+CyigYwPbMEkG5Aaw6y0SDra3z42xsrusoToa1GxACSwfDx0hFlBeAMmAjZu0G09PlYX+EXpcWJOCePiRGLCr4Q7dBr6x/65f4oGt/DntdTrs2fnF/ST/SAxfbCWMW+l+pcX1qeBXos7DvwwgfZs9ZiV+D/3VzdcYYZF/ZpC1D+G3O/nWYO1BiDJJzr3ztEoc26Y5QBeP8nCDpPd137mbTzCRzOwpv7sAGrRO9SZFyStcrwZVfuYnnXhAXji0EKjLtQzoj3EdPmgahqiCBDKYS06XuKSQPHy866tZkohAsjIpbwg1OX3G3OLSdBA5svHSJdKFs3b4l9Vmy45fZ4Fo3jcsHhbm7QxQUsaYS0tQwds9G+uRUmPjjG3BsCsmfGOx/qRxx3guBHGsHoR2+VpOhFio6xbyA6HYNKjSGr7+H6vLlt1LJ1F+Nd+JeZWKlbwW/RTfnc+Gg3EQne8= jdachepa@jdachepa-mac"
}

resource "aws_instance" "my_server_tf" {
  ami           = "ami-09d3b3274b6c5d4aa"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.deployer.key_name}"
  vpc_security_group_ids = [aws_security_group.sg_my_server_tf.id]
  user_data = data.template_file.user_data.rendered  # using the loaded userdata.yaml file content

  provisioner "remote-exec" {
    inline = [
      "echo ${self.private_ip} >> /home/ec2-user/private_ips.txt"
    ]
    connection {
      type = "ssh"
      user = "ec2-user"
      #private_key = "${file("~/.ssh/terraform")}"
      agent = true
      host = "${self.public_ip}"
    }
  }

  tags = {
    Name = "my-server-tf"
  }
}

output "public_ip" {
  value = aws_instance.my_server_tf.public_ip
}
