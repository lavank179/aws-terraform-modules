# Elastic IP for NAT Gateway
resource "aws_eip" "nat" {
  count = var.enable_nat_gate ? 1 : 0
  domain = "vpc"
}

# NAT Gateway in Public Subnet
resource "aws_nat_gateway" "this" {
  count = var.enable_nat_gate ? 1 : 0
  allocation_id = aws_eip.nat[0].id
  subnet_id     = aws_subnet.public-subnets[0].id  # attach NAT to a public subnet
  depends_on = [ aws_subnet.public-subnets ]
}

# # Route Table for private subnets
# resource "aws_route_table" "private" {
#   count = var.enable_nat_gate ? 1 : 0
#   vpc_id = var.no-vpc == true ? var.existing_vpc_id : aws_vpc.aws_vpc.id

#   route {
#     cidr_block     = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.this[0].id
#   }
# }

# # Associate route table to private subnets
# resource "aws_route_table_association" "private_subnet_a" {
#   count = var.enable_nat_gate ? 1 : 0
#   subnet_id      = aws_subnet.private-subnets[0].id
#   route_table_id = aws_route_table.private-RTA.id
# }

# resource "aws_route_table_association" "private_subnet_b" {
#   count = var.enable_nat_gate ? 1 : 0
#   subnet_id      = aws_subnet.private-subnets[1].id
#   route_table_id = aws_route_table.private-RTA.id
# }
