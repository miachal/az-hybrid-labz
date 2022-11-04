data "azurerm_subscription" "sub" {}

resource "azurerm_role_assignment" "tfreader" {
  scope                = data.azurerm_subscription.sub.id
  principal_id         = azuread_user.tfuser.object_id
  role_definition_name = "Reader"
}
