# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "ARM_SUBSCRIPTION_ID" {
  description = "Azure Subscription ID"
  sensitive   = true
}

variable "ARM_TENANT_ID" {
  description = "Azure Tenant ID"
  sensitive   = true
}

variable "ARM_CLIENT_ID" {
  description = "Azure Kubernetes Service Cluster service principal"
  sensitive   = true
}

variable "ARM_CLIENT_SECRET" {
  description = "Azure Kubernetes Service Cluster password"
  sensitive   = true
}

variable "CLUSTER_RESOURCE_GROUP" {
  description = "Azure Resource Group name for Terraform"
}

variable "LOCATION" {
  description = "Azure Region"
}

variable "CLUSTER_NAME" {
  description = "Azure Resource by Terraform"
}







