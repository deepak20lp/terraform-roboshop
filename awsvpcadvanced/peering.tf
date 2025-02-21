resource "aws_vpc_peering_connection" "vpc_peering" {
    count = var.is_peering ? 1 : 0
  #peer_owner_id = "${var.peer_owner_id}"
  peer_vpc_id   = aws_vpc.roboshop.id #default vpc is requesting for peerign with roboshop vpc
  #below one is the requestor vpc id which is default
  vpc_id        = var.requestor_id
  auto_accept = true

  tags = merge(
    {
    Name = "vpc peering between Default and ${var.project_name}"
    },
    var.common_tags
)
}

resource "aws_route" "public_default"{
  count = var.is_peering ? 1 : 0
  route_table_id            = var.default_route_table_id
  destination_cidr_block    = var.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering[0].id
  #since we set count parameter it is treated as list even single element 
}

resource "aws_route" "public_roboshop" {
    count = var.is_peering ? 1 : 0 
    route_table_id = aws_route_table.public_route_table.id
    destination_cidr_block = var.default_vpc_cidr
    vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering[0].id
}

resource "aws_route" "private_roboshop" {
    count = var.is_peering ? 1 : 0 
    route_table_id = aws_route_table.private_route_table.id
    destination_cidr_block = var.default_vpc_cidr
    vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering[0].id
}

resource "aws_route" "database_roboshop" {
    count = var.is_peering ? 1 : 0 
    route_table_id = aws_route_table.database_route_table.id
    destination_cidr_block = var.default_vpc_cidr
    vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering[0].id
}