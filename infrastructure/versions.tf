# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.66.0"
    }
  }

  # Update this block with the location of your terraform state file
  backend "azurerm" {
    resource_group_name  = "terraform-github-actions-state-rg"
    storage_account_name = "tfstaccount"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }

  required_version = ">= 0.14"
}

