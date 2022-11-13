resource "aws_vpc" "main" {
  cidr_block                       = var.vpc_cidr
  instance_tenancy                 = "default"
  enable_dns_support               = true
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = true

  tags = {
    "Name" = "${var.default_tags.project}-vpc"
  }
}

# Creation of public Subnets
resource "aws_subnet" "public" {
  count                           = var.public_subnet_count
  vpc_id                          = aws_vpc.main.id
  cidr_block                      = cidrsubnet(aws_vpc.main.cidr_block, 4, count.index)
  ipv6_cidr_block                 = cidrsubnet(aws_vpc.main.ipv6_cidr_block, 8, count.index)
  map_public_ip_on_launch         = true
  assign_ipv6_address_on_creation = true
  tags = {
    "Name" = "${var.default_tags.project}-public-${data.aws_availability_zones.availabile.names[count.index]}"
  }
  availability_zone = data.aws_availability_zones.availabile.names[count.index]
}

# creation of internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    "Name" = "${var.default_tags.project}-internet-gateway"
  }
}

# creation of public route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    "Name" = "${var.default_tags.project}-public-route-table"
  }
}

# Add public subnets to public route table
resource "aws_route_table_association" "public" {
  count          = var.public_subnet_count
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

# create eips for NAT gateways
resource "aws_eip" "nat_eip" {
  count      = var.public_subnet_count
  vpc        = true
  depends_on = [aws_internet_gateway.gw]

  tags = {
    Name = "${var.default_tags.project}-eip-${data.aws_availability_zones.availabile.names[count.index]}"
  }
}

# assign eips to NAT gateways in the public subnet
resource "aws_nat_gateway" "nat" {
  count             = var.public_subnet_count
  allocation_id     = aws_eip.nat_eip[count.index].id
  subnet_id         = aws_subnet.public[count.index].id
  connectivity_type = "public"

  tags = {
    Name = "${var.default_tags.project}-NAT-${data.aws_availability_zones.availabile.names[count.index]}"
  }

  depends_on = [aws_internet_gateway.gw]
}


# Creation of middleware subnets
resource "aws_subnet" "middleware" {
  count                   = var.middleware_subnet_count
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 4, count.index + var.public_subnet_count)
  map_public_ip_on_launch = "false"

  tags = {
    "Name" = "${var.default_tags.project}-middleware-${data.aws_availability_zones.availabile.names[count.index]}"
  }

  availability_zone = data.aws_availability_zones.availabile.names[count.index]
}

# Creation of database subnets
resource "aws_subnet" "database" {
  count                   = var.database_subnet_count
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 4, count.index + var.public_subnet_count + var.middleware_subnet_count)
  map_public_ip_on_launch = "false"

  tags = {
    "Name" = "${var.default_tags.project}-database-${data.aws_availability_zones.availabile.names[count.index]}"
  }

  availability_zone = data.aws_availability_zones.availabile.names[count.index]
}

resource "aws_db_subnet_group" "db_subnet_group" {
  subnet_ids = aws_subnet.database.*.id

  tags = {
    Name = "${var.default_tags.project}-db-subnet-group"
  }
}

# Private Route table
resource "aws_route_table" "private_rt" {
  count = var.middleware_subnet_count >= var.database_subnet_count ? var.middleware_subnet_count : var.database_subnet_count

  vpc_id = aws_vpc.main.id
  tags = {
    "Name" = "${var.default_tags.project}-private-route-table-${data.aws_availability_zones.availabile.names[count.index]}"
  }
}

# Allow access to the internet from private subnets
resource "aws_route" "private_rt_web_access" {
  count = var.middleware_subnet_count >= var.database_subnet_count ? var.middleware_subnet_count : var.database_subnet_count

  route_table_id         = aws_route_table.private_rt[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat[count.index].id # issue when private subnets are more than public
  #nat_gateway_id = aws_nat_gateway.nat[(count.index >= var.public_subnet_count ? 0 : count.index).index].id 
}

# Add middleware subnets to private route table
resource "aws_route_table_association" "middleware" {
  count = var.middleware_subnet_count

  subnet_id      = aws_subnet.middleware[count.index].id
  route_table_id = aws_route_table.private_rt[count.index].id
}

# Add database subnets to private route table
resource "aws_route_table_association" "database" {
  count = var.database_subnet_count

  subnet_id      = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.private_rt[count.index].id
}