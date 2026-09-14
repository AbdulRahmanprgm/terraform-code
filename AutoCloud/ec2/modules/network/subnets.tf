data "aws_subnet" "existing" {
  count = var.create_vpc ? 0 : 1

  id = var.subnet_id
}

locals {
  vpc_id    = var.create_vpc ? values(aws_vpc.this)[0].id : data.aws_subnet.existing[0].vpc_id
  subnet_id = var.create_subnet ? aws_subnet.this[0].id : data.aws_subnet.existing[0].id
}

resource "aws_subnet" "this" {
  count = var.create_subnet ? 1 : 0

  vpc_id = local.vpc_id

  cidr_block              = var.subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = false

  tags = merge(var.tags, {
    Name = "${var.instance_name}-subnet"
  })
}
