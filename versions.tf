terraform {
  required_providers {

    http = {
      source  = "hashicorp/http"
      version = ">= 2.1.0"
    }

    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.62.0"
    }
  }

  required_version = ">= 0.15"
}
