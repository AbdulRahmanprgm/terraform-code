resource "aws_route_table" "public" {
  count = var.create_subnet && var.public_access_enabled ? 1 : 0

  vpc_id = local.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this[0].id
  }

  tags = merge(var.tags, {
    Name = "${var.instance_name}-public-rt"
  })
}

resource "aws_route_table_association" "public" {
  count = var.create_subnet && var.public_access_enabled ? 1 : 0

  subnet_id      = aws_subnet.this[0].id
  route_table_id = aws_route_table.public[0].id
}
