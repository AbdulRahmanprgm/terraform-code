locals {
  # ============================================================
  # Active values from terraform.tfvars
  # ============================================================

  active_account_keys = keys(var.accounts)

  # ============================================================
  # Account governance model
  # These entries document each landing-zone account's purpose,
  # expected workload types, restricted actions, and attached SCPs.
  # ============================================================

  network_allowed_actions = [
    "ec2:Describe*",
    "ec2:Get*",
    "ec2:CreateTags",
    "ec2:DeleteTags",
    "ec2:*Vpc*",
    "ec2:*Subnet*",
    "ec2:*RouteTable*",
    "ec2:*Route*",
    "ec2:*InternetGateway*",
    "ec2:*NatGateway*",
    "ec2:*EgressOnlyInternetGateway*",
    "ec2:*DhcpOptions*",
    "ec2:*NetworkAcl*",
    "ec2:*NetworkAclEntry*",
    "ec2:*SecurityGroup*",
    "ec2:*Address*",
    "ec2:*NetworkInterface*",
    "ec2:*PrefixList*",
    "ec2:*FlowLog*",
    "ec2:*TransitGateway*",
    "ec2:*TransitGatewayVpcAttachment*",
    "ec2:*TransitGatewayRouteTable*",
    "ec2:*TransitGatewayRoute*",
    "ec2:*VpnGateway*",
    "ec2:*VpnConnection*",
    "ec2:*CustomerGateway*",
    "ec2:*VpcPeeringConnection*",
    "ec2:*VpcEndpoint*",
    "ec2:*VpcEndpointService*",
    "ec2:*VpcEndpointConnection*",
    "ec2:*VpcEndpointServiceConfiguration*",
    "route53:*",
    "route53resolver:*",
    "elasticloadbalancing:*",
    "ram:*",
    "directconnect:*",
    "network-firewall:*",
    "globalaccelerator:*",
    "apigateway:*",
    "networkmanager:*",
    "cloudwatch:*",
    "logs:*",
    "events:*",
    "iam:CreateRole",
    "iam:DeleteRole",
    "iam:UpdateRole",
    "iam:GetRole",
    "iam:ListRoles",
    "iam:AttachRolePolicy",
    "iam:DetachRolePolicy",
    "iam:PutRolePolicy",
    "iam:DeleteRolePolicy",
    "s3:*",
    "s3:CreateBucket",
    "iam:GetRolePolicy",
    "iam:ListRolePolicies",
    "iam:ListAttachedRolePolicies",
    "iam:CreateServiceLinkedRole",
    "iam:DeleteServiceLinkedRole",
    "iam:GetServiceLinkedRoleDeletionStatus",
    "iam:PassRole",
    "iam:Get*",
    "iam:List*",
    "sts:GetCallerIdentity",
    "sts:AssumeRole",
    "sts:TagSession",
    "sts:DecodeAuthorizationMessage",
    "tag:Get*",
    "tag:TagResources",
    "tag:UntagResources"
  ]

  log_archive_allowed_actions = [
    "s3:*",
    "cloudtrail:*",
    "config:*",
    "logs:*",
    "kms:*",
    "iam:Get*",
    "iam:List*",
    "sts:GetCallerIdentity",
    "tag:*"
  ]

  audit_allowed_actions = [
    "securityhub:*",
    "guardduty:*",
    "detective:*",
    "inspector2:*",
    "access-analyzer:*",
    "config:*",
    "cloudtrail:LookupEvents",
    "logs:Get*",
    "logs:Describe*",
    "iam:Get*",
    "iam:List*",
    "organizations:Describe*",
    "organizations:List*",
    "sts:GetCallerIdentity",
    "tag:*"
  ]

  backup_allowed_actions = [
    "backup:*",
    "backup-storage:*",
    "kms:*",
    "s3:Get*",
    "s3:List*",
    "ec2:Describe*",
    "rds:Describe*",
    "dynamodb:Describe*",
    "iam:Get*",
    "iam:List*",
    "iam:PassRole",
    "sts:GetCallerIdentity",
    "tag:*"
  ]

  shared_services_allowed_actions = [
    "ec2:*",
    "s3:*",
    "ecr:*",
    "codebuild:*",
    "codepipeline:*",
    "codedeploy:*",
    "cloudformation:*",
    "ssm:*",
    "secretsmanager:*",
    "kms:*",
    "cloudwatch:*",
    "logs:*",
    "events:*",
    "iam:Get*",
    "iam:List*",
    "iam:CreateRole",
    "iam:PutRolePolicy",
    "iam:AttachRolePolicy",
    "iam:PassRole",
    "sts:*",
    "tag:*"
  ]

  development_allowed_actions = [
    "ec2:*",
    "s3:*",
    "rds:*",
    "lambda:*",
    "apigateway:*",
    "dynamodb:*",
    "ecs:*",
    "ecr:*",
    "cloudformation:*",
    "ssm:*",
    "secretsmanager:*",
    "kms:*",
    "cloudwatch:*",
    "logs:*",
    "events:*",
    "iam:Get*",
    "iam:List*",
    "iam:PassRole",
    "sts:*",
    "tag:*"
  ]

  test_allowed_actions = [
    "ec2:*",
    "s3:*",
    "rds:*",
    "lambda:*",
    "apigateway:*",
    "dynamodb:*",
    "ecs:*",
    "ecr:*",
    "cloudformation:*",
    "ssm:*",
    "secretsmanager:*",
    "kms:*",
    "cloudwatch:*",
    "logs:*",
    "events:*",
    "iam:Get*",
    "iam:List*",
    "iam:PassRole",
    "sts:*",
    "tag:*"
  ]

  production_allowed_actions = [
    "ec2:*",
    "s3:*",
    "rds:*",
    "lambda:*",
    "apigateway:*",
    "dynamodb:*",
    "ecs:*",
    "ecr:*",
    "elasticloadbalancing:*",
    "autoscaling:*",
    "cloudformation:*",
    "ssm:*",
    "secretsmanager:*",
    "kms:*",
    "cloudwatch:*",
    "logs:*",
    "events:*",
    "backup:*",
    "iam:Get*",
    "iam:List*",
    "iam:PassRole",
    "sts:*",
    "tag:*"
  ]

  sandbox_allowed_actions = [
    "ec2:*",
    "s3:*",
    "lambda:*",
    "apigateway:*",
    "dynamodb:*",
    "cloudformation:*",
    "ssm:*",
    "cloudwatch:*",
    "logs:*",
    "iam:Get*",
    "iam:List*",
    "iam:PassRole",
    "sts:*",
    "tag:*"
  ]

  # ============================================================
  # SCP Catalog
  # SCPs are attached only to active accounts present in
  # terraform.tfvars.
  # ============================================================

  scp_policies = {
    log_archive_allow_list = {
      name        = "LogArchiveAllowList"
      description = "Deny everything except approved actions for the Log Archive account"
      policy_file = "account-allow-list.json"

      substitutions = {
        "{{allowed_actions}}" = jsonencode(local.log_archive_allowed_actions)
      }

      target_accounts = contains(local.active_account_keys, "log_archive") ? ["log_archive"] : []
      target_ous      = []
    }

    log_archive_protect_logs = {
      name        = "LogArchiveProtectLogs"
      description = "Protect centralized logging buckets and logging services in the Log Archive account"
      policy_file = "log-archive-protect-logs.json"

      substitutions = {}

      target_accounts = contains(local.active_account_keys, "log_archive") ? ["log_archive"] : []
      target_ous      = []
    }

    audit_security_guardrails = {
      name        = "AuditSecurityGuardrails"
      description = "Protect findings and security tooling in the Audit account"
      policy_file = "audit-security-guardrails.json"

      substitutions = {}

      target_accounts = contains(local.active_account_keys, "audit") ? ["audit"] : []
      target_ous      = []
    }

    audit_allow_list = {
      name        = "AuditAllowList"
      description = "Deny everything except approved actions for the Audit account"
      policy_file = "account-allow-list.json"

      substitutions = {
        "{{allowed_actions}}" = jsonencode(local.audit_allowed_actions)
      }

      target_accounts = contains(local.active_account_keys, "audit") ? ["audit"] : []
      target_ous      = []
    }

    network_allow_list = {
      name        = "NetworkAllowList"
      description = "Deny everything except approved network services"
      policy_file = "network-allow-list.json"

      substitutions = {
        "{{network_allowed_actions}}" = jsonencode(local.network_allowed_actions)
      }

      target_accounts = contains(local.active_account_keys, "network") ? ["network"] : []
      target_ous      = []
    }

    backup_allow_list = {
      name        = "BackupAllowList"
      description = "Deny everything except approved actions for the Backup account"
      policy_file = "account-allow-list.json"

      substitutions = {
        "{{allowed_actions}}" = jsonencode(local.backup_allowed_actions)
      }

      target_accounts = contains(local.active_account_keys, "backup") ? ["backup"] : []
      target_ous      = []
    }

    backup_protection = {
      name        = "BackupProtection"
      description = "Protect backup vaults, plans, recovery points, and vault lock settings"
      policy_file = "backup-protection.json"

      substitutions = {}

      target_accounts = [
        for account_key in ["backup", "production"] :
        account_key
        if contains(local.active_account_keys, account_key)
      ]
      target_ous = []
    }

    deny_disable_security = {
      name        = "DenyDisableSecurityServices"
      description = "Protect baseline security services such as CloudTrail, Config, GuardDuty, and Security Hub"
      policy_file = "deny-disable-security.json"

      substitutions = {}

      target_accounts = [
        for account_key in ["log_archive", "audit", "shared_services", "development", "test", "production", "sandbox"] :
        account_key
        if contains(local.active_account_keys, account_key)
      ]
      target_ous = []
    }

    shared_services_allow_list = {
      name        = "SharedServicesAllowList"
      description = "Deny everything except approved actions for the Shared Services account"
      policy_file = "account-allow-list.json"

      substitutions = {
        "{{allowed_actions}}" = jsonencode(local.shared_services_allowed_actions)
      }

      target_accounts = contains(local.active_account_keys, "shared_services") ? ["shared_services"] : []
      target_ous      = []
    }

    deny_leave_org = {
      name        = "prevent-leaving-org"
      description = "Prevent member accounts from leaving the AWS Organization"
      policy_file = "deny-leave-org.json"

      substitutions = {}

      target_accounts = [
        for account_key in ["audit", "shared_services", "development", "test", "production", "sandbox"] :
        account_key
        if contains(local.active_account_keys, account_key)
      ]
      target_ous = []
    }

    development_allow_list = {
      name        = "DevelopmentAllowList"
      description = "Deny everything except approved actions for the Development account"
      policy_file = "account-allow-list.json"

      substitutions = {
        "{{allowed_actions}}" = jsonencode(local.development_allowed_actions)
      }

      target_accounts = contains(local.active_account_keys, "development") ? ["development"] : []
      target_ous      = []
    }

    test_allow_list = {
      name        = "TestAllowList"
      description = "Deny everything except approved actions for the Test account"
      policy_file = "account-allow-list.json"

      substitutions = {
        "{{allowed_actions}}" = jsonencode(local.test_allowed_actions)
      }

      target_accounts = contains(local.active_account_keys, "test") ? ["test"] : []
      target_ous      = []
    }

    dev_test_cost_controls = {
      name        = "DevTestCostControls"
      description = "Apply moderate cost controls for Development and Test accounts"
      policy_file = "dev-test-cost-controls.json"

      substitutions = {}

      target_accounts = [
        for account_key in ["development", "test"] :
        account_key
        if contains(local.active_account_keys, account_key)
      ]
      target_ous = []
    }

    production_observability_guardrails = {
      name        = "ProductionObservabilityGuardrails"
      description = "Protect production logging, alarms, and eventing controls"
      policy_file = "production-observability-guardrails.json"

      substitutions = {}

      target_accounts = contains(local.active_account_keys, "production") ? ["production"] : []
      target_ous      = []
    }

    production_allow_list = {
      name        = "ProductionAllowList"
      description = "Deny everything except approved actions for the Production account"
      policy_file = "account-allow-list.json"

      substitutions = {
        "{{allowed_actions}}" = jsonencode(local.production_allowed_actions)
      }

      target_accounts = contains(local.active_account_keys, "production") ? ["production"] : []
      target_ous      = []
    }

    sandbox_cost_controls = {
      name        = "SandboxCostControls"
      description = "Apply strict cost controls for Sandbox workloads"
      policy_file = "sandbox-cost-controls.json"

      substitutions = {}

      target_accounts = contains(local.active_account_keys, "sandbox") ? ["sandbox"] : []
      target_ous      = []
    }

    sandbox_allow_list = {
      name        = "SandboxAllowList"
      description = "Deny everything except approved actions for the Sandbox account"
      policy_file = "account-allow-list.json"

      substitutions = {
        "{{allowed_actions}}" = jsonencode(local.sandbox_allowed_actions)
      }

      target_accounts = contains(local.active_account_keys, "sandbox") ? ["sandbox"] : []
      target_ous      = []
    }

    restrict_regions = {
      name        = "RestrictRegions"
      description = "Allow resource creation only in approved AWS regions"
      policy_file = "restrict-regions.json"

      substitutions = {
        "{{allowed_regions}}" = jsonencode(var.allowed_regions)
      }

      target_accounts = local.active_account_keys
      target_ous      = []
    }
  }

  active_service_control_policies = {
    for policy_key, policy in local.scp_policies :
    policy_key => merge(policy, {
      target_accounts = [
        for account_key in try(policy.target_accounts, []) :
        account_key
        if contains(local.active_account_keys, account_key)
      ]
      target_ous = [
        for ou_name in try(policy.target_ous, []) :
        ou_name
      ]
    })
    if length(try(policy.target_ous, [])) > 0 || length([
      for account_key in try(policy.target_accounts, []) :
      account_key
      if contains(local.active_account_keys, account_key)
    ]) > 0
  }
}
