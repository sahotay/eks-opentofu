provider "aws" {
  region = local.region
  assume_role {
    role_arn = var.admin_role
  }
}