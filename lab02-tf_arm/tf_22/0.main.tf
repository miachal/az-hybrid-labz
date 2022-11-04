provider "azurerm" {
  subscription_id = "subscription-id"
  features {}
}

provider "azuread" {
  tenant_id = "tenant-id"
}
