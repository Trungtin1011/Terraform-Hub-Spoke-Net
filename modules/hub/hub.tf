resource "azurerm_virtual_network" "hub-vnet" {
  name                = "${var.hub-name}-network"
  address_space       = [var.hub-address-space]
  location            = var.location
  resource_group_name = var.rg_name

  environment = var.environment
}

resource "azurerm_subnet" "hub-subnet" {
  name                 = "${var.hub-name}-subnet"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.hub-vnet.name
  address_prefixes     = [var.hub-address-prefixes]
}