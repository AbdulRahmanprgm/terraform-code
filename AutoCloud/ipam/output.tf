output "global_pool" {
  value = {
    name = var.global_pool_name
    cidr = var.global_cidr
    id   = aws_vpc_ipam_pool.global.id
  }
}

output "region_pools" {
  value = {
    for region, pool in aws_vpc_ipam_pool.region :
    local.region_pools[region].name => {
      cidr = local.region_pools[region].cidr
      id   = pool.id
    }
  }
}

output "environment_pools" {

  value = {
    for key, pool in aws_vpc_ipam_pool.environment :
    pool.description => {
      cidr = aws_vpc_ipam_pool_cidr.environment[key].cidr
      id   = pool.id
    }
  }

}