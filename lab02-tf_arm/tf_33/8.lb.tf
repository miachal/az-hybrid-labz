resource "azurerm_public_ip" "lbpip" {
  name                = "LBpip"
  location            = azurerm_resource_group.dev-prolab-rg[0].location
  resource_group_name = azurerm_resource_group.dev-prolab-rg[0].name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_lb" "lb" {
  name                = "BalanceMyLoad"
  location            = azurerm_resource_group.dev-prolab-rg[0].location
  resource_group_name = azurerm_resource_group.dev-prolab-rg[0].name

  sku_tier = "Regional"
  sku      = "Standard"


  frontend_ip_configuration {
    name                 = var.lb_fic_name
    public_ip_address_id = azurerm_public_ip.lbpip.id
  }
}

resource "azurerm_lb_backend_address_pool" "lbbepool" {
  name            = "lbbepool"
  loadbalancer_id = azurerm_lb.lb.id
}

resource "azurerm_lb_backend_address_pool_address" "lbbap-vm01" {
  name                    = "lbap-vm01"
  backend_address_pool_id = azurerm_lb_backend_address_pool.lbbepool.id
  virtual_network_id      = azurerm_virtual_network.vnet-dev-10-100-0-0--16.id
  ip_address              = azurerm_linux_virtual_machine.VM-WFE01-DEV.private_ip_address
}

resource "azurerm_lb_backend_address_pool_address" "lbbap-vm02" {
  name                    = "lbap-vm02"
  backend_address_pool_id = azurerm_lb_backend_address_pool.lbbepool.id
  virtual_network_id      = azurerm_virtual_network.vnet-dev-10-100-0-0--16.id
  ip_address              = azurerm_linux_virtual_machine.VM-WFE02-DEV.private_ip_address
}

resource "azurerm_lb_probe" "lbprobe" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "apache-health-probe"
  protocol        = "Http"
  port            = 80
  request_path    = "/"
}

resource "azurerm_lb_rule" "lbrule80" {
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "lbrule80"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = var.lb_fic_name
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.lbbepool.id]
  probe_id                       = azurerm_lb_probe.lbprobe.id
  disable_outbound_snat          = true
}

resource "azurerm_lb_outbound_rule" "lboutboundrule" {
  loadbalancer_id         = azurerm_lb.lb.id
  name                    = "lboutboundrule"
  protocol                = "All"
  backend_address_pool_id = azurerm_lb_backend_address_pool.lbbepool.id



  frontend_ip_configuration {
    name = var.lb_fic_name
  }
}
