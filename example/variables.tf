locals {
  env = {
    dev-apps = {
      cluster_name        = "dev-apps"
      alb_certificate_arn = "arn:aws:acm:ap-southeast-2:REDACTED:certificate/REDACTED"
      cf_certificate_arn  = "arn:aws:acm:us-east-1:REDACTED:certificate/REDACTED"
      vpc_id              = "vpc-REDACTED"
      private_subnet_ids  = "subnet-REDACTED,subnet-REDACTED"
      public_subnet_ids   = "subnet-REDACTED,subnet-REDACTED"
      secure_subnet_ids   = "subnet-REDACTED,subnet-REDACTED"
      db_subnet           = "REDACTED"
      db_name             = "dev-apps"
      db_retention        = 5
    }

    prod-apps = {
      cluster_name        = "prod-apps"
      alb_certificate_arn = "arn:aws:acm:ap-southeast-2:REDACTED:certificate/REDACTED"
      cf_certificate_arn  = "arn:aws:acm:us-east-1:REDACTED:certificate/REDACTED"
      vpc_id              = "vpc-REDACTED"
      private_subnet_ids  = "subnet-REDACTED,subnet-REDACTED"
      public_subnet_ids   = "subnet-REDACTED,subnet-REDACTED"
      secure_subnet_ids   = "subnet-REDACTED,subnet-REDACTED"
      db_subnet           = "REDACTED"
      db_name             = "prod-apps"
      db_retention        = 30
    }
  }

  workspace = local.env[terraform.workspace]
}
