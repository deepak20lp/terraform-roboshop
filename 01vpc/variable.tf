variable "cidr_block" {
    default = "10.0.0.0/16"
}

variable "project_name" {
  default = "roboshop"
}

variable "env" {
  default = "dev"
}

variable "public_subnets_cidr" {
  default = [ "10.0.1.0/24","10.0.2.0/24" ]
}

variable "private_subnets_cidr" {
    default = [ "10.0.11.0/24" ,"10.0.12.0/24"]
}

variable "database_subnets_cidr" {
    default = ["10.0.21.0/24","10.0.22.0/24"]
}

variable "common_tags" {
  default = {
    Project = "roboshop"
    Environment = "DEV"
    Terraform = "true"
    Comonent = "vpc"
  }
}

