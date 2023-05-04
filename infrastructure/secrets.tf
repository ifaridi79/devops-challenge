variable "appId" {
  description = "Azure Kubernetes Service Cluster service principal"
  type = string
  sensitive = true
}

variable "password" {
  description = "Azure Kubernetes Service Cluster password"
  type = string
  sensitive = true
}
