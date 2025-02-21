resource "aws_vpc" "roboshop" {
    cidr_block = var.cidr_block
    enable_dns_hostnames = var.enable_dns_hostnames
    enable_dns_support = var.enable_dns_support

    tags = merge(
        var.common_tags,
        {
            Name = "${var.project_name}-${var.env}"
        },
        var.vpc_tags
     )
    
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.roboshop.id

    tags = merge(

        var.common_tags,
        {
            Name = "${var.project_name}-${var.env}"
        },
        var.igw_tags
    )
}

resource "aws_subnet" "public_subnet" {
    count = length(var.public_subnets_cidr)
    map_public_ip_on_launch = true
    vpc_id = aws_vpc.roboshop.id
    cidr_block = var.public_subnets_cidr[count.index]
    availability_zone = local.azs[count.index]
    tags = merge(

        var.common_tags,
        {
            Name = "${var.project_name}-${var.env}-public-${local.azs[count.index]}"
        }
    )
}

resource "aws_subnet" "private_subnet" {
    count = length(var.private_subnets_cidr)
    vpc_id = aws_vpc.roboshop.id
    cidr_block = var.private_subnets_cidr[count.index]
    availability_zone = local.azs[count.index]

    tags = merge(

      var.common_tags,
      {
        Name = "${var.project_name}-${var.env}-private-${local.azs[count.index]}"
      }
    )
}

resource "aws_subnet" "database_subnet" {
    count = length(var.database_subnets_cidr)
    vpc_id = aws_vpc.roboshop.id
    cidr_block = var.database_subnets_cidr[count.index]
    availability_zone = local.azs[count.index]

    tags = merge(

      var.common_tags,
      {
        Name = "${var.project_name}-${var.env}-database-${local.azs[count.index]}"
      }
    )
}

resource "aws_route_table" "public_route_table" {
        vpc_id = aws_vpc.roboshop.id

        tags = merge(

            var.common_tags,
            {
                Name = "${var.project_name}-${var.env}-public"
            },
            var.public_route_table_tags
        )
}
resource "aws_route" "public_routes" {
    route_table_id = aws_route_table.public_route_table.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
}

resource "aws_eip" "lb" {
  domain   = "vpc"
}

resource "aws_nat_gateway" "nat" {
    allocation_id = aws_eip.lb.id
    subnet_id = aws_subnet.public_subnet[0].id

    tags = merge(
        var.common_tags,
        {
            Name = "${var.project_name}-${var.env}"
        },
        var.nat_tags
    )
    depends_on = [ aws_internet_gateway.igw ]
}

resource "aws_route_table" "private_route_table" {
    vpc_id = aws_vpc.roboshop.id

    tags = merge(
        var.common_tags,
        {
            Name = "${var.project_name}-${var.env}-private"
        },
        var.private_route_table_tags
    )

    
}


resource "aws_route" "private_routes" {
    route_table_id = aws_route_table.private_route_table.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id

}

resource "aws_route_table" "database_route_table" {
        vpc_id = aws_vpc.roboshop.id

         tags = merge(

            var.common_tags,
            {
                Name = "${var.project_name}-${var.env}-database"
            },
            var.database_route_table_tags
        )

}

resource "aws_route" "database_routes" {
    route_table_id = aws_route_table.database_route_table.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id =  aws_nat_gateway.nat.id
}

resource "aws_route_table_association" "public" {
        count = length(var.public_subnets_cidr)
        subnet_id = element(aws_subnet.public_subnet[*].id,count.index)
        route_table_id = aws_route_table.public_route_table.id
}


resource "aws_route_table_association" "private" {
        count = length(var.private_subnets_cidr)
        subnet_id = element(aws_subnet.private_subnet[*].id,count.index)
        route_table_id = aws_route_table.private_route_table.id
}


resource "aws_route_table_association" "database" {
        count = length(var.database_subnets_cidr)
        subnet_id = element(aws_subnet.database_subnet[*].id,count.index)
        route_table_id = aws_route_table.database_route_table.id
}

resource "aws_db_subnet_group" "roboshop" {
  name       = "${var.project_name}-${var.env}"
  subnet_ids = aws_subnet.database_subnet[*].id

  tags = merge(
    var.common_tags,
    {
        Name = "${var.project_name}-${var.env}"
    },
    var.db_subnet_group_tags
  )
}

#vpc peering with default vpc

resource "aws_vpc_peering_connection" "foo" {
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
