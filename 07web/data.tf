data "aws_ssm_parameter" "vpc_id" {
    name = "/${var.project_name}-${var.env}/vpc_id"
}

data "aws_ami" "devops_ami" {
  most_recent      = true
  name_regex       = "Centos-8-DevOps-Practice"
  owners           = ["973714476881"]

  filter {
    name   = "name"
    values = ["Centos-8-DevOps-Practice"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_ssm_parameter" "web_sg_id" {
    name = "/${var.project_name}-${var.env}/web_sg_id"

}

data "aws_ssm_parameter" "public_subnet_ids" {
    name = "/${var.project_name}-${var.env}/public_subnet_ids"

}