


data "aws_availability_zones" "available" {}

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_name
    Env  = var.env
  }
}

resource "aws_subnet" "public_subnet" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.vpc_name}-public-${count.index + 1}"
    Env  = var.env
  }
}

resource "aws_subnet" "private_subnet" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "${var.vpc_name}-private-${count.index + 1}"
    Env  = var.env
    # SSMManaged = "true"
  }
}

resource "aws_subnet" "database_subnet" {
  count = length(var.database_subnet_cidrs)
  vpc_id = aws_vpc.vpc
  cidr_block = var.database_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "${var.vpc_name}-database-${count.index + 1}"
    Env = var.env
    # SSMManaged = "true"
  
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.vpc_name}-igw"
    Env  = var.env
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.vpc_name}-public-rt"
    Env  = var.env
  }
}

resource "aws_route_table_association" "public_rt_assoc" {
  count          = length(aws_subnet.public_subnet)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_eip" "nat_eip" {
  count = length(var.private_subnet_cidrs)

  tags = {
    Name = "${var.vpc_name}-nat-eip-${count.index + 1}"
    Env  = var.env
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  count         = length(var.private_subnet_cidrs)
  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id     = aws_subnet.public_subnet[count.index].id

  tags = {
    Name = "${var.vpc_name}-nat-${count.index + 1}"
    Env  = var.env
  }
}

resource "aws_route_table" "private_route_table" {
  count  = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.vpc.id

  # route {
  #   cidr_block     = "0.0.0.0/0"
  #   nat_gateway_id = aws_nat_gateway.nat_gateway[count.index].id
  # }

  tags = {
    Name = "${var.vpc_name}-private-rt-${count.index + 1}"
    Env  = var.env
  }
}

# resource "aws_route_table_association" "private_rt_assoc" {
#   count          = length(var.private_subnet_cidrs)
#   subnet_id      = aws_subnet.private_subnet[count.index].id
#   route_table_id = aws_route_table.private_route_table[count.index].id
# }

resource "aws_route_table" "database_route_table" {
  count  = length(var.database_subnet_cidrs)
  vpc_id = aws_vpc.vpc.id

  # route {
  #   cidr_block = "0.0.0.0/0"
  #   nat_gateway_id = aws_nat_gateway.nat_gateway[count.index].id
  # }

  tags = {
    Name = "${var.vpc_name}-database-rt-${count.index + 1}"
    Env  = var.env
  }
}

# resource "aws_route_table_association" "database_rt_assoc" {
#   count = length(var.database_subnet_cidrs)
#   subnet_id = aws_subnet.database_subnet[count.index].id
#   route_table_id = aws_route_table.database_route_table[count.index].id
# }
  
