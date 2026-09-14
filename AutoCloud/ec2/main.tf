locals {
  selected_user_data_file = trimspace(var.user_data_file)
  selected_user_data      = local.selected_user_data_file != "" ? file(local.selected_user_data_file) : null
  create_key_pair         = trimspace(var.public_key_path) != ""
  public_access_enabled   = var.associate_public_ip_address || var.use_elastic_ip
}

###############################################################################
# Network — VPC, Subnet, IGW, Flow Logs
###############################################################################
module "network" {
  source = "./modules/network"

  create_vpc    = var.create_vpc
  create_subnet = var.create_subnet

  subnet_id             = var.subnet_id
  vpc_cidr              = var.vpc_cidr
  subnet_cidr           = var.subnet_cidr
  availability_zone     = var.availability_zone
  public_access_enabled = local.public_access_enabled
  instance_name         = var.instance_name
  aws_region            = var.aws_region
  tags                  = var.default_tags
}

###############################################################################
# EC2 Instance
###############################################################################
module "ec2_instance" {
  source = "./modules/ec2-instance"

  instance_name = var.instance_name
  ami_id        = var.ami_id
  instance_type = var.instance_type
  key_name      = local.create_key_pair ? module.key_pair[0].key_name : null

  subnet_id = module.network.subnet_id

  create_security_group = var.create_security_group
  vpc_id                = module.network.vpc_id
  security_group_ids    = var.security_group_ids
  allowed_cidr          = var.allowed_cidr

  monitoring                  = var.monitoring
  user_data                   = local.selected_user_data
  root_volume_size            = var.root_volume_size
  root_volume_type            = var.root_volume_type
  associate_public_ip_address = var.associate_public_ip_address
  use_elastic_ip              = var.use_elastic_ip

  tags = var.default_tags
}

###############################################################################
# Key Pair
###############################################################################
module "key_pair" {
  count  = local.create_key_pair ? 1 : 0
  source = "./modules/key-pair"

  key_name   = "${var.instance_name}-key"
  public_key = file(trimspace(var.public_key_path))
  tags       = var.default_tags
}
