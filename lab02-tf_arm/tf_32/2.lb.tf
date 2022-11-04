resource "azurerm_lb" "lb" {
  name                = "BalanceMyLoad"
  location            = azurerm_resource_group.lb-rg.location
  resource_group_name = azurerm_resource_group.lb-rg.name
}
