locals {
  environment = "prod"

  hosted_zone_name = "hashiconf.demo"

  vault_endpoint           = "vault-dev.${local.hosted_zone_name}"
  vault_endpoint_primary   = "vault-dev-primary.${local.hosted_zone_name}"
  vault_endpoint_secondary = "vault-dev-dr.${local.hosted_zone_name}"
  vault_address            = "https://${local.vault_endpoint}"
}