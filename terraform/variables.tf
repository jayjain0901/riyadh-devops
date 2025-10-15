variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-devops-k8s-demo"
}



variable "location" {
  description = "Azure region"
  type        = string
  default     = "Central US"
}

variable "cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
  default     = "aks-devops-demo"
}

variable "acr_name" {
  description = "Name of the Azure Container Registry"
  type        = string
  default     = "acrdevopsk8sdemo"
}

variable "node_count" {
  description = "Number of nodes in the default node pool"
  type        = number
  default     = 1
}



variable "node_vm_size" {
  description = "VM size for the default node pool"
  type        = string
  default     = "Standard_D2_v3"
}