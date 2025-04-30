resource "aws_subnet" "public-subnets" {
  count             = length(var.public_cidr_block)
  vpc_id            = var.no-vpc == true ? var.existing_vpc_id : aws_vpc.aws_vpc.id
  cidr_block        = element(var.public_cidr_block, count.index + 1)
  availability_zone = element(var.azs_pub, count.index)

  tags = merge(
    { Name = "${var.vpc_name}-public-subnet-${count.index + 1}" },
    var.common_tags
  )
}

resource "aws_subnet" "private-subnets" {
  count             = length(var.private_cidr_block)
  vpc_id            = var.no-vpc == true ? var.existing_vpc_id : aws_vpc.aws_vpc.id
  cidr_block        = element(var.private_cidr_block, count.index + 1)
  availability_zone = element(var.azs_pri, count.index)

  tags = merge(
    { Name = "${var.vpc_name}-private-subnet-${count.index + 1}" },
    var.common_tags
  )
}
