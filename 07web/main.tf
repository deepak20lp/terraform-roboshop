module "web" {
  source = "../../terraformroboshopapp"
  common_tags = var.common_tags
  project_name = var.project_name
  env = var.env
  health_check = var.health_check 
  target_group_port = var.target_group_port
  
  vpc_id = data.aws_ssm_parameter.vpc_id.value


    image_id = data.aws_ami.devops_ami.id
    vpc_security_group_ids = data.aws_ssm_parameter.web_sg_id.value
    user_data = filebase64("${path.module}/web.sh")
    launch_template_tags = var.launch_template_tags

    vpc_zone_identifier = split(",",data.aws_ssm_parameter.public_subnet_ids.value)
    tag = var.auto_scaling_tags
    
    
}