data "azurerm_resource_group" "rg" {
  name = azurerm_resource_group.dev-net-rg.name
}

resource "azurerm_service_plan" "asplan" {
  name                = "asplan54218"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "F1"
}

resource "azurerm_linux_web_app" "webapp" {
  name                = "webapp538151"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  service_plan_id     = azurerm_service_plan.asplan.id
  site_config {
    always_on = false
  }
}
