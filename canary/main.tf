terraform {
  cloud {
    organization = "fancycorp"

    workspaces {
      tags = ["canary:module:terraform-azure-webserver"]
    }
  }
  # Minimum provider version for OIDC auth
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 2.29.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.25.0"
    }
  }
}

provider "azurerm" {
  features {}
}


module "webserver" {
  source = "../"

  resource_group_tags = {
    Name      = "StrawbTest"
    Owner     = "lucy.davinhart@hashicorp.com"
    Purpose   = "Terraform TFC Demo Org (FancyCorp)"
    TTL       = "24h"
    Terraform = "true"
    Source    = "https://github.com/FancyCorp-Demo/terraform-azure-webserver/tree/main/canary"
    Workspace = terraform.workspace
  }
}
