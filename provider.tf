terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  backend "remote" {
    organization = "mindmelting"

    workspaces {
      name = "terraform-homeassistant-alexa"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "us-west-2"
}