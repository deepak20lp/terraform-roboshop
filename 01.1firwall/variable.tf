variable "common_tags" {
  default = {
    Project = "roboshop"
    Environment = "DEV"
    Terraform = "true"
    #Component = "vpc"
  }
}
variable "project_name" {
  default = "roboshop"
}
variable "env" {
  default = "dev"
}