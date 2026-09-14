data "aws_subnet" "this" {
  id = var.subnet_id
}

data "aws_ami" "selected" {
  count = trimspace(var.ami_id) != "" ? 1 : 0

  include_deprecated = true

  filter {
    name   = "image-id"
    values = [trimspace(var.ami_id)]
  }
}

data "aws_ami" "default" {
  count = trimspace(var.ami_id) == "" ? 1 : 0

  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

locals {
  selected_ami_id      = trimspace(var.ami_id) != "" ? data.aws_ami.selected[0].id : data.aws_ami.default[0].id
  ami_platform         = lower(trimspace(try(data.aws_ami.selected[0].platform, data.aws_ami.default[0].platform, "")))
  ami_platform_details = lower(trimspace(try(data.aws_ami.selected[0].platform_details, data.aws_ami.default[0].platform_details, "")))
  ami_name             = lower(trimspace(try(data.aws_ami.selected[0].name, data.aws_ami.default[0].name, "")))
  ami_description      = lower(trimspace(try(data.aws_ami.selected[0].description, data.aws_ami.default[0].description, "")))
  ami_metadata         = join(" ", compact([local.ami_platform_details, local.ami_name, local.ami_description]))
  ami_is_windows       = local.ami_platform == "windows" || length(regexall("windows", local.ami_metadata)) > 0

  instance_id = var.create_security_group ? module.managed_security_group[0].instance_id : module.existing_security_group[0].instance_id
  public_ip   = var.create_security_group ? module.managed_security_group[0].public_ip : module.existing_security_group[0].public_ip
  elastic_ip  = var.create_security_group ? module.managed_security_group[0].elastic_ip : module.existing_security_group[0].elastic_ip
  private_ip  = var.create_security_group ? module.managed_security_group[0].private_ip : module.existing_security_group[0].private_ip

  instance_security_group_ids = var.create_security_group ? module.managed_security_group[0].security_group_ids : module.existing_security_group[0].security_group_ids
}

module "managed_security_group" {
  count  = var.create_security_group ? 1 : 0
  source = "./managed-security-group"

  instance_name  = var.instance_name
  ami_id         = local.selected_ami_id
  ami_is_windows = local.ami_is_windows
  instance_type  = var.instance_type
  key_name       = var.key_name
  subnet_id      = data.aws_subnet.this.id
  vpc_id         = var.vpc_id
  allowed_cidr   = var.allowed_cidr

  monitoring                  = var.monitoring
  user_data                   = var.user_data
  root_volume_size            = var.root_volume_size
  root_volume_type            = var.root_volume_type
  associate_public_ip_address = var.associate_public_ip_address
  use_elastic_ip              = var.use_elastic_ip

  tags = var.tags
}

module "existing_security_group" {
  count  = var.create_security_group ? 0 : 1
  source = "./existing-security-group"

  instance_name      = var.instance_name
  ami_id             = local.selected_ami_id
  ami_is_windows     = local.ami_is_windows
  instance_type      = var.instance_type
  key_name           = var.key_name
  subnet_id          = data.aws_subnet.this.id
  security_group_ids = var.security_group_ids

  monitoring                  = var.monitoring
  user_data                   = var.user_data
  root_volume_size            = var.root_volume_size
  root_volume_type            = var.root_volume_type
  associate_public_ip_address = var.associate_public_ip_address
  use_elastic_ip              = var.use_elastic_ip

  tags = var.tags
}
