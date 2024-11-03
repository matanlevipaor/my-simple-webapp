provider "azurerm" {
  features {}
  subscription_id = "2ca56b45-9606-4d04-b356-3e8eb0374ce4"
}

resource "azurerm_resource_group" "rg" {
  name     = "my-terraform-rg"
  location = "West US"
}

resource "azurerm_app_service_plan" "asp" {
  name = "myAppServicePlan"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku {
    tier = "Free"
    size = "F1"
  }
}

resource "azurerm_app_service" "app" {
  name                = "my-simple-webapp-azure"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.asp.id

  site_config {
    scm_type = "None"
  }
}

output "app_service_default_hostname" {
  value = azurerm_app_service.app.default_site_hostname
}
terraform {
  backend "azurerm" {
    resource_group_name  = "terraform-backend-rg"
    storage_account_name = "terraformbackend12345"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
