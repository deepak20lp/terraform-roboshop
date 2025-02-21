resource "aws_ssm_parameter" "listener_arn" {
    name = "/${var.project_name}-${var.env}/listener_arn"
    type = "String"
    value = resource.aws_lb_listener.default_listener.arn  #we should have output declaration in mocule
}