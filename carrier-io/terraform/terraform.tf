terraform {
    backend "s3" {
      bucket                = "folio-terraform"
      workspace_key_prefix  = "carrier"
      key                   = "carrier/terraform.tfstate"
      region                = "us-east-1"
      dynamodb_table        = "folio-terraform-lock"
    }
}