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

# 테스트용으로 만드는 '리소스 그룹' (나중에 삭제할 것임)
resource "azurerm_resource_group" "dr_test" {
  name     = "rg-dr-success-test"
  location = "koreacentral"
  
  tags = {
    Status = "Created-By-GitHub-Action"
  }
}
