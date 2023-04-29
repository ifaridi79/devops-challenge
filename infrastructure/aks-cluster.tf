# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

resource "random_pet" "prefix" {}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg-aks" {
  name     = var.resource_group_name
  location = var.location
  tags = {
    environment = "Liatrio-Demo"
  }
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.resource_name
  location            = azurerm_resource_group.rg-aks.location
  resource_group_name = azurerm_resource_group.rg-aks.name
  dns_prefix          = "${random_pet.prefix.id}-k8s"

  default_node_pool {
    name            = "agentpool"
    node_count      = 2
    vm_size         = "Standard_B2s"
    os_disk_size_gb = 30
  }

  service_principal {
    client_id     = var.appId
    client_secret = var.password
  }

  role_based_access_control {
    enabled = true
  }

  tags = {
    environment = "Liatrio-Demo"
  }
}
