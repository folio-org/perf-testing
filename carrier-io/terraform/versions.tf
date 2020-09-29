terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    local = {
      source = "hashicorp/local"
    }
    tls = {
      source  = "hashicorp/tls"
    }
  }
  required_version = ">= 0.13"
}






