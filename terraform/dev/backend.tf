terraform {
  backend "s3" {
    encrypt = "true"
    bucket  = "bucket-for-hashiconf-2022"
    key     = "iac-vault-dr/terraform/dev.tfstate"
    region  = "us-east-1"
  }
}