
  terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "terraformworkspace"
    key           = "firewall.tf"
    region        = "us-east-1"
    dynamodb_table = "terraformworkspace"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}
