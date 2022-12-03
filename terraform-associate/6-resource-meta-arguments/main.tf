terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.40.0"
    }
  }
}

# provider "aws" {
#   region = "us-east-1"
# }

# resource "aws_s3_bucket" "bucket" {
#     bucket = "dream11s3bucket"
#     depends_on = [
#       aws_instance.my_server_tf
#     ]
# }

# resource "aws_instance" "my_server_tf" {
#     count = 2
#     ami           = "ami-09d3b3274b6c5d4aa"
#     instance_type = "t2.micro"
# }

# output "public_ip" {
#     value = aws_instance.my_server_tf[*].public_ip
# }

# resource "aws_instance" "my_server_tf" {
#     for_each = {
#       nano = "t2.nano"
#       micro = "t2.micro"
#       small = "t2.small"
#     }
#     ami           = "ami-09d3b3274b6c5d4aa"
#     instance_type = each.key
#     tags = {
#         Name = "Server-${each.key}"
#     }
# }

# output "public_ip" {
#     value = values(aws_instance.my_server_tf)[*].public_ip
# }

provider "aws" {
  region = "us-east-1"
  alias = "east"
}

provider "aws" {
  region = "us-west-1"
  alias = "west"
}

data "aws_ami" "amazon-linux-2" {
    most_recent = true

    filter {
      name = "owner-alias"
      values = ["amazon"]
    }
    filter {
      name = "name"
      values = ["amzn2-ami-hvm*"]
    }
}

data "aws_ami" "amazon-linux-2-west" {
    most_recent = true

    filter {
      name = "owner-alias"
      values = ["amazon"]
    }
    filter {
      name = "name"
      values = ["amzn2-ami-hvm*"]
    }
    provider = aws.west
}

resource "aws_instance" "east_server_tf" {
    ami           = data.aws_ami.amazon-linux-2.id
    instance_type = "t2.micro"
    tags = {
        Name = "Server-east"
    }
    provider = aws.east
}

output "public_ip_east" {
    value = aws_instance.east_server_tf.public_ip
}

resource "aws_instance" "west_server_tf" {
    ami           = data.aws_ami.amazon-linux-2-west.id
    instance_type = "t2.micro"
    tags = {
        Name = "Server-west"
    }
    provider = aws.west
}

output "public_ip_west" {
    value = aws_instance.west_server_tf.public_ip
}
