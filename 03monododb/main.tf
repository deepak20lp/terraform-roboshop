  
#   module "mongodb_sg" {
  
#   source = "../../awssecuritygroupmodule"
#   sg_name = "mongodb"
#   sg_description = "allowing_traffic"
#   vpc_id = data.aws_ssm_parameter.vpc_id.value
#   #sg_ingress_rules = var.ingress_rules
#   project_name = var.project_name
#   common_tags = var.common_tags

#   }

#  resource "aws_security_group_rule" "mongodb" {
#   type              = "ingress"
#   from_port         = 22
#   to_port           = 22
#   protocol          = "tcp"
#   #cidr_blocks       = ["${chomp(data.http.myip.response_body)}/32"]
#   #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
#   source_security_group_id = data.aws_ssm_parameter.vpn_sg_id.value
#   security_group_id = module.mongodb_sg.sg_id
# }

module "mongodb_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  ami = data.aws_ami.devops_ami.id
  instance_type = "t3.medium"
  vpc_security_group_ids = [data.aws_ssm_parameter.mongodb_sg_id.value]
  #it should be roboshop db subnet
  #subnet_id = local.public_subnet_ids[0] # public subnet in 1a az
  #user_data = file("ansible.sh")
  subnet_id = local.db_subnet_id
  user_data = file("mongodb.sh")
  tags = merge(
    {
        Name = "mongodb"
    },
    var.common_tags
  )
}


#install mongodb
module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  zone_name = var.zone_name
  records = [
    {
        name    = "${var.common_tags.Component}"
        type    = "A"
        ttl     = 1
        records = [module.mongodb_instance.private_ip]
    }
  ]
}