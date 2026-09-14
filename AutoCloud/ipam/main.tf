# IPAM
resource "aws_vpc_ipam" "main" {

  description = "IPAM"

  dynamic "operating_regions" {
    for_each = var.operating_regions
    content {
      region_name = operating_regions.value
    }
  }

  tags = merge(
    var.default_tags,
    {
      Name = "ipam"
    }
  )
}

# Local Calculations
locals {

  # Region Pools
  region_pools = {
    for index, region in var.operating_regions :
    region => {
      name = "${region}-region-pool"
      cidr = cidrsubnet(var.global_cidr, 4, index + 1)
    }
  }

  # Environment Pools
  environment_pools = {
    for region_index, region in var.operating_regions :
    region => {
      for env_index, env in var.environment_pools :
      env => {
        name = "${region}-${env}-pool"
        cidr = cidrsubnet(
          cidrsubnet(var.global_cidr, 4, region_index + 1),
          2,
          env_index
        )
      }
    }
  }

}

# Global Pool
resource "aws_vpc_ipam_pool" "global" {

  ipam_scope_id  = aws_vpc_ipam.main.private_default_scope_id
  address_family = "ipv4"

  description = var.global_pool_name

  tags = merge(
    var.default_tags,
    {
      Name = var.global_pool_name
    }
  )

}

resource "aws_vpc_ipam_pool_cidr" "global" {

  ipam_pool_id = aws_vpc_ipam_pool.global.id
  cidr         = var.global_cidr

}

# Region Pools
resource "aws_vpc_ipam_pool" "region" {

  for_each = local.region_pools

  ipam_scope_id       = aws_vpc_ipam.main.private_default_scope_id
  address_family      = "ipv4"
  source_ipam_pool_id = aws_vpc_ipam_pool.global.id
  locale              = each.key

  description = each.value.name

  tags = merge(
    var.default_tags,
    {
      Name = each.value.name
    }
  )

}

resource "aws_vpc_ipam_pool_cidr" "region" {

  for_each = local.region_pools

  ipam_pool_id = aws_vpc_ipam_pool.region[each.key].id
  cidr         = each.value.cidr

}

# Environment Pools
resource "aws_vpc_ipam_pool" "environment" {

  for_each = merge([
    for region, envs in local.environment_pools :
    {
      for env, config in envs :
      "${region}-${env}" => {
        region = region
        name   = config.name
        cidr   = config.cidr
      }
    }
  ]...)

  ipam_scope_id       = aws_vpc_ipam.main.private_default_scope_id
  address_family      = "ipv4"
  source_ipam_pool_id = aws_vpc_ipam_pool.region[each.value.region].id
  locale              = each.value.region

  allocation_default_netmask_length = var.vpc_netmask_length
  allocation_min_netmask_length     = var.vpc_netmask_length
  allocation_max_netmask_length     = var.subnet_netmask_length

  description = each.value.name

  tags = merge(
    var.default_tags,
    {
      Name = each.value.name
    }
  )

}

resource "aws_vpc_ipam_pool_cidr" "environment" {

  for_each = {
    for k, v in merge([
      for region, envs in local.environment_pools :
      {
        for env, config in envs :
        "${region}-${env}" => {
          cidr = config.cidr
        }
      }
    ]...) : k => v
  }

  ipam_pool_id = aws_vpc_ipam_pool.environment[each.key].id
  cidr         = each.value.cidr

}
