variable "common_tags" {
  default = {
    Project = "roboshop"
    Environment = "DEV"
    Terraform = "true"
    Component = "mongodb"
  }
}
variable "project_name" {
  default = "roboshop"
}
variable "env" {
  default = "dev"
}
variable "zone_name" {
  default = "deepakreddy.online"
}