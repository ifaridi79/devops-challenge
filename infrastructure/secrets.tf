variable "appId" {
  description = "Azure Kubernetes Service Cluster service principal"
  sensitive   = true
}

variable "password" {
  description = "Azure Kubernetes Service Cluster password"
  sensitive   = true
}
