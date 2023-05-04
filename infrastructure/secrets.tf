variable "ARM_CLIENT_ID" {
  description = "Azure Kubernetes Service Cluster service principal"
  sensitive   = true
}

variable "ARM_CLIENT_SECRET" {
  description = "Azure Kubernetes Service Cluster password"
  sensitive   = true
}
