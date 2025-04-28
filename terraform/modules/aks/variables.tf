variable "resource_group_name" {
  description = "The name of the resource group in which to create the AKS cluster"
  type        = string
}

variable "cluster_name" {
  description = "The name of the AKS cluster"
  type        = string
}

variable "kubernetes_version" {
  description = "The Kubernetes version to use"
  type        = string
}

variable "location" {
  description = "The Azure region to deploy the AKS cluster"
  type        = string
}

variable "node_count" {
  description = "The initial node count for the default node pool"
  type        = number
  default     = 3
}

variable "vm_size" {
  description = "The VM size for the nodes in the default node pool"
  type        = string
  default     = "Standard_D2s_v3"
}

variable "tags" {
  description = "Tags to apply to the AKS cluster"
  type        = map(string)
  default     = {}
}