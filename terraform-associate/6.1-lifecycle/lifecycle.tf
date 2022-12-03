terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.40.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}


resource "aws_instance" "my_server_tf" {
  
    ami           = "ami-09d3b3274b6c5d4aa"
    instance_type = "t2.micro"
    tags = {
        Name = "Server-micro"
    }
    lifecycle {
      # prevent_destroy = true
      prevent_destroy = false
    }
}

output "public_ip" {
    value = aws_instance.my_server_tf.public_ip
}

# when we do destroy on resources having `prevent_destory as true`, terraform throws the below error

#  Error: Instance cannot be destroyed
# │ 
# │   on lifecycle.tf line 15:
# │   15: resource "aws_instance" "my_server_tf" {
# │ 
# │ Resource aws_instance.my_server_tf has lifecycle.prevent_destroy set, but the plan calls for this
# │ resource to be destroyed. To avoid this error and continue with the plan, either disable
# │ lifecycle.prevent_destroy or reduce the scope of the plan using the -target flag.


# THAT'S WHY I'm changing the `prevent_destrpy` to false and try terrform destory again