terraform {
  backend "s3" {
    encrypt = "true"
    bucket  = "bucket-for-hashiconf-2022"
    key     = "iac-vault-dr/terraform/prod.tfstate"
    region  = "us-east-1"
  }
}