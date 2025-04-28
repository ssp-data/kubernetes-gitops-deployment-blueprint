resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.cluster_name
  kubernetes_version  = var.kubernetes_version

  default_node_pool {
    name       = "default"
    node_count = var.node_count
    vm_size    = var.vm_size
    os_disk_size_gb = 128
    enable_auto_scaling = true
    min_count   = var.node_count
    max_count   = var.node_count * 2
  }

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

# Output the kubeconfig
output "kube_config" {
  value     = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive = true
}

# Output the cluster host
output "host" {
  value = azurerm_kubernetes_cluster.aks.kube_config.0.host
}

# Output the cluster resource id
output "id" {
  value = azurerm_kubernetes_cluster.aks.id
}