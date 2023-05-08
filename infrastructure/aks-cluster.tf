# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

resource "random_pet" "prefix" {}

provider "azurerm" {
  features {}

}

resource "azurerm_resource_group" "rg-aks" {
  name     = var.CLUSTER_RESOURCE_GROUP
  location = var.LOCATION
  tags = {
    environment = "Liatrio-Demo"
  }
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.CLUSTER_NAME
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
    client_id     = var.ARM_CLIENT_ID
    client_secret = var.ARM_CLIENT_SECRET
  }

  role_based_access_control {
    enabled = true
  }

  tags = {
    environment = "Liatrio-Demo"
  }
}
