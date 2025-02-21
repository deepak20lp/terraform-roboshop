data "aws_vpc" "default_vpc" {
  default = true
}

data "http" "myip" {
  url = "https://ipv4.icanhazip.com"
}


data "aws_ssm_parameter" "vpc_id" {
    name = "/${var.project_name}-${var.env}/vpc_id"
}







