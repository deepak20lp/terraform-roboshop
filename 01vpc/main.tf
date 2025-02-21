module "vpc" {
  source = "../../awsvpcadvanced"
   cidr_block = var.cidr_block
    project_name = var.project_name
    env = var.env
    public_subnets_cidr = var.public_subnets_cidr 
    private_subnets_cidr = var.private_subnets_cidr
    database_subnets_cidr = var.database_subnets_cidr
    requestor_id = data.aws_vpc.default_vpc.id
    is_peering = true
    default_route_table_id = data.aws_vpc.default_vpc.main_route_table_id
    default_vpc_cidr = data.aws_vpc.default_vpc.cidr_block

}