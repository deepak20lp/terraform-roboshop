variable "project_name" {
  
}

variable "env" {
  
}
variable "common_tags" {
  default = {}
}
variable "vpc_tags" {
  default = {}
}

variable "igw_tags" {
  default = {}
}

variable "enable_dns_hostnames" {
  default = true
}

variable "enable_dns_support" {
  default = true
}

variable "cidr_block" {
}

variable "public_subnets_cidr" {
  type = list
  validation {
    condition = length(var.public_subnets_cidr) ==2
    error_message = "Please provide 2 public subnet CIDR"
  }
}
variable "private_subnets_cidr" {
    type = list
    validation {
      condition = length(var.private_subnets_cidr) ==2
      error_message = "Please provide 2 private subnet CIDR"
    }
  
}

variable "database_subnets_cidr" {
    type = list
    validation {
      condition = length(var.database_subnets_cidr) ==2
      error_message = "please provide 2 database CIDR"
    }
}
variable "nat_tags" {
  default = {}
}

variable "public_route_table_tags" {
  default = {}
}
variable "private_route_table_tags" {
    default = {}
}
variable "database_route_table_tags" {
  default = {}
}

variable "db_subnet_group_tags" {
  default = {}
}

variable "requestor_id" {
  
}
variable "is_peering" {
    default = false
}

variable "default_route_table_id" {
}

variable "default_vpc_cidr" {
}

