locals{
    db_subnet_id = split(",", data.aws_ssm_parameter.db_subnet.value)[0]
}