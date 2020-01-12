provider "aws" {
  region = var.aws_region
  profile = var.aws_profile

  assume_role {
    role_arn = var.deployer_role_arn
  }
}

module "login_server" {
  source = "../../modules/webserver"

  aws_vpc       = var.aws_vpc
  dns_zone      = var.dns_zone
  dns_subdomain = "login"
  server_name   = "auth"

  encrypted_db_root_password = var.auth_root_password
  db_instance   = "db.m5.large"
  tags = {
    "Type" = "Security",
    "automation" = "Terraform"
    "teir" = "frontend"
  }
}

module "messaging_server" {
  source = "../../modules/webserver"

  aws_vpc       = var.aws_vpc
  dns_zone      = var.dns_zone
  dns_subdomain = "messaging"
  is_private    = true
  server_name   = "messaging"
  instance_type = "r5.large"

  encrypted_db_root_password = var.messaging_password
  tags = {
    "Type" = "Internal",
    "automation" = "Terraform",
    "teir" = "backend"
  }
}
