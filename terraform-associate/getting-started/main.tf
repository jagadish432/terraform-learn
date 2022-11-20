terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.39.0"
    }
  }

  cloud {
    organization = "jagadishdachepalli"

    workspaces {
      name = "getting-started"
    }
  }
}

locals {
    project_name = "tf"
}
