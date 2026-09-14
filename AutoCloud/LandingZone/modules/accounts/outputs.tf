output "account_ids" {
  description = "Map of landing-zone account keys to the AWS account IDs created by this module."
  value = {
    for account_key, account in aws_organizations_account.this :
    account_key => account.id
  }
}
