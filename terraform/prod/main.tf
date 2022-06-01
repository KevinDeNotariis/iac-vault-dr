module "lambdas" {
  source = "github.com/KevinDeNotariis/terraform-vault-dr//terraform?ref=v1.0.3"

  environment = local.environment
  identifier  = random_id.id.hex

  vault_endpoint           = local.vault_endpoint
  vault_endpoint_primary   = local.vault_endpoint_primary
  vault_endpoint_secondary = local.vault_endpoint_secondary
  hosted_zone_name         = local.hosted_zone_name
}

resource "random_id" "id" {
  byte_length = 4
}