# Create VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    "Name" = "${var.default_tags.project}-vpc"
  }
  enable_dns_support               = "true"
  enable_dns_hostnames             = "true"
  assign_generated_ipv6_cidr_block = "true"
  instance_tenancy                 = "default"
}

# Public Subnets
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

# Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    "Name" = "${var.default_tags.project}-internet-gateway"
  }
}

# Public Route table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  tags = {
    "Name" = "${var.default_tags.project}-public-route-table"
  }
}

# Make public route table public by associating an internet gateway
resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}

# Add subnet to route table
resource "aws_route_table_association" "public" {
  count          = var.public_subnet_count
  subnet_id      = element(aws_subnet.public.*.id, count.index) # aws_subnet.public.*.id (Lets terraform know there are multiple ids ti be returned)   # element(list, index) (Picks each id of the public subnet cteated) 
  route_table_id = aws_route_table.public_rt.id
}

# Private Subnet
resource "aws_subnet" "private" {
  count      = var.private_subnet_count
  vpc_id     = aws_vpc.main.id
  cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 4, count.index + var.public_subnet_count)
  tags = {
    "Name" = "${var.default_tags.project}-private-${data.aws_availability_zones.availabile.names[count.index]}"
  }
  availability_zone = data.aws_availability_zones.availabile.names[count.index]
}

# Private Route table
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id
  tags = {
    "Name" = "${var.default_tags.project}-private-route-table"
  }
}

# eip for NAT gateway
resource "aws_eip" "nat" {
  vpc = true
  tags = {
    "Name" = "${var.default_tags.project}-nat-eip"
  }
}

# NAT Gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.0.id # get only the first public subnet
  tags = {
    "Name" = "${var.default_tags.project}-nat"
  }
  depends_on = [aws_eip.nat, aws_internet_gateway.gw]
}

# Allow access to the internet from private subnets
resource "aws_route" "private_access" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

# Add subnet to private route table
resource "aws_route_table_association" "private" {
  count          = var.public_subnet_count
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = aws_route_table.private_rt.id
}