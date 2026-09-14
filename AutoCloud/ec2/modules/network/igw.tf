resource "aws_internet_gateway" "this" {
  count = var.create_subnet && var.public_access_enabled ? 1 : 0

  vpc_id = local.vpc_id

  tags = merge(var.tags, {
    Name = "${var.instance_name}-igw"
  })
}
