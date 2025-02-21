variable "project_name" {
  default = "roboshop"
}

variable "common_tags" {
  default = {
    Project = "roboshop"
    Environment = "DEV"
    Terraform = "true"
    Comonent = "vpn"
  }
}

variable "env" {
  default = "dev"
}

