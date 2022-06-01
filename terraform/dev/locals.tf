locals {
  environment = "dev"

  hosted_zone_name = "hashiconf.demo"

  vault_endpoint           = "vault-${local.environment}.${local.hosted_zone_name}"
  vault_endpoint_primary   = "vault-${local.environment}-primary.${local.hosted_zone_name}"
  vault_endpoint_secondary = "vault-${local.environment}-dr.${local.hosted_zone_name}"
  vault_address            = "https://${local.vault_endpoint}"
}