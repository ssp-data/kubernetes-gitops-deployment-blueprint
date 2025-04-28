provider "azurerm" {
  features {}
}

module "aks_cluster" {
  source = "../../modules/aks"
  
  resource_group_name     = "data-platform-dev-rg"
  cluster_name            = "data-platform-dev"
  kubernetes_version      = "1.26.6"
  location                = "westeurope"
  node_count              = 3
  vm_size                 = "Standard_D4s_v3"
  
  tags = {
    environment = "dev"
    application = "data-platform"
  }
}

module "postgresql" {
  source = "../../modules/postgresql"
  
  resource_group_name = "data-platform-dev-rg"
  server_name         = "data-platform-dev-pg"
  location            = "westeurope"
  sku_name            = "GP_Standard_D4s_v3"
  storage_mb          = 102400
  
  administrator_login          = "postgres"
  administrator_login_password = var.db_admin_password
  
  databases = ["airflow", "superset", "finance_dw", "marketing_dw"]
  
  tags = {
    environment = "dev"
    application = "data-platform"
  }
}