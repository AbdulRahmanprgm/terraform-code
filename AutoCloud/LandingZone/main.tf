module "organizational_units" {
  source = "./modules/organizational_units"

  organizational_units = var.organizational_units
}

module "accounts" {
  source = "./modules/accounts"

  accounts          = var.accounts
  close_on_deletion = var.close_on_deletion
  ou_ids            = module.organizational_units.ou_ids
}

module "scp" {
  source = "./modules/scp"

  account_ids              = module.accounts.account_ids
  ou_ids                   = module.organizational_units.ou_ids
  service_control_policies = local.active_service_control_policies
}
