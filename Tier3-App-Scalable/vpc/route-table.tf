resource "aws_internet_gateway" "default-igw" {
  vpc_id = var.no-vpc == true ? var.existing_vpc_id : aws_vpc.aws_vpc.id
  tags   = merge({ Name = "${var.vpc_name}-internet-gateway" }, var.common_tags)
}

resource "aws_route_table" "public-route-table" {
  vpc_id = var.no-vpc == true ? var.existing_vpc_id : aws_vpc.aws_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.default-igw.id
  }

  tags = merge({ Name = "${var.vpc_name}-public-route-table" }, var.common_tags)
}

resource "aws_route_table" "private-route-table" {
  vpc_id = var.no-vpc == true ? var.existing_vpc_id : aws_vpc.aws_vpc.id
  tags   = merge({ Name = "${var.vpc_name}-private-route-table" }, var.common_tags)

  # only enable this when you want nat gateway.
  # route {
  #   cidr_block     = "0.0.0.0/0"
  #   nat_gateway_id = aws_nat_gateway.this.id
  # }
}

resource "aws_route_table_association" "public-RTA" {
  count          = length(var.public_cidr_block)
  subnet_id      = element(aws_subnet.public-subnets.*.id, count.index)
  route_table_id = aws_route_table.public-route-table.id
}

resource "aws_route_table_association" "private-RTA" {
  count          = length(var.private_cidr_block)
  subnet_id      = element(aws_subnet.private-subnets.*.id, count.index)
  route_table_id = aws_route_table.private-route-table.id
}
