# module "sg" {
#   source = "../../awssecuritygroupmodule"
#   sg_name = "roboshop-vpn"
#   sg_description = "allow-all ports form my ip address"
#   vpc_id = data.aws_vpc.default.id
#   #sg_ingress_rules = var.ingress_rules
#   project_name = var.project_name
#   common_tags = var.common_tags
# }

# resource "aws_security_group_rule" "vpn" {
#   type              = "ingress"
#   from_port         = 0
#   to_port           = 65535
#   protocol          = "tcp"
#   cidr_blocks       = ["${chomp(data.http.myip.response_body)}/32"]
#   #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
#   security_group_id = module.sg.sg_id
# }

module "vpn_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  ami = data.aws_ami.devops_ami.id
  instance_type = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.vpn_sg_id.value]
  #subnet_id = local.public_subnet_ids[0] # public subnet in 1a az
  #user_data = file("ansible.sh")
  tags = merge(
    {
        Name = "Roboshop_vpn"
    },
    var.common_tags
  )
}
