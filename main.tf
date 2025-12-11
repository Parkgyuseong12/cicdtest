terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
  use_oidc = true
}

# 1. 리소스 그룹
resource "azurerm_resource_group" "dr_rg" {
  name     = "rg-dr-aks-demo"
  location = "koreacentral"
}

# 2. AKS 클러스터 (가장 저렴한 옵션)
resource "azurerm_kubernetes_cluster" "dr_aks" {
  name                = "aks-dr-demo"
  location            = azurerm_resource_group.dr_rg.location
  resource_group_name = azurerm_resource_group.dr_rg.name
  dns_prefix          = "aks-dr-demo"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_B2s" # 저렴한 B시리즈 VM 사용
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "DR-Test"
  }
}

# 3. 중요: 나중에 GitHub Action이 접속할 수 있게 클러스터 이름 출력
output "aks_name" {
  value = azurerm_kubernetes_cluster.dr_aks.name
}

output "resource_group_name" {
  value = azurerm_resource_group.dr_rg.name
}
