# resource "aws_ssm_parameter" "vpn_sg_id" {
#     name = "/${var.project_name}-${var.env}/vpn_sg_id"
#     type = "String"
#     value = module.sg.sg_id #we should have output declaration in mocule
# }