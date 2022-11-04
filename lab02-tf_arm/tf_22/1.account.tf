resource "azuread_user" "tfuser" {
  user_principal_name = "tfuser@tinkiwinki.onmicrosoft.com"
  display_name        = "Tf User"
  password            = "Dupa123@@"
}
