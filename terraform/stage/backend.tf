terraform {
  backend "s3" {
    encrypt = "true"
    bucket  = "bucket-for-hashiconf-2022"
    key     = "iac-vault-dr/terraform/stage.tfstate"
    region  = "us-east-1"
  }
}