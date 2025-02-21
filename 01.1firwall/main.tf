  module "mongodb_sg" {

  
  source = "../../awssecuritygroupmodule"
  sg_name = "mongodb"
  sg_description = "allowing_traffic fro catalogue user and vpc"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  #sg_ingress_rules = var.ingress_rules
  project_name = var.project_name
  common_tags = merge(
    var.common_tags,
{
    Component = "mongodb"
    Name = "mongodb"
}
  )
  }

    module "catalogue_sg" {
  
  source = "../../awssecuritygroupmodule"
  sg_name = "catalogue"
  sg_description = "allowing_traffic fro web and vpc"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  #sg_ingress_rules = var.ingress_rules
  project_name = var.project_name
  common_tags = merge(
    var.common_tags,
{
    Component = "catalogue"
    Name = "catalogue"
}
  )
  } 
  module "vpn_sg" {
  source = "../../awssecuritygroupmodule"
  sg_name = "roboshop-vpn"
  sg_description = "allow-all ports form my ip address"
  vpc_id = data.aws_vpc.default_vpc.id
  #sg_ingress_rules = var.ingress_rules
  project_name = var.project_name
  common_tags = merge(
    var.common_tags,
    {
        Component = "vpn"
        Name = "roboshop_vpn"
    }
  )
}
  module "web_sg" {
  
  source = "../../awssecuritygroupmodule"
  sg_name = "web"
  sg_description = "allowing_traffic from web alb user and vpc"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  #sg_ingress_rules = var.ingress_rules
  project_name = var.project_name
  common_tags = merge(
    var.common_tags,
{
    Component = "web"
}
  )
  }

    module "app_alb_sg" {
  
  source = "../../awssecuritygroupmodule"
  sg_name = "app_alb"
  sg_description = "allowing_traffic from web ins and vpc"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  #sg_ingress_rules = var.ingress_rules
  project_name = var.project_name
  common_tags = merge(
    var.common_tags,
{
    Component = "app"
    Name = "app-alb"
}
  )
  }


 module "web_alb_sg" {
  
  source = "../../awssecuritygroupmodule"
  sg_name = "web_alb"
  sg_description = "allowing_traffic from web ins and vpc"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  #sg_ingress_rules = var.ingress_rules
  project_name = var.project_name
  common_tags = merge(
    var.common_tags,
{
    Component = "web"
    Name = "web-alb"
}
  )
  }
  

resource "aws_security_group_rule" "vpn" {
  type              = "ingress"
  description = "allwoing all ports form my laptop"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["${chomp(data.http.myip.response_body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.vpn_sg.sg_id
}


   resource "aws_security_group_rule" "mongodb_catalogue" { #mongodb allowing connections form catalogue
  type              = "ingress"
  description = "allowing 27017 port form catalogue"
  from_port         = 27017
  to_port           = 27017
  protocol          = "tcp"
  #cidr_blocks       = ["${chomp(data.http.myip.response_body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  source_security_group_id = module.catalogue_sg.sg_id
  security_group_id = module.mongodb_sg.sg_id
}

  resource "aws_security_group_rule" "mongodb_vpn" { #mongodb allowing connections on port no 22 form vpn for trouble 
  type              = "ingress"
  description = "allowing 22 port form vpn"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  #cidr_blocks       = ["${chomp(data.http.myip.response_body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  source_security_group_id = module.vpn_sg.sg_id
  security_group_id = module.mongodb_sg.sg_id
}

  resource "aws_security_group_rule" "catalogue_vpn" { #catalogue allowing connections 22port form vpn
  type              = "ingress"
  description = "allowing 22 port form vpn"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  #cidr_blocks       = ["${chomp(data.http.myip.response_body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  source_security_group_id = module.vpn_sg.sg_id
  security_group_id = module.catalogue_sg.sg_id 
}

  resource "aws_security_group_rule" "catalogue_app_alb" { #catalogue allowing connections 22port form vpn
  type              = "ingress"
  description = "allowing 8080 port form app_alb"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  #cidr_blocks       = ["${chomp(data.http.myip.response_body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  source_security_group_id = module.app_alb_sg.sg_id
  security_group_id = module.catalogue_sg.sg_id 
}

 resource "aws_security_group_rule" "app_alb_vpn" { #catalogue allowing connections 22port form vpn
  type              = "ingress"
  description = "allowing 80 port form vpn"
  from_port         = 80 #lb is 80 port
  to_port           = 80
  protocol          = "tcp"
  #cidr_blocks       = ["${chomp(data.http.myip.response_body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  source_security_group_id = module.vpn_sg.sg_id
  security_group_id = module.app_alb_sg.sg_id 
}

 resource "aws_security_group_rule" "app_alb_web" { #catalogue allowing connections 22port form vpn
  type              = "ingress"
  description = "allowing 80 port form web"
  from_port         = 80 #lb is 80 port
  to_port           = 80
  protocol          = "tcp"
  #cidr_blocks       = ["${chomp(data.http.myip.response_body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  source_security_group_id = module.web_sg.sg_id
  security_group_id = module.app_alb_sg.sg_id 
}

 resource "aws_security_group_rule" "web_vpn" { #catalogue allowing connections 22port form vpn
  type              = "ingress"
  description = "allowing 8080 port form app_alb"
  from_port         = 22 #lb is 80 port
  to_port           = 22
  protocol          = "tcp"
  #cidr_blocks       = ["${chomp(data.http.myip.response_body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  source_security_group_id = module.vpn_sg.sg_id
  security_group_id = module.web_sg.sg_id 
}

 resource "aws_security_group_rule" "web_web_alb" { #catalogue allowing connections 22port form vpn
  type              = "ingress"
  description = "allowing 8080 port form app_alb"
  from_port         = 80 #lb is 80 port
  to_port           = 80
  protocol          = "tcp"
  #cidr_blocks       = ["${chomp(data.http.myip.response_body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  source_security_group_id = module.web_alb_sg.sg_id
  security_group_id = module.web_sg.sg_id 
}

 resource "aws_security_group_rule" "web_alb_internet" { #catalogue allowing connections 22port form vpn
  type              = "ingress"
  description = "allowing 8080 port form app_alb"
  from_port         = 80 #lb is 80 port
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  #source_security_group_id = module.web_alb_sg.sg_id
  security_group_id = module.web_alb_sg.sg_id 
}

 resource "aws_security_group_rule" "web_alb_internethttps" { #catalogue allowing connections 22port form vpn
  type              = "ingress"
  description = "allowing 8080 port form app_alb"
  from_port         = 443 #lb is 80 port
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  #source_security_group_id = module.web_alb_sg.sg_id
  security_group_id = module.web_alb_sg.sg_id 
}






