terraform {
  required_providers {

    random = {
      source  = "hashicorp/random"
      version = ">= 3.1"
    }

    http = {
      source  = "hashicorp/http"
      version = ">= 2.1.0"
    }

    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.62.0"
    }

    db = {
      source  = "terraform-aws-modules/rds/aws"
      version = "~> 3.0"
    }

  }

  required_version = ">= 0.15"
}
