terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.32.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "5.25.0"
    }
    random = {
      source = "hashicorp/random"
      version = "3.5.1"
    }
    local = {
      source = "hashicorp/local"
      version = "2.4.0"
    }
    null = {
      source = "hashicorp/null"
      version = "3.2.2"
    }
  }
}

provider "digitalocean" {
  token = var.token
}

provider "aws" {
  region     = var.reg_aws
  access_key = var.acs_key
  secret_key = var.sec_key
}
